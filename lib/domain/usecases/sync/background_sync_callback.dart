import 'package:workmanager/workmanager.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/local/secure_storage/secure_storage_service.dart';
import '../../../data/remote/dio_client.dart';
import '../../../data/remote/simplefin/simplefin_client.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/bank_connection_repository.dart';
import '../../../data/repositories/import_repository.dart';
import '../../../data/repositories/auto_categorize_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../domain/usecases/categorize/auto_categorize_service.dart';
import '../../../domain/usecases/sync/simplefin_sync_service.dart';

import 'background_sync_manager.dart';

/// Top-level callback dispatcher for WorkManager.
///
/// Runs in a separate isolate on Android — cannot use Riverpod providers.
/// Opens its own database instance and creates dependencies manually.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != backgroundSyncTaskName) return true;

    AppDatabase? db;
    try {
      db = await AppDatabase.open();

      final secureStorage = SecureStorageService();
      final dio = createSimplefinDioClient();
      final simplefinClient = SimplefinClient(dio);
      final connectionRepo = BankConnectionRepository(db);
      final accountRepo = AccountRepository(db);
      final transactionRepo = TransactionRepository(db);
      final importRepo = ImportRepository(db);

      // Reset stale sync locks from any previous crash
      await connectionRepo.resetAllSyncLocks();

      final autoCatRepo = AutoCategorizeRepository(db);
      final autoCatService = AutoCategorizeService(autoCatRepo, transactionRepo);

      final syncService = SimplefinSyncService(
        simplefinClient: simplefinClient,
        secureStorage: secureStorage,
        connectionRepo: connectionRepo,
        accountRepo: accountRepo,
        transactionRepo: transactionRepo,
        importRepo: importRepo,
        autoCategorizeService: autoCatService,
      );

      // Only sync connections that are in a healthy state
      final connections = await connectionRepo.getAllConnections();
      for (final connection in connections) {
        if (connection.status != ConnectionStatus.connected) continue;
        await syncService.syncConnection(connection.id);
      }

      return true;
    } catch (_) {
      return false;
    } finally {
      await db?.close();
    }
  });
}
