import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/app_error.dart';
import '../../../data/local/database/app_database.dart';
import '../../../data/local/secure_storage/secure_storage_service.dart';
import '../../../data/remote/simplefin/simplefin_client.dart';
import '../../../data/remote/simplefin/simplefin_models.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/bank_connection_repository.dart';
import '../../../data/repositories/import_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../categorize/auto_categorize_service.dart';

// =============================================================================
// DATA CLASSES
// =============================================================================

/// Result of a sync operation.
class SyncResult {
  final String connectionId;
  final int accountsUpdated;
  final int transactionsImported;
  final int transactionsSkipped;
  final int apiTransactionsReceived;
  final String? errorMessage;
  final bool rateLimited;

  const SyncResult({
    required this.connectionId,
    this.accountsUpdated = 0,
    this.transactionsImported = 0,
    this.transactionsSkipped = 0,
    this.apiTransactionsReceived = 0,
    this.errorMessage,
    this.rateLimited = false,
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

// =============================================================================
// SERVICE
// =============================================================================

/// Orchestrates SimpleFIN bank sync operations.
///
/// Handles token claiming, account syncing, rate limiting,
/// and circuit breaker logic. Circuit breaker state is persisted
/// in the database to survive app restarts.
class SimplefinSyncService {
  SimplefinSyncService({
    required SimplefinClient simplefinClient,
    required SecureStorageService secureStorage,
    required BankConnectionRepository connectionRepo,
    required AccountRepository accountRepo,
    required TransactionRepository transactionRepo,
    required ImportRepository importRepo,
    required AutoCategorizeService autoCategorizeService,
  })  : _simplefinClient = simplefinClient,
        _secureStorage = secureStorage,
        _connectionRepo = connectionRepo,
        _accountRepo = accountRepo,
        _transactionRepo = transactionRepo,
        _importRepo = importRepo,
        _autoCategorizeService = autoCategorizeService;

  final SimplefinClient _simplefinClient;
  final SecureStorageService _secureStorage;
  final BankConnectionRepository _connectionRepo;
  final AccountRepository _accountRepo;
  final TransactionRepository _transactionRepo;
  final ImportRepository _importRepo;
  final AutoCategorizeService _autoCategorizeService;

  static const _uuid = Uuid();

  /// Claim a setup token and create a bank connection.
  ///
  /// Returns the connection ID on success.
  Future<String> claimAndConnect(String base64Token) async {
    try {
      // 1. Claim the token to get access URL
      final accessUrl = await _simplefinClient.claimSetupToken(base64Token);

      // 2. Store access URL in secure storage
      await _secureStorage.setSimplefinToken(accessUrl.toString());

      // 3. Fetch accounts (balances only) to get institution info
      final response = await _simplefinClient.getAccounts(
        accessUrl,
        balancesOnly: true,
      );

      // Determine institution name from first account
      String institutionName = 'SimpleFIN';
      if (response.accounts.isNotEmpty) {
        final first = response.accounts.first;
        institutionName =
            first.orgName ?? first.orgDomain ?? first.name;
      }

      // 4. Create bank connection record
      final connectionId = _uuid.v4();
      final now = DateTime.now().millisecondsSinceEpoch;

      await _connectionRepo.insertConnection(BankConnectionsCompanion.insert(
        id: connectionId,
        provider: 'simplefin',
        institutionName: institutionName,
        status: ConnectionStatus.connected,
        createdAt: now,
        updatedAt: now,
      ));

      return connectionId;
    } on SimplefinApiException catch (e) {
      if (e.statusCode == 403) {
        throw BankSyncError.tokenCompromised();
      }
      if (e.statusCode == 402) {
        throw BankSyncError.paymentRequired();
      }
      throw BankSyncError(message: e.message);
    }
  }

  /// Sync a connection's accounts and transactions.
  ///
  /// Uses a database-level sync lock to prevent concurrent syncs
  /// across isolates. Circuit breaker state is persisted in DB.
  Future<SyncResult> syncConnection(String connectionId) async {
    // Check rate limiting / circuit breaker
    if (!await canSync(connectionId)) {
      return SyncResult(
        connectionId: connectionId,
        rateLimited: true,
        errorMessage: 'Rate limited. Please wait before syncing again.',
      );
    }

    // Acquire sync lock (atomic check-and-set in DB)
    final acquired = await _connectionRepo.tryAcquireSyncLock(connectionId);
    if (!acquired) {
      return SyncResult(
        connectionId: connectionId,
        errorMessage: 'Sync already in progress for this connection.',
      );
    }

    try {
      // Load access URL
      final tokenString = await _secureStorage.getSimplefinToken();
      if (tokenString == null) {
        throw const BankSyncError(
          message: 'No SimpleFIN credentials found. Please reconnect.',
        );
      }
      final accessUrl = SimplefinAccessUrl.parse(tokenString);

      // Set status to syncing
      await _connectionRepo.updateStatus(
        connectionId,
        ConnectionStatus.syncing,
      );

      final connection = await _connectionRepo.getConnectionById(connectionId);
      final now = DateTime.now();

      // Fetch all available transactions from SimpleFIN — dedup logic
      // handles filtering out previously-imported entries.
      final response = await _simplefinClient.getAccounts(
        accessUrl,
        includePending: true,
      );

      // Check for API-level errors (institution failures, etc.)
      if (response.errors.isNotEmpty) {
        debugPrint(
          'SimpleFIN sync: API returned errors: ${response.errors}',
        );
      }

      // Count total transactions received from the API (before dedup)
      var apiTransactionsReceived = 0;
      for (final sfAccount in response.accounts) {
        apiTransactionsReceived += sfAccount.transactions.length;
        debugPrint(
          'SimpleFIN sync: account "${sfAccount.name}" returned '
          '${sfAccount.transactions.length} transactions'
          '${sfAccount.lastUpdatedUnix != null ? ', last-updated: ${DateTime.fromMillisecondsSinceEpoch(sfAccount.lastUpdatedUnix! * 1000).toIso8601String()}' : ''}',
        );
      }

      var accountsUpdated = 0;
      var transactionsImported = 0;
      var transactionsSkipped = 0;

      // Preload categorization rules once for the entire sync
      final rules = await _autoCategorizeService.loadEnabledRules();

      // Load linked accounts once (same query for every SF account)
      final linkedAccounts =
          await _accountRepo.getAccountsByConnection(connectionId);

      if (kDebugMode) {
        debugPrint(
          'SimpleFIN sync: ${linkedAccounts.length} accounts linked to '
          'connection $connectionId, externalIds: '
          '${linkedAccounts.map((a) => a.externalId).toList()}',
        );
      }

      // Process each account
      for (final sfAccount in response.accounts) {
        // Find linked local account — first by connection, then fallback
        var localAccount = linkedAccounts
            .where((a) => a.externalId == sfAccount.id)
            .firstOrNull;

        // Fallback: account may exist with correct externalId but wrong/null
        // bankConnectionId (e.g. after disconnect/reconnect cycle)
        if (localAccount == null) {
          final fallback =
              await _accountRepo.getAccountByExternalId(sfAccount.id);
          if (fallback != null) {
            // Auto-repair: re-associate account with current connection
            await _accountRepo.linkToBank(
                fallback.id, connectionId, sfAccount.id);
            localAccount = fallback;
            if (kDebugMode) {
              debugPrint(
                'SimpleFIN sync: repaired account "${fallback.name}" '
                '(${fallback.id}) — re-linked to connection $connectionId',
              );
            }
          }
        }

        if (localAccount == null) {
          if (kDebugMode) {
            debugPrint(
              'SimpleFIN sync: no local account for SF account '
              '"${sfAccount.name}" (externalId: ${sfAccount.id}) — skipping',
            );
          }
          continue;
        }

        // Update balance
        await _accountRepo.updateBalance(
          localAccount.id,
          sfAccount.balanceCents,
        );
        await _accountRepo.updateLastSyncedAt(localAccount.id);
        accountsUpdated++;

        // Process transactions — batch-load known IDs to avoid N+1 queries
        final externalIdPrefix = '$connectionId:';
        final knownIds = await _transactionRepo.getExternalIdsByPrefix(
            externalIdPrefix, localAccount.id);
        final pendingTxns = await _transactionRepo.getPendingByPrefix(
            externalIdPrefix, localAccount.id);

        for (final sfTxn in sfAccount.transactions) {
          final externalId = '$externalIdPrefix${sfTxn.id}';

          // Check for existing transaction (O(1) set lookup)
          if (knownIds.contains(externalId)) {
            // When a pending transaction posts, update amount/date/description
            // (banks often adjust these when a pending charge clears)
            final pendingTxn = pendingTxns[externalId];
            if (pendingTxn != null && !sfTxn.isPending) {
              final dateUnixExisting =
                  sfTxn.transactedAtUnix ?? sfTxn.postedUnix;
              await _transactionRepo.updateTransaction(
                TransactionsCompanion(
                  id: Value(pendingTxn.id),
                  amountCents: Value(sfTxn.amountCents),
                  date: Value(dateUnixExisting * 1000),
                  payee: Value(sfTxn.description),
                  isPending: const Value(false),
                  updatedAt: Value(now.millisecondsSinceEpoch),
                ),
              );
            }
            transactionsSkipped++;
            continue;
          }

          // Determine date (prefer transactedAt, fall back to posted)
          final dateUnix = sfTxn.transactedAtUnix ?? sfTxn.postedUnix;
          final dateMillis = dateUnix * 1000;

          // Fuzzy dedup: catch duplicates from other sources (e.g. CSV import)
          final fuzzyMatch = await _transactionRepo.existsByFuzzyMatch(
            localAccount.id, dateMillis, sfTxn.amountCents,
            excludeExternalIdPrefix: externalIdPrefix,
          );
          if (fuzzyMatch) {
            if (kDebugMode) {
              debugPrint(
                'SimpleFIN sync: fuzzy dedup skipped '
                '"${sfTxn.description}" ${sfTxn.amountCents}c on $dateMillis '
                'for account ${localAccount.id}',
              );
            }
            transactionsSkipped++;
            continue;
          }

          // Insert new transaction
          final txnId = _uuid.v4();
          final nowMillis = now.millisecondsSinceEpoch;

          await _transactionRepo.insertTransaction(
            TransactionsCompanion.insert(
              id: txnId,
              accountId: localAccount.id,
              amountCents: sfTxn.amountCents,
              date: dateMillis,
              payee: sfTxn.description,
              externalId: Value(externalId),
              isPending: Value(sfTxn.isPending),
              createdAt: nowMillis,
              updatedAt: nowMillis,
            ),
          );

          // Auto-categorize the new transaction
          final categoryId =
              await _autoCategorizeService.categorizeWithPreloadedRules(
            sfTxn.description,
            rules,
            amountCents: sfTxn.amountCents,
            accountId: localAccount.id,
          );
          if (categoryId != null) {
            await _transactionRepo.updateCategory(txnId, categoryId);
          }

          transactionsImported++;
        }
      }

      // Update connection
      final nowMillis = now.millisecondsSinceEpoch;
      await _connectionRepo.updateLastSyncedAt(connectionId, nowMillis);
      await _connectionRepo.updateStatus(
        connectionId,
        ConnectionStatus.connected,
      );

      // Record import history
      final institutionName =
          connection?.institutionName ?? 'SimpleFIN';
      await _importRepo.insertImportRecord(ImportHistoryCompanion.insert(
        id: _uuid.v4(),
        source: 'simplefin',
        fileName: institutionName,
        rowCount: transactionsImported + transactionsSkipped,
        importedCount: transactionsImported,
        skippedCount: transactionsSkipped,
        status: 'completed',
        bankConnectionId: Value(connectionId),
        createdAt: nowMillis,
      ));

      // Reset circuit breaker on success
      await _connectionRepo.updateCircuitBreakerState(
        connectionId,
        consecutiveFailures: 0,
        lastFailureTime: null,
      );

      return SyncResult(
        connectionId: connectionId,
        accountsUpdated: accountsUpdated,
        transactionsImported: transactionsImported,
        transactionsSkipped: transactionsSkipped,
        apiTransactionsReceived: apiTransactionsReceived,
        errorMessage: response.errors.isNotEmpty
            ? 'Bank warnings: ${response.errors.join('; ')}'
            : null,
      );
    } on SimplefinApiException catch (e) {
      await _recordFailure(connectionId);
      final errorMsg = e.message;
      await _connectionRepo.updateStatus(
        connectionId,
        ConnectionStatus.error,
        errorMessage: errorMsg,
      );
      return SyncResult(
        connectionId: connectionId,
        errorMessage: errorMsg,
      );
    } catch (e) {
      await _recordFailure(connectionId);
      final errorMsg = e is AppError ? e.message : e.toString();
      await _connectionRepo.updateStatus(
        connectionId,
        ConnectionStatus.error,
        errorMessage: errorMsg,
      );
      return SyncResult(
        connectionId: connectionId,
        errorMessage: errorMsg,
      );
    } finally {
      // Always release sync lock
      await _connectionRepo.releaseSyncLock(connectionId);
    }
  }

  /// Check if a sync is allowed (rate limiting + circuit breaker).
  Future<bool> canSync(String connectionId) async {
    // Check circuit breaker (persisted in DB)
    final cb = await _connectionRepo.getCircuitBreakerState(connectionId);
    if (cb.consecutiveFailures >= AppConstants.maxConsecutiveSyncFailures) {
      final backoff = _getBackoffDuration(cb.consecutiveFailures);
      if (cb.lastFailureTime != null) {
        final lastFailure =
            DateTime.fromMillisecondsSinceEpoch(cb.lastFailureTime!);
        if (DateTime.now().difference(lastFailure) < backoff) {
          return false;
        }
      }
      // Backoff period elapsed, allow retry
    }

    // Check minimum interval
    final connection = await _connectionRepo.getConnectionById(connectionId);
    if (connection?.lastSyncedAt != null) {
      final lastSync =
          DateTime.fromMillisecondsSinceEpoch(connection!.lastSyncedAt!);
      final elapsed = DateTime.now().difference(lastSync);
      if (elapsed.inMinutes < AppConstants.minSyncIntervalMinutes) {
        return false;
      }
    }

    // Check daily sync count
    final todayStart = DateTime.now();
    final startOfDay =
        DateTime(todayStart.year, todayStart.month, todayStart.day)
            .millisecondsSinceEpoch;
    final todaySyncs = await _importRepo.countBySourceSince('simplefin', startOfDay);
    if (todaySyncs >= AppConstants.maxDailySyncs) {
      return false;
    }

    return true;
  }

  /// Get the time until the next sync is allowed.
  Future<Duration?> timeUntilNextSync(String connectionId) async {
    // Check circuit breaker first (persisted in DB)
    final cb = await _connectionRepo.getCircuitBreakerState(connectionId);
    if (cb.consecutiveFailures >= AppConstants.maxConsecutiveSyncFailures &&
        cb.lastFailureTime != null) {
      final backoff = _getBackoffDuration(cb.consecutiveFailures);
      final lastFailure =
          DateTime.fromMillisecondsSinceEpoch(cb.lastFailureTime!);
      final elapsed = DateTime.now().difference(lastFailure);
      if (elapsed < backoff) {
        return backoff - elapsed;
      }
    }

    // Check minimum interval
    final connection = await _connectionRepo.getConnectionById(connectionId);
    if (connection?.lastSyncedAt != null) {
      final lastSync =
          DateTime.fromMillisecondsSinceEpoch(connection!.lastSyncedAt!);
      final elapsed = DateTime.now().difference(lastSync);
      final minInterval =
          const Duration(minutes: AppConstants.minSyncIntervalMinutes);
      if (elapsed < minInterval) {
        return minInterval - elapsed;
      }
    }

    return null;
  }

  /// Disconnect a bank connection.
  ///
  /// Clears credentials, unlinks accounts, updates status.
  /// Does NOT delete transaction history.
  Future<void> disconnect(String connectionId) async {
    // Only clear credentials if no other SimpleFIN connections remain
    final allConnections = await _connectionRepo.getAllConnections();
    final otherSimplefin = allConnections.where(
      (c) => c.provider == 'simplefin' && c.id != connectionId && c.status != ConnectionStatus.disconnected,
    );
    if (otherSimplefin.isEmpty) {
      await _secureStorage.clearSimplefinToken();
    }

    // Unlink all accounts tied to this connection
    final linkedAccounts =
        await _accountRepo.getAccountsByConnection(connectionId);
    for (final account in linkedAccounts) {
      await _accountRepo.unlinkFromBank(account.id);
    }

    // Update connection status
    await _connectionRepo.updateStatus(
      connectionId,
      ConnectionStatus.disconnected,
    );
  }

  /// Record a failure in the circuit breaker (persisted to DB).
  Future<void> _recordFailure(String connectionId) async {
    final cb = await _connectionRepo.getCircuitBreakerState(connectionId);
    await _connectionRepo.updateCircuitBreakerState(
      connectionId,
      consecutiveFailures: cb.consecutiveFailures + 1,
      lastFailureTime: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Exponential backoff: 5min, 30min, 2hr.
  Duration _getBackoffDuration(int failures) {
    return switch (failures) {
      <= 3 => const Duration(minutes: 5),
      <= 5 => const Duration(minutes: 30),
      _ => const Duration(hours: 2),
    };
  }
}
