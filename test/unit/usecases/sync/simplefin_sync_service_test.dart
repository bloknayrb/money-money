import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrimonium/core/constants/app_constants.dart';
import 'package:patrimonium/data/local/database/app_database.dart';
import 'package:patrimonium/data/local/secure_storage/secure_storage_service.dart';
import 'package:patrimonium/data/remote/simplefin/simplefin_client.dart';
import 'package:patrimonium/data/remote/simplefin/simplefin_models.dart';
import 'package:patrimonium/data/repositories/account_repository.dart';
import 'package:patrimonium/data/repositories/bank_connection_repository.dart';
import 'package:patrimonium/data/repositories/import_repository.dart';
import 'package:patrimonium/data/repositories/transaction_repository.dart';
import 'package:patrimonium/domain/usecases/categorize/auto_categorize_service.dart';
import 'package:patrimonium/domain/usecases/sync/simplefin_sync_service.dart';

// =============================================================================
// Mocks
// =============================================================================

class MockSimplefinClient extends Mock implements SimplefinClient {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockBankConnectionRepository extends Mock
    implements BankConnectionRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockImportRepository extends Mock implements ImportRepository {}

class MockAutoCategorizeService extends Mock implements AutoCategorizeService {}

void main() {
  late MockSimplefinClient mockClient;
  late MockSecureStorageService mockSecureStorage;
  late MockBankConnectionRepository mockConnectionRepo;
  late MockAccountRepository mockAccountRepo;
  late MockTransactionRepository mockTxnRepo;
  late MockImportRepository mockImportRepo;
  late MockAutoCategorizeService mockAutoCatService;
  late SimplefinSyncService service;

  const connectionId = 'conn-1';
  const accountId = 'acc-1';
  const tokenString = 'https://user:pass@api.simplefin.org/simplefin';

  setUp(() {
    mockClient = MockSimplefinClient();
    mockSecureStorage = MockSecureStorageService();
    mockConnectionRepo = MockBankConnectionRepository();
    mockAccountRepo = MockAccountRepository();
    mockTxnRepo = MockTransactionRepository();
    mockImportRepo = MockImportRepository();
    mockAutoCatService = MockAutoCategorizeService();

    service = SimplefinSyncService(
      simplefinClient: mockClient,
      secureStorage: mockSecureStorage,
      connectionRepo: mockConnectionRepo,
      accountRepo: mockAccountRepo,
      transactionRepo: mockTxnRepo,
      importRepo: mockImportRepo,
      autoCategorizeService: mockAutoCatService,
    );
  });

  setUpAll(() {
    registerFallbackValue(TransactionsCompanion.insert(
      id: '',
      accountId: '',
      amountCents: 0,
      date: 0,
      payee: '',
      createdAt: 0,
      updatedAt: 0,
    ));
    registerFallbackValue(ImportHistoryCompanion.insert(
      id: '',
      source: '',
      fileName: '',
      rowCount: 0,
      importedCount: 0,
      skippedCount: 0,
      status: '',
      createdAt: 0,
    ));
    registerFallbackValue(const SimplefinAccessUrl(
      scheme: 'https',
      username: 'user',
      password: 'pass',
      host: 'api.simplefin.org',
      path: '/simplefin',
    ));
  });

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  BankConnection makeConnection({
    String id = connectionId,
    String status = 'connected',
    int? lastSyncedAt,
    int consecutiveFailures = 0,
    int? lastFailureTime,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return BankConnection(
      id: id,
      provider: 'simplefin',
      institutionName: 'Test Bank',
      status: status,
      lastSyncedAt: lastSyncedAt,
      consecutiveFailures: consecutiveFailures,
      lastFailureTime: lastFailureTime,
      isSyncing: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  Account makeAccount({
    String id = accountId,
    String? bankConnectionId = connectionId,
    String? externalId = 'sf-acc-1',
    bool invertSign = false,
  }) {
    return Account(
      id: id,
      name: 'Checking',
      accountType: 'checking',
      balanceCents: 100000,
      currencyCode: 'USD',
      isAsset: true,
      isHidden: false,
      invertSign: invertSign,
      displayOrder: 0,
      bankConnectionId: bankConnectionId,
      externalId: externalId,
      createdAt: 0,
      updatedAt: 0,
      version: 1,
      syncStatus: 0,
    );
  }

  Transaction makeTransaction({
    required String id,
    String externalId = 'conn-1:sf-txn-1',
    bool isPending = false,
  }) {
    return Transaction(
      id: id,
      accountId: accountId,
      amountCents: -500,
      date: DateTime.now().millisecondsSinceEpoch,
      payee: 'STARBUCKS',
      notes: null,
      categoryId: null,
      tags: null,
      externalId: externalId,
      isPending: isPending,
      isReviewed: false,
      createdAt: 0,
      updatedAt: 0,
      version: 1,
      syncStatus: 0,
    );
  }

  /// Set up mocks so canSync returns true.
  void stubCanSyncTrue() {
    when(() => mockConnectionRepo.getCircuitBreakerState(connectionId))
        .thenAnswer(
      (_) async => (consecutiveFailures: 0, lastFailureTime: null),
    );
    when(() => mockConnectionRepo.getConnectionById(connectionId))
        .thenAnswer((_) async => makeConnection());
    when(() => mockImportRepo.countBySourceSince(any(), any()))
        .thenAnswer((_) async => 0);
  }

  /// Set up mocks for a successful sync with one account and no transactions.
  void stubBasicSuccessfulSync() {
    stubCanSyncTrue();
    when(() => mockConnectionRepo.tryAcquireSyncLock(connectionId))
        .thenAnswer((_) async => true);
    when(() => mockSecureStorage.getSimplefinToken())
        .thenAnswer((_) async => tokenString);
    when(() => mockConnectionRepo.updateStatus(any(), any(),
        errorMessage: any(named: 'errorMessage'))).thenAnswer((_) async {});
    when(() => mockClient.getAccounts(any(),
            includePending: any(named: 'includePending')))
        .thenAnswer((_) async => const SimplefinAccountsResponse(accounts: []));
    when(() => mockAutoCatService.loadEnabledRules())
        .thenAnswer((_) async => []);
    when(() => mockAccountRepo.getAccountsByConnection(connectionId))
        .thenAnswer((_) async => []);
    when(() => mockTxnRepo.getExternalIdsByPrefix(any(), any()))
        .thenAnswer((_) async => {});
    when(() => mockTxnRepo.getPendingByPrefix(any(), any()))
        .thenAnswer((_) async => {});
    when(() => mockConnectionRepo.updateLastSyncedAt(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockImportRepo.insertImportRecord(any()))
        .thenAnswer((_) async {});
    when(() => mockConnectionRepo.updateCircuitBreakerState(
          any(),
          consecutiveFailures: any(named: 'consecutiveFailures'),
          lastFailureTime: any(named: 'lastFailureTime'),
        )).thenAnswer((_) async {});
    when(() => mockConnectionRepo.releaseSyncLock(any()))
        .thenAnswer((_) async {});
  }

  // ===========================================================================
  // syncConnection
  // ===========================================================================

  group('syncConnection', () {
    test('returns rate-limited result when canSync returns false', () async {
      // Arrange: circuit breaker tripped
      when(() => mockConnectionRepo.getCircuitBreakerState(connectionId))
          .thenAnswer((_) async => (
                consecutiveFailures: AppConstants.maxConsecutiveSyncFailures,
                lastFailureTime: DateTime.now().millisecondsSinceEpoch,
              ));

      // Act
      final result = await service.syncConnection(connectionId);

      // Assert
      expect(result.rateLimited, isTrue);
      expect(result.errorMessage, contains('Rate limited'));
      verifyNever(() => mockConnectionRepo.tryAcquireSyncLock(any()));
    });

    test('returns error when sync lock cannot be acquired', () async {
      stubCanSyncTrue();
      when(() => mockConnectionRepo.tryAcquireSyncLock(connectionId))
          .thenAnswer((_) async => false);

      final result = await service.syncConnection(connectionId);

      expect(result.errorMessage, contains('already in progress'));
      expect(result.rateLimited, isFalse);
    });

    test('updates account balances from SimpleFIN data', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount();
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 250000,
                    balanceDateUnix: 1700000000,
                  ),
                ],
              ));

      final result = await service.syncConnection(connectionId);

      expect(result.accountsUpdated, 1);
      expect(result.apiTransactionsReceived, 0);
      verify(() => mockAccountRepo.updateBalance(accountId, 250000)).called(1);
      verify(() => mockAccountRepo.updateLastSyncedAt(accountId)).called(1);
    });

    test('inserts new transactions', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount();
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});
      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any(),
            excludeExternalIdPrefix: any(named: 'excludeExternalIdPrefix')))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransaction(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(), any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
            accountType: any(named: 'accountType'),
          )).thenAnswer((_) async => null);

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: -500,
                        description: 'STARBUCKS',
                      ),
                    ],
                  ),
                ],
              ));

      final result = await service.syncConnection(connectionId);

      expect(result.transactionsImported, 1);
      expect(result.apiTransactionsReceived, 1);
      verify(() => mockTxnRepo.insertTransaction(any())).called(1);
    });

    test('skips existing transactions by external ID', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount();
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});

      // Batch lookup returns the existing externalId
      when(() => mockTxnRepo.getExternalIdsByPrefix(any(), any()))
          .thenAnswer((_) async => {'$connectionId:sf-txn-1'});
      when(() => mockTxnRepo.getPendingByPrefix(any(), any()))
          .thenAnswer((_) async => {});

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: -500,
                        description: 'STARBUCKS',
                      ),
                    ],
                  ),
                ],
              ));

      final result = await service.syncConnection(connectionId);

      expect(result.transactionsSkipped, 1);
      expect(result.transactionsImported, 0);
      verifyNever(() => mockTxnRepo.insertTransaction(any()));
    });

    test('skips fuzzy-matched transactions', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount();
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});
      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any(),
            excludeExternalIdPrefix: any(named: 'excludeExternalIdPrefix')))
          .thenAnswer((_) async => true);

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: -500,
                        description: 'STARBUCKS',
                      ),
                    ],
                  ),
                ],
              ));

      final result = await service.syncConnection(connectionId);

      expect(result.transactionsSkipped, 1);
      expect(result.transactionsImported, 0);
      verifyNever(() => mockTxnRepo.insertTransaction(any()));
    });

    test('updates pending-to-posted transitions', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount();
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});

      // Existing pending transaction — returned by batch lookups
      final pendingTxn = makeTransaction(id: 'existing-1', isPending: true);
      when(() => mockTxnRepo.getExternalIdsByPrefix(any(), any()))
          .thenAnswer((_) async => {'$connectionId:sf-txn-1'});
      when(() => mockTxnRepo.getPendingByPrefix(any(), any())).thenAnswer(
          (_) async => {'$connectionId:sf-txn-1': pendingTxn});
      when(() => mockTxnRepo.updateTransaction(any()))
          .thenAnswer((_) async => true);

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: -550,
                        description: 'STARBUCKS UPDATED',
                        isPending: false,
                      ),
                    ],
                  ),
                ],
              ));

      final result = await service.syncConnection(connectionId);

      // Pending→posted counts as skipped (not imported)
      expect(result.transactionsSkipped, 1);
      verify(() => mockTxnRepo.updateTransaction(any())).called(1);
    });

    test('auto-categorizes new transactions using preloaded rules', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount();
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});
      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any(),
            excludeExternalIdPrefix: any(named: 'excludeExternalIdPrefix')))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransaction(any()))
          .thenAnswer((_) async {});
      when(() => mockTxnRepo.updateCategory(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(), any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
            accountType: any(named: 'accountType'),
          )).thenAnswer((_) async => 'cat-dining');

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: -500,
                        description: 'STARBUCKS',
                      ),
                    ],
                  ),
                ],
              ));

      await service.syncConnection(connectionId);

      verify(() => mockTxnRepo.updateCategory(any(), 'cat-dining')).called(1);
    });

    test('falls back to externalId match when bankConnectionId is wrong',
        () async {
      stubBasicSuccessfulSync();
      // Account exists but linked to a different (old) connection
      final orphanedAccount = makeAccount(bankConnectionId: 'old-conn');
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => []); // not found by connection
      when(() => mockAccountRepo.getAccountByExternalId('sf-acc-1'))
          .thenAnswer((_) async => orphanedAccount);
      when(() => mockAccountRepo.linkToBank(any(), any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 250000,
                    balanceDateUnix: 1700000000,
                  ),
                ],
              ));

      final result = await service.syncConnection(connectionId);

      expect(result.accountsUpdated, 1);
      // Verify it re-linked the account to the current connection
      verify(() => mockAccountRepo.linkToBank(accountId, connectionId, 'sf-acc-1'))
          .called(1);
      verify(() => mockAccountRepo.updateBalance(accountId, 250000)).called(1);
    });

    test('records import history on success', () async {
      stubBasicSuccessfulSync();

      await service.syncConnection(connectionId);

      verify(() => mockImportRepo.insertImportRecord(any())).called(1);
    });

    test('resets circuit breaker on success', () async {
      stubBasicSuccessfulSync();

      await service.syncConnection(connectionId);

      verify(() => mockConnectionRepo.updateCircuitBreakerState(
            connectionId,
            consecutiveFailures: 0,
            lastFailureTime: null,
          )).called(1);
    });

    test('records failure and updates circuit breaker on error', () async {
      stubCanSyncTrue();
      when(() => mockConnectionRepo.tryAcquireSyncLock(connectionId))
          .thenAnswer((_) async => true);
      when(() => mockSecureStorage.getSimplefinToken())
          .thenAnswer((_) async => tokenString);
      when(() => mockConnectionRepo.updateStatus(any(), any(),
          errorMessage: any(named: 'errorMessage'))).thenAnswer((_) async {});
      when(() => mockConnectionRepo.releaseSyncLock(any()))
          .thenAnswer((_) async {});

      // Circuit breaker reads current state, then increments
      when(() => mockConnectionRepo.getCircuitBreakerState(connectionId))
          .thenAnswer(
        (_) async => (consecutiveFailures: 0, lastFailureTime: null),
      );
      when(() => mockConnectionRepo.updateCircuitBreakerState(
            any(),
            consecutiveFailures: any(named: 'consecutiveFailures'),
            lastFailureTime: any(named: 'lastFailureTime'),
          )).thenAnswer((_) async {});

      // API call throws
      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenThrow(const SimplefinApiException(
              statusCode: 500, message: 'Server error'));

      final result = await service.syncConnection(connectionId);

      expect(result.errorMessage, contains('Server error'));
      verify(() => mockConnectionRepo.updateCircuitBreakerState(
            connectionId,
            consecutiveFailures: 1,
            lastFailureTime: any(named: 'lastFailureTime'),
          )).called(1);
      verify(() => mockConnectionRepo.updateStatus(
            connectionId,
            ConnectionStatus.error,
            errorMessage: any(named: 'errorMessage'),
          )).called(1);
    });

    test('releases sync lock on success', () async {
      stubBasicSuccessfulSync();

      await service.syncConnection(connectionId);

      verify(() => mockConnectionRepo.releaseSyncLock(connectionId)).called(1);
    });

    test('releases sync lock on error', () async {
      stubCanSyncTrue();
      when(() => mockConnectionRepo.tryAcquireSyncLock(connectionId))
          .thenAnswer((_) async => true);
      when(() => mockSecureStorage.getSimplefinToken())
          .thenAnswer((_) async => tokenString);
      when(() => mockConnectionRepo.updateStatus(any(), any(),
          errorMessage: any(named: 'errorMessage'))).thenAnswer((_) async {});
      when(() => mockConnectionRepo.getCircuitBreakerState(connectionId))
          .thenAnswer(
        (_) async => (consecutiveFailures: 0, lastFailureTime: null),
      );
      when(() => mockConnectionRepo.updateCircuitBreakerState(
            any(),
            consecutiveFailures: any(named: 'consecutiveFailures'),
            lastFailureTime: any(named: 'lastFailureTime'),
          )).thenAnswer((_) async {});
      when(() => mockConnectionRepo.releaseSyncLock(any()))
          .thenAnswer((_) async {});

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenThrow(Exception('boom'));

      await service.syncConnection(connectionId);

      verify(() => mockConnectionRepo.releaseSyncLock(connectionId)).called(1);
    });

    test('subsequent sync imports new transactions while skipping known ones',
        () async {
      // Arrange: connection has been synced before
      final previousSyncTime =
          DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch;
      stubBasicSuccessfulSync();
      when(() => mockConnectionRepo.getConnectionById(connectionId))
          .thenAnswer((_) async => makeConnection(lastSyncedAt: previousSyncTime));

      final localAccount = makeAccount();
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});

      // sf-txn-old is already known; sf-txn-new is not
      when(() => mockTxnRepo.getExternalIdsByPrefix(any(), any()))
          .thenAnswer((_) async => {'$connectionId:sf-txn-old'});
      when(() => mockTxnRepo.getPendingByPrefix(any(), any()))
          .thenAnswer((_) async => {});
      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any(),
            excludeExternalIdPrefix: any(named: 'excludeExternalIdPrefix')))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransaction(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(), any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
            accountType: any(named: 'accountType'),
          )).thenAnswer((_) async => null);

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-old',
                        postedUnix: 1699000000,
                        amountCents: -1000,
                        description: 'OLD COFFEE',
                      ),
                      SimplefinTransaction(
                        id: 'sf-txn-new',
                        postedUnix: 1700000000,
                        amountCents: -2000,
                        description: 'NEW GROCERY',
                      ),
                    ],
                  ),
                ],
              ));

      // Act
      final result = await service.syncConnection(connectionId);

      // Assert: only the new transaction is imported; the old one is skipped
      expect(result.transactionsImported, 1);
      expect(result.transactionsSkipped, 1);
      expect(result.apiTransactionsReceived, 2);
      verify(() => mockTxnRepo.insertTransaction(any())).called(1);
    });

    test('includes API errors in result when response has errors', () async {
      stubBasicSuccessfulSync();

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                errors: ['Institution temporarily unavailable'],
                accounts: [],
              ));

      final result = await service.syncConnection(connectionId);

      expect(result.errorMessage, contains('Institution temporarily unavailable'));
      expect(result.apiTransactionsReceived, 0);
      expect(result.accountsUpdated, 0);
    });

    test('apiTransactionsReceived counts all transactions before dedup',
        () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount();
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});

      // All 3 transactions are already known
      when(() => mockTxnRepo.getExternalIdsByPrefix(any(), any()))
          .thenAnswer((_) async => {
                '$connectionId:sf-txn-1',
                '$connectionId:sf-txn-2',
                '$connectionId:sf-txn-3',
              });
      when(() => mockTxnRepo.getPendingByPrefix(any(), any()))
          .thenAnswer((_) async => {});

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: -500,
                        description: 'TXN 1',
                      ),
                      SimplefinTransaction(
                        id: 'sf-txn-2',
                        postedUnix: 1700000000,
                        amountCents: -600,
                        description: 'TXN 2',
                      ),
                      SimplefinTransaction(
                        id: 'sf-txn-3',
                        postedUnix: 1700000000,
                        amountCents: -700,
                        description: 'TXN 3',
                      ),
                    ],
                  ),
                ],
              ));

      final result = await service.syncConnection(connectionId);

      expect(result.apiTransactionsReceived, 3);
      expect(result.transactionsImported, 0);
      expect(result.transactionsSkipped, 3);
    });

    test('negates transaction amounts when account has invertSign=true',
        () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount(invertSign: true);
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});
      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any(),
            excludeExternalIdPrefix: any(named: 'excludeExternalIdPrefix')))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransaction(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(), any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
            accountType: any(named: 'accountType'),
          )).thenAnswer((_) async => null);

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: 500, // positive from bank
                        description: 'STARBUCKS',
                      ),
                    ],
                  ),
                ],
              ));

      await service.syncConnection(connectionId);

      // Verify the inserted transaction has negated amount
      final captured =
          verify(() => mockTxnRepo.insertTransaction(captureAny()))
              .captured
              .first as TransactionsCompanion;
      expect(captured.amountCents.value, -500);
    });

    test('invertSign negates amount in fuzzy dedup check', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount(invertSign: true);
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});
      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any(),
            excludeExternalIdPrefix: any(named: 'excludeExternalIdPrefix')))
          .thenAnswer((_) async => true);

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: 500,
                        description: 'STARBUCKS',
                      ),
                    ],
                  ),
                ],
              ));

      await service.syncConnection(connectionId);

      // Verify fuzzy dedup was called with negated amount
      verify(() => mockTxnRepo.existsByFuzzyMatch(
            accountId,
            any(),
            -500, // negated
            excludeExternalIdPrefix: any(named: 'excludeExternalIdPrefix'),
          )).called(1);
    });

    test('invertSign negates amount in pending transaction update', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount(invertSign: true);
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});

      final pendingTxn = makeTransaction(id: 'existing-1', isPending: true);
      when(() => mockTxnRepo.getExternalIdsByPrefix(any(), any()))
          .thenAnswer((_) async => {'$connectionId:sf-txn-1'});
      when(() => mockTxnRepo.getPendingByPrefix(any(), any())).thenAnswer(
          (_) async => {'$connectionId:sf-txn-1': pendingTxn});
      when(() => mockTxnRepo.updateTransaction(any()))
          .thenAnswer((_) async => true);

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: 550,
                        description: 'STARBUCKS UPDATED',
                        isPending: false,
                      ),
                    ],
                  ),
                ],
              ));

      await service.syncConnection(connectionId);

      final captured =
          verify(() => mockTxnRepo.updateTransaction(captureAny()))
              .captured
              .first as TransactionsCompanion;
      expect(captured.amountCents.value, -550);
    });

    test('invertSign negates amount passed to auto-categorize', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount(invertSign: true);
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});
      when(() => mockTxnRepo.existsByFuzzyMatch(any(), any(), any(),
            excludeExternalIdPrefix: any(named: 'excludeExternalIdPrefix')))
          .thenAnswer((_) async => false);
      when(() => mockTxnRepo.insertTransaction(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(), any(),
            amountCents: any(named: 'amountCents'),
            accountId: any(named: 'accountId'),
            accountType: any(named: 'accountType'),
          )).thenAnswer((_) async => null);

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 100000,
                    balanceDateUnix: 1700000000,
                    transactions: [
                      SimplefinTransaction(
                        id: 'sf-txn-1',
                        postedUnix: 1700000000,
                        amountCents: 500,
                        description: 'STARBUCKS',
                      ),
                    ],
                  ),
                ],
              ));

      await service.syncConnection(connectionId);

      verify(() => mockAutoCatService.categorizeWithPreloadedRules(
            any(), any(),
            amountCents: -500, // negated
            accountId: accountId,
            accountType: any(named: 'accountType'),
          )).called(1);
    });

    test('does not invert balance when invertSign=true', () async {
      stubBasicSuccessfulSync();
      final localAccount = makeAccount(invertSign: true);
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => [localAccount]);
      when(() => mockAccountRepo.updateBalance(any(), any()))
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.updateLastSyncedAt(any()))
          .thenAnswer((_) async {});

      when(() => mockClient.getAccounts(any(),
              includePending: any(named: 'includePending')))
          .thenAnswer((_) async => const SimplefinAccountsResponse(
                accounts: [
                  SimplefinAccount(
                    id: 'sf-acc-1',
                    name: 'Checking',
                    currency: 'USD',
                    balanceCents: 250000,
                    balanceDateUnix: 1700000000,
                  ),
                ],
              ));

      await service.syncConnection(connectionId);

      // Balance should NOT be inverted
      verify(() => mockAccountRepo.updateBalance(accountId, 250000)).called(1);
    });
  });

  // ===========================================================================
  // canSync
  // ===========================================================================

  group('canSync', () {
    test('returns false when circuit breaker is tripped and backoff active',
        () async {
      when(() => mockConnectionRepo.getCircuitBreakerState(connectionId))
          .thenAnswer((_) async => (
                consecutiveFailures: AppConstants.maxConsecutiveSyncFailures,
                lastFailureTime: DateTime.now().millisecondsSinceEpoch,
              ));

      final result = await service.canSync(connectionId);

      expect(result, isFalse);
    });

    test('returns true when backoff period has elapsed', () async {
      // Failed 3 times, but 10 minutes ago (backoff for <=3 is 5min)
      final tenMinAgo =
          DateTime.now().subtract(const Duration(minutes: 10)).millisecondsSinceEpoch;
      when(() => mockConnectionRepo.getCircuitBreakerState(connectionId))
          .thenAnswer((_) async => (
                consecutiveFailures: AppConstants.maxConsecutiveSyncFailures,
                lastFailureTime: tenMinAgo,
              ));
      when(() => mockConnectionRepo.getConnectionById(connectionId))
          .thenAnswer((_) async => makeConnection());
      when(() => mockImportRepo.countBySourceSince(any(), any()))
          .thenAnswer((_) async => 0);

      final result = await service.canSync(connectionId);

      expect(result, isTrue);
    });

    test('returns false when minimum sync interval has not passed', () async {
      when(() => mockConnectionRepo.getCircuitBreakerState(connectionId))
          .thenAnswer(
        (_) async => (consecutiveFailures: 0, lastFailureTime: null),
      );
      // Last synced 5 minutes ago (min interval is 15 min)
      final fiveMinAgo =
          DateTime.now().subtract(const Duration(minutes: 5)).millisecondsSinceEpoch;
      when(() => mockConnectionRepo.getConnectionById(connectionId))
          .thenAnswer((_) async => makeConnection(lastSyncedAt: fiveMinAgo));

      final result = await service.canSync(connectionId);

      expect(result, isFalse);
    });

    test('returns false when daily sync count exceeds max', () async {
      when(() => mockConnectionRepo.getCircuitBreakerState(connectionId))
          .thenAnswer(
        (_) async => (consecutiveFailures: 0, lastFailureTime: null),
      );
      when(() => mockConnectionRepo.getConnectionById(connectionId))
          .thenAnswer((_) async => makeConnection());
      when(() => mockImportRepo.countBySourceSince(any(), any()))
          .thenAnswer((_) async => AppConstants.maxDailySyncs);

      final result = await service.canSync(connectionId);

      expect(result, isFalse);
    });

    test('returns true when all checks pass', () async {
      when(() => mockConnectionRepo.getCircuitBreakerState(connectionId))
          .thenAnswer(
        (_) async => (consecutiveFailures: 0, lastFailureTime: null),
      );
      when(() => mockConnectionRepo.getConnectionById(connectionId))
          .thenAnswer((_) async => makeConnection());
      when(() => mockImportRepo.countBySourceSince(any(), any()))
          .thenAnswer((_) async => 0);

      final result = await service.canSync(connectionId);

      expect(result, isTrue);
    });
  });

  // ===========================================================================
  // disconnect
  // ===========================================================================

  group('disconnect', () {
    test('clears credentials when no other SimpleFIN connections exist',
        () async {
      when(() => mockConnectionRepo.getAllConnections())
          .thenAnswer((_) async => [makeConnection()]);
      when(() => mockSecureStorage.clearSimplefinToken())
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => []);
      when(() => mockConnectionRepo.updateStatus(any(), any(),
          errorMessage: any(named: 'errorMessage'))).thenAnswer((_) async {});

      await service.disconnect(connectionId);

      verify(() => mockSecureStorage.clearSimplefinToken()).called(1);
    });

    test('does NOT clear credentials when other connections exist', () async {
      final otherConnection = makeConnection(id: 'conn-2');
      when(() => mockConnectionRepo.getAllConnections())
          .thenAnswer((_) async => [makeConnection(), otherConnection]);
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => []);
      when(() => mockConnectionRepo.updateStatus(any(), any(),
          errorMessage: any(named: 'errorMessage'))).thenAnswer((_) async {});

      await service.disconnect(connectionId);

      verifyNever(() => mockSecureStorage.clearSimplefinToken());
    });

    test('unlinks all accounts from the connection', () async {
      final accounts = [
        makeAccount(id: 'acc-1'),
        makeAccount(id: 'acc-2'),
      ];
      when(() => mockConnectionRepo.getAllConnections())
          .thenAnswer((_) async => [makeConnection()]);
      when(() => mockSecureStorage.clearSimplefinToken())
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => accounts);
      when(() => mockAccountRepo.unlinkFromBank(any()))
          .thenAnswer((_) async {});
      when(() => mockConnectionRepo.updateStatus(any(), any(),
          errorMessage: any(named: 'errorMessage'))).thenAnswer((_) async {});

      await service.disconnect(connectionId);

      verify(() => mockAccountRepo.unlinkFromBank('acc-1')).called(1);
      verify(() => mockAccountRepo.unlinkFromBank('acc-2')).called(1);
    });

    test('updates connection status to disconnected', () async {
      when(() => mockConnectionRepo.getAllConnections())
          .thenAnswer((_) async => [makeConnection()]);
      when(() => mockSecureStorage.clearSimplefinToken())
          .thenAnswer((_) async {});
      when(() => mockAccountRepo.getAccountsByConnection(connectionId))
          .thenAnswer((_) async => []);
      when(() => mockConnectionRepo.updateStatus(any(), any(),
          errorMessage: any(named: 'errorMessage'))).thenAnswer((_) async {});

      await service.disconnect(connectionId);

      verify(() => mockConnectionRepo.updateStatus(
            connectionId,
            ConnectionStatus.disconnected,
          )).called(1);
    });
  });
}
