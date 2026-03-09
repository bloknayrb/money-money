import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'domain/usecases/sync/background_sync_callback.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WorkManager for background sync (Android only)
  if (Platform.isAndroid) {
    await Workmanager().initialize(callbackDispatcher);
  }

  // Open the database
  final database = await AppDatabase.open();

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

  // TODO: Initialize Sentry
  // await SentryFlutter.init(
  //   (options) {
  //     options.dsn = 'YOUR_SENTRY_DSN';
  //     options.tracesSampleRate = 0.1;
  //   },
  //   appRunner: () => _runApp(database),
  // );

  _runApp(database);
}

void _runApp(AppDatabase database) {
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const PatrimoniumApp(),
    ),
  );
}
