import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'core/di/providers.dart';
import 'data/local/database/app_database.dart';
import 'data/repositories/account_repository.dart';
import 'data/repositories/auto_categorize_repository.dart';
import 'data/repositories/bank_connection_repository.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/transaction_repository.dart';
import 'domain/usecases/categories/category_seeder.dart';
import 'domain/usecases/categorize/auto_categorize_service.dart';
import 'domain/usecases/categorize/rule_seeder.dart';
import 'domain/usecases/dev/dev_data_seeder.dart';
import 'data/local/secure_storage/secure_storage_service.dart';
import 'domain/usecases/auth/pin_service.dart';
import 'domain/usecases/sync/background_sync_callback.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager for background sync (Android only)
  if (Platform.isAndroid) {
    await Workmanager().initialize(callbackDispatcher);
  }

  // Open the database with crash recovery
  late final AppDatabase database;
  try {
    database = await AppDatabase.open();
  } catch (e) {
    if (kDebugMode) debugPrint('Database open failed: $e');
    runApp(_DatabaseErrorApp(error: e));
    return;
  }

  // Seed default categories if this is a fresh install
  final categoryRepo = CategoryRepository(database);
  final seeder = CategorySeeder(categoryRepo);
  try {
    await seeder.seedIfEmpty();
  } catch (e) {
    if (kDebugMode) debugPrint('Category seeding failed: $e');
  }

  // Seed dev data in debug mode (before rule seeding so auto-categorize picks them up)
  if (kDebugMode) {
    try {
      final devSeeder = DevDataSeeder(
        AccountRepository(database),
        TransactionRepository(database),
      );
      final seeded = await devSeeder.seedIfEmpty();
      if (seeded) debugPrint('Dev data seeded successfully');
    } catch (e) {
      debugPrint('Dev data seeding failed: $e');
    }
  }

  // Seed default auto-categorization rules and apply to existing transactions
  try {
    final autoCatRepo = AutoCategorizeRepository(database);
    final ruleSeeder = RuleSeeder(categoryRepo, autoCatRepo);
    final rulesSeeded = await ruleSeeder.seedIfEmpty();

    if (rulesSeeded) {
      final txnRepo = TransactionRepository(database);
      final autoCatService = AutoCategorizeService(autoCatRepo, txnRepo);
      await autoCatService.categorizeUncategorized();
    }
  } catch (e) {
    if (kDebugMode) debugPrint('Rule seeding failed: $e');
  }

  // Reset stale sync locks from any previous crash
  try {
    final connectionRepo = BankConnectionRepository(database);
    await connectionRepo.resetAllSyncLocks();
  } catch (e) {
    if (kDebugMode) debugPrint('Sync lock reset failed: $e');
  }

  // Cache PIN state for synchronous router redirects
  final pinService = PinService(SecureStorageService());
  final hasPin = await pinService.hasPin();

  // Initialize Sentry for crash reporting (DSN provided at build time)
  const sentryDsn = String.fromEnvironment('SENTRY_DSN');
  if (sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        options.tracesSampleRate = 1.0; // 100% — single-user personal app
        options.environment = kReleaseMode ? 'production' : 'debug';
      },
      appRunner: () => _runApp(database, hasPin: hasPin),
    );
  } else {
    _runApp(database, hasPin: hasPin);
  }
}

void _runApp(AppDatabase database, {bool hasPin = false}) {
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        hasPinCachedProvider.overrideWith((_) => hasPin),
      ],
      child: const PatrimoniumApp(),
    ),
  );
}

/// Standalone error UI shown when the database fails to open.
/// Does not depend on Riverpod, GoRouter, or any app infrastructure.
class _DatabaseErrorApp extends StatelessWidget {
  final Object error;

  const _DatabaseErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storage_rounded, size: 64),
                const SizedBox(height: 24),
                const Text(
                  'Database Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The database could not be opened. This may be caused by '
                  'a corrupted file. You can reset the database to start '
                  'fresh, but all local data will be lost.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Builder(builder: (context) {
                  return FilledButton.icon(
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Reset Database'),
                    onPressed: () => _confirmReset(context),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Database?'),
        content: const Text(
          'This will delete all local data including accounts, '
          'transactions, and settings. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dbFolder.path, 'patrimonium.db'));
      if (await dbFile.exists()) await dbFile.delete();
      // Restart the app flow
      main();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset failed: $e')),
      );
    }
  }
}
