import '../../../data/local/database/app_database.dart';
import 'simplefin_sync_service.dart';

/// Aggregated result from syncing multiple connections.
class SyncSummary {
  final int accountsUpdated;
  final int transactionsImported;
  final int apiTransactionsReceived;
  final String? firstError;
  final List<AccountSyncDetail> accountDetails;

  const SyncSummary({
    this.accountsUpdated = 0,
    this.transactionsImported = 0,
    this.apiTransactionsReceived = 0,
    this.firstError,
    this.accountDetails = const [],
  });
}

/// Orchestrates sync across multiple bank connections.
class SyncOrchestrator {
  SyncOrchestrator(this._syncService);

  final SimplefinSyncService _syncService;

  /// Sync all provided connections, aggregating results.
  Future<SyncSummary> syncAllConnected(List<BankConnection> connections) async {
    var totalAccounts = 0;
    var totalTransactions = 0;
    var totalApiReceived = 0;
    String? firstError;
    final allAccountDetails = <AccountSyncDetail>[];

    for (final conn in connections) {
      try {
        final result = await _syncService.syncConnection(conn.id);
        totalAccounts += result.accountsUpdated;
        totalTransactions += result.transactionsImported;
        totalApiReceived += result.apiTransactionsReceived;
        allAccountDetails.addAll(result.accountDetails);
        if (result.errorMessage != null && firstError == null) {
          firstError = result.errorMessage;
        }
      } catch (e) {
        firstError ??= e.toString();
      }
    }

    return SyncSummary(
      accountsUpdated: totalAccounts,
      transactionsImported: totalTransactions,
      apiTransactionsReceived: totalApiReceived,
      firstError: firstError,
      accountDetails: allAccountDetails,
    );
  }
}
