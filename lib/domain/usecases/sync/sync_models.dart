/// Per-account breakdown of what happened during sync.
class AccountSyncDetail {
  final String sfAccountName;
  final String sfAccountId;
  final bool linked;
  final String? localAccountName;
  final int received;
  final int imported;
  final int skippedKnown;
  final int pendingPosted;
  final int skippedFuzzy;

  const AccountSyncDetail({
    required this.sfAccountName,
    required this.sfAccountId,
    required this.linked,
    this.localAccountName,
    this.received = 0,
    this.imported = 0,
    this.skippedKnown = 0,
    this.pendingPosted = 0,
    this.skippedFuzzy = 0,
  });
}

/// Result of a sync operation.
class SyncResult {
  final String connectionId;
  final int accountsUpdated;
  final int transactionsImported;
  final int transactionsSkipped;
  final int apiTransactionsReceived;
  final String? errorMessage;
  final bool rateLimited;
  final List<AccountSyncDetail> accountDetails;

  const SyncResult({
    required this.connectionId,
    this.accountsUpdated = 0,
    this.transactionsImported = 0,
    this.transactionsSkipped = 0,
    this.apiTransactionsReceived = 0,
    this.errorMessage,
    this.rateLimited = false,
    this.accountDetails = const [],
  });
}

/// Connection status constants.
class ConnectionStatus {
  ConnectionStatus._();

  static const String connected = 'connected';
  static const String syncing = 'syncing';
  static const String error = 'error';
  static const String disconnected = 'disconnected';
  static const String rateLimited = 'rate_limited';
}
