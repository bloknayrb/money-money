import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymoney/core/constants/app_constants.dart';
import 'package:moneymoney/data/local/database/app_database.dart';
import 'package:moneymoney/data/repositories/account_repository.dart';
import 'package:moneymoney/data/repositories/auto_categorize_repository.dart';
import 'package:moneymoney/data/repositories/transaction_repository.dart';
import 'package:moneymoney/domain/usecases/categorize/auto_categorize_service.dart';
import 'package:moneymoney/domain/usecases/categorize/default_rules_data.dart';

class MockAutoCategorizeRepository extends Mock
    implements AutoCategorizeRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockAutoCategorizeRepository mockAutoCatRepo;
  late MockTransactionRepository mockTxnRepo;
  late AutoCategorizeService service;

  setUp(() {
    mockAutoCatRepo = MockAutoCategorizeRepository();
    mockTxnRepo = MockTransactionRepository();
    service = AutoCategorizeService(mockAutoCatRepo, mockTxnRepo);
  });

  setUpAll(() {
    registerFallbackValue(PayeeCategoryCacheCompanion.insert(
      payeeNormalized: '',
      categoryId: '',
      confidence: 0,
      source: '',
      updatedAt: 0,
    ));
    registerFallbackValue(CategorizationCorrectionsCompanion.insert(
      id: '',
      transactionId: '',
      newCategoryId: '',
      payee: '',
      createdAt: 0,
    ));
  });

  group('normalizePayee', () {
    test('converts to uppercase and trims', () {
      expect(service.normalizePayee('  starbucks  '), equals('STARBUCKS'));
    });

    test('strips SQ * prefix', () {
      expect(service.normalizePayee('SQ *COFFEE SHOP'), equals('COFFEE SHOP'));
    });

    test('strips TST* prefix', () {
      expect(service.normalizePayee('TST*RESTAURANT'), equals('RESTAURANT'));
    });

    test('strips TST* prefix with space', () {
      expect(
          service.normalizePayee('TST* RESTAURANT'), equals('RESTAURANT'));
    });

    test('strips PAYPAL * prefix', () {
      expect(
          service.normalizePayee('PAYPAL *SOMESTORE'), equals('SOMESTORE'));
    });

    test('strips SP * prefix', () {
      expect(service.normalizePayee('SP *MERCHANT'), equals('MERCHANT'));
    });

    test('strips GOOGLE * prefix', () {
      expect(service.normalizePayee('GOOGLE *STORAGE'), equals('STORAGE'));
    });

    test('strips APL* prefix', () {
      expect(service.normalizePayee('APL*ITUNES'), equals('ITUNES'));
    });

    test('normalizes AMZN MKTP US to AMAZON', () {
      expect(
          service.normalizePayee('AMZN MKTP US*ABC123XYZ'), equals('AMAZON'));
    });

    test('normalizes AMAZON.COM to AMAZON', () {
      expect(
          service.normalizePayee('AMAZON.COM*Z12345'), equals('AMAZON'));
    });

    test('normalizes AMZN to AMAZON', () {
      expect(service.normalizePayee('AMZN Marketplace'), equals('AMAZON'));
    });

    test('strips trailing reference numbers', () {
      expect(service.normalizePayee('RESTAURANT #1234'), equals('RESTAURANT'));
    });

    test('strips trailing state and zip', () {
      expect(service.normalizePayee('GROCERY STORE CA 90210'),
          equals('GROCERY STORE'));
    });

    test('collapses multiple spaces', () {
      expect(
          service.normalizePayee('SOME   STORE   NAME'), equals('SOME STORE NAME'));
    });

    test('handles empty string', () {
      expect(service.normalizePayee(''), equals(''));
    });

    test('handles only whitespace', () {
      expect(service.normalizePayee('   '), equals(''));
    });

    test('strips trailing store identifier S1', () {
      expect(
          service.normalizePayee('SHOPRITE ELIZABETH S1'),
          equals('SHOPRITE ELIZABETH'));
    });

    test('strips trailing STORE with number', () {
      expect(
          service.normalizePayee('WALMART STORE 1234'),
          equals('WALMART'));
    });

    test('strips both store ID and trailing date', () {
      expect(service.normalizePayee('TARGET T1234 12/05'), equals('TARGET'));
    });

    test('strips trailing reference ID', () {
      expect(
          service.normalizePayee('VENMO PAYMENT ABC123XYZ'),
          equals('VENMO PAYMENT'));
    });
  });

  group('payeeSimilarity', () {
    test('returns 1.0 for identical strings', () {
      expect(
          AutoCategorizeService.payeeSimilarity(
              'CHASE CREDIT CARD', 'CHASE CREDIT CARD'),
          equals(1.0));
    });

    test('returns partial overlap for shared tokens', () {
      final score = AutoCategorizeService.payeeSimilarity(
          'SHOPRITE ELIZABETH', 'SHOPRITE NEWARK');
      // 1 shared (SHOPRITE) of 3 union (SHOPRITE, ELIZABETH, NEWARK)
      expect(score, closeTo(0.33, 0.01));
    });

    test('returns 0.0 for no shared tokens', () {
      expect(
          AutoCategorizeService.payeeSimilarity('STARBUCKS', 'TARGET'),
          equals(0.0));
    });

    test('ignores single-character tokens', () {
      // 'A' is ignored, so tokens are {STORE} vs {STORE} = 1.0
      expect(
          AutoCategorizeService.payeeSimilarity('A STORE', 'STORE'),
          equals(1.0));
    });
  });

  group('findSimilarUncategorized', () {
    test('finds exact normalized matches', () {
      final uncategorized = [
        _makeTransaction(id: 'txn-1', payee: 'SHOPRITE ELIZABETH', amountCents: -500),
        _makeTransaction(id: 'txn-2', payee: 'TARGET', amountCents: -1000),
      ];
      final matches = service.findSimilarUncategorized(
          'Shoprite Elizabeth', uncategorized);
      expect(matches.length, equals(1));
      expect(matches.first.id, equals('txn-1'));
    });

    test('finds fuzzy matches above 0.6 threshold', () {
      // 'SHOPRITE ELIZABETH' vs 'SHOPRITE NEWARK' = 0.33 (below threshold)
      // 'WALMART SUPERCENTER' vs 'WALMART NEIGHBORHOOD' = 0.33 (below)
      // 'CHASE CREDIT CARD PAYMENT' vs 'CHASE CREDIT CARD' = 0.75 (above)
      final uncategorized = [
        _makeTransaction(id: 'txn-1', payee: 'CHASE CREDIT CARD', amountCents: -500),
        _makeTransaction(id: 'txn-2', payee: 'TARGET', amountCents: -1000),
      ];
      final matches = service.findSimilarUncategorized(
          'CHASE CREDIT CARD PAYMENT', uncategorized);
      expect(matches.length, equals(1));
      expect(matches.first.id, equals('txn-1'));
    });

    test('returns empty list for empty payee', () {
      final uncategorized = [
        _makeTransaction(id: 'txn-1', payee: 'STARBUCKS', amountCents: -500),
      ];
      expect(service.findSimilarUncategorized('', uncategorized), isEmpty);
    });
  });

  group('categorize', () {
    test('returns categoryId from cache when confidence >= 0.8', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.9,
        ),
      );

      final result = await service.categorize('Starbucks');
      expect(result, equals('cat-dining'));
      verifyNever(() => mockAutoCatRepo.getEnabledRules());
    });

    test('falls through to rules when cache confidence < 0.8', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.5,
        ),
      );
      when(() => mockAutoCatRepo.getEnabledRules())
          .thenAnswer((_) async => []);

      final result = await service.categorize('Starbucks');
      expect(result, isNull);
      verify(() => mockAutoCatRepo.getEnabledRules()).called(1);
    });

    test('returns null when no cache entry and no rules match', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules())
          .thenAnswer((_) async => []);

      final result = await service.categorize('Starbucks');
      expect(result, isNull);
    });

    test('matches rule with payeeContains', () async {
      when(() => mockAutoCatRepo.getCacheEntry('WALMART SUPERCENTER', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-1',
            priority: 1,
            payeeContains: 'walmart',
            categoryId: 'cat-groceries',
          ),
        ],
      );

      final result = await service.categorize('WALMART SUPERCENTER');
      expect(result, equals('cat-groceries'));
    });

    test('matches rule with payeeExact', () async {
      when(() => mockAutoCatRepo.getCacheEntry('NETFLIX', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-1',
            priority: 1,
            payeeExact: 'NETFLIX',
            categoryId: 'cat-entertainment',
          ),
        ],
      );

      final result = await service.categorize('Netflix');
      expect(result, equals('cat-entertainment'));
    });

    test('respects rule priority order (first match wins)', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-1',
            priority: 1,
            payeeContains: 'starbucks',
            categoryId: 'cat-dining',
          ),
          _makeRule(
            id: 'rule-2',
            priority: 2,
            payeeContains: 'starbucks',
            categoryId: 'cat-groceries',
          ),
        ],
      );

      final result = await service.categorize('Starbucks');
      expect(result, equals('cat-dining'));
    });

    test('rule with amount range filters correctly', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STORE', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-1',
            priority: 1,
            payeeContains: 'store',
            amountMinCents: -5000,
            amountMaxCents: -100,
            categoryId: 'cat-shopping',
          ),
        ],
      );

      // Amount in range
      final result1 =
          await service.categorize('Store', amountCents: -2000);
      expect(result1, equals('cat-shopping'));

      // Amount out of range
      final result2 =
          await service.categorize('Store', amountCents: -10000);
      expect(result2, isNull);
    });
  });

  group('recordCategoryAssignment', () {
    test('creates new cache entry for unknown payee', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-dining',
      );

      final captured = verify(
        () => mockAutoCatRepo.upsertCacheEntry(captureAny()),
      ).captured.single as PayeeCategoryCacheCompanion;

      expect(captured.payeeNormalized.value, equals('STARBUCKS'));
      expect(captured.categoryId.value, equals('cat-dining'));
      expect(captured.confidence.value, equals(0.5));
      expect(captured.useCount.value, equals(1));
    });

    test('increments useCount for same category', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.6,
          useCount: 1,
        ),
      );
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-dining',
      );

      final captured = verify(
        () => mockAutoCatRepo.upsertCacheEntry(captureAny()),
      ).captured.single as PayeeCategoryCacheCompanion;

      expect(captured.useCount.value, equals(2));
      expect(captured.confidence.value, equals(0.7)); // 0.5 + 2*0.1
    });

    test(
        'mismatch on useCount=1 entry adopts new category at baseline (flip)',
        () async {
      // useCount=1 means no learning to protect; new category wins.
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.6,
          useCount: 1,
        ),
      );
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-groceries',
      );

      final captured = verify(
        () => mockAutoCatRepo.upsertCacheEntry(captureAny()),
      ).captured.single as PayeeCategoryCacheCompanion;

      expect(captured.categoryId.value, equals('cat-groceries'));
      expect(captured.useCount.value, equals(1));
      expect(captured.confidence.value, equals(0.5));
    });

    test(
        'mismatch on useCount=2 entry keeps old category (boundary at >= 1)',
        () async {
      // Boundary case: useCount=2 means penalized=1, which is exactly the
      // >= 1 threshold. A regression that flips the check to > 1 would
      // silently flip useCount=2 entries instead of keeping them.
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.7,
          useCount: 2,
        ),
      );
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-groceries',
      );

      final captured = verify(
        () => mockAutoCatRepo.upsertCacheEntry(captureAny()),
      ).captured.single as PayeeCategoryCacheCompanion;

      expect(captured.categoryId.value, equals('cat-dining'));
      expect(captured.useCount.value, equals(1));
      expect(captured.confidence.value, closeTo(0.6, 1e-9));
    });

    test(
        'correction is logged even when cache keeps old category on mismatch',
        () async {
      // When dominance-keep preserves the old categoryId, the correction
      // log must still record the user's actual choice for audit purposes.
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.8,
          useCount: 3,
        ),
      );
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatRepo.insertCorrection(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-groceries',
        transactionId: 'txn-1',
        oldCategoryId: 'cat-dining',
      );

      // Cache kept old category.
      final cacheCaptured = verify(
        () => mockAutoCatRepo.upsertCacheEntry(captureAny()),
      ).captured.single as PayeeCategoryCacheCompanion;
      expect(cacheCaptured.categoryId.value, equals('cat-dining'));

      // But the correction was still logged with the user's intent.
      final corrCaptured = verify(
        () => mockAutoCatRepo.insertCorrection(captureAny()),
      ).captured.single as CategorizationCorrectionsCompanion;
      expect(corrCaptured.oldCategoryId.value, equals('cat-dining'));
      expect(corrCaptured.newCategoryId.value, equals('cat-groceries'));
    });

    test(
        'mismatch on useCount=3 entry keeps old category, demoted to useCount=2',
        () async {
      // useCount=3 is the minimum threshold (confidence=0.8). A single
      // misclick demotes it to useCount=2/confidence=0.7 — falls below
      // threshold so the user is prompted next time, but learning is
      // preserved.
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.8,
          useCount: 3,
        ),
      );
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-groceries',
      );

      final captured = verify(
        () => mockAutoCatRepo.upsertCacheEntry(captureAny()),
      ).captured.single as PayeeCategoryCacheCompanion;

      // Old category preserved (dominance-keep)
      expect(captured.categoryId.value, equals('cat-dining'));
      expect(captured.useCount.value, equals(2));
      expect(captured.confidence.value, closeTo(0.7, 1e-9));
    });

    test(
        'mismatch on useCount=8 entry keeps old category, confidence clamps to 1.0',
        () async {
      // High-confidence stability: a strong learning signal isn't wiped by
      // one misclick.
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 1.0,
          useCount: 8,
        ),
      );
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-groceries',
      );

      final captured = verify(
        () => mockAutoCatRepo.upsertCacheEntry(captureAny()),
      ).captured.single as PayeeCategoryCacheCompanion;

      expect(captured.categoryId.value, equals('cat-dining'));
      expect(captured.useCount.value, equals(7));
      expect(captured.confidence.value, equals(1.0));
    });

    test('logs correction when oldCategoryId differs', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});
      when(() => mockAutoCatRepo.insertCorrection(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-groceries',
        transactionId: 'txn-1',
        oldCategoryId: 'cat-dining',
      );

      verify(() => mockAutoCatRepo.insertCorrection(any())).called(1);
    });

    test('does not log correction when category unchanged', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-dining',
        transactionId: 'txn-1',
        oldCategoryId: 'cat-dining',
      );

      verifyNever(() => mockAutoCatRepo.insertCorrection(any()));
    });
  });

  group('categorizeWithPreloadedRules', () {
    test('returns categoryId from cache when confidence >= 0.8', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.9,
        ),
      );

      final rules = [
        _makeRule(
          id: 'rule-1',
          priority: 1,
          payeeContains: 'starbucks',
          categoryId: 'cat-other',
        ),
      ];

      final result = await service.categorizeWithPreloadedRules(
        'Starbucks',
        rules,
      );
      expect(result, equals('cat-dining'));
      // Should NOT call getEnabledRules since rules are preloaded
      verifyNever(() => mockAutoCatRepo.getEnabledRules());
    });

    test('matches preloaded rules when cache misses', () async {
      when(() => mockAutoCatRepo.getCacheEntry('WALMART SUPERCENTER', 'standard'))
          .thenAnswer((_) async => null);

      final rules = [
        _makeRule(
          id: 'rule-1',
          priority: 1,
          payeeContains: 'walmart',
          categoryId: 'cat-groceries',
        ),
      ];

      final result = await service.categorizeWithPreloadedRules(
        'WALMART SUPERCENTER',
        rules,
      );
      expect(result, equals('cat-groceries'));
      verifyNever(() => mockAutoCatRepo.getEnabledRules());
    });

    test('returns null when no cache and no rules match', () async {
      when(() => mockAutoCatRepo.getCacheEntry('UNKNOWN STORE', 'standard'))
          .thenAnswer((_) async => null);

      final rules = [
        _makeRule(
          id: 'rule-1',
          priority: 1,
          payeeExact: 'NETFLIX',
          categoryId: 'cat-entertainment',
        ),
      ];

      final result = await service.categorizeWithPreloadedRules(
        'Unknown Store',
        rules,
      );
      expect(result, isNull);
    });

    test('returns same result as categorize() for identical rules', () async {
      final rules = [
        _makeRule(
          id: 'rule-1',
          priority: 1,
          payeeContains: 'target',
          categoryId: 'cat-shopping',
        ),
      ];

      // Setup mocks for both paths
      when(() => mockAutoCatRepo.getCacheEntry('TARGET', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules())
          .thenAnswer((_) async => rules);

      final resultPreloaded = await service.categorizeWithPreloadedRules(
        'Target',
        rules,
      );
      final resultNormal = await service.categorize('Target');

      expect(resultPreloaded, equals(resultNormal));
      expect(resultPreloaded, equals('cat-shopping'));
    });

    test('returns null for empty payee', () async {
      final rules = [
        _makeRule(
          id: 'rule-1',
          priority: 1,
          payeeContains: 'anything',
          categoryId: 'cat-1',
        ),
      ];

      final result = await service.categorizeWithPreloadedRules('', rules);
      expect(result, isNull);
    });
  });

  group('categorizeUncategorized', () {
    test('categorizes matching transactions and returns count', () async {
      final txns = [
        _makeTransaction(id: 'txn-1', payee: 'Starbucks', amountCents: -500),
        _makeTransaction(id: 'txn-2', payee: 'Unknown Store', amountCents: -1000),
      ];

      when(() => mockTxnRepo.getUncategorizedTransactions())
          .thenAnswer((_) async => txns);

      // Starbucks matches cache
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.9,
        ),
      );

      // Unknown Store has no match
      when(() => mockAutoCatRepo.getCacheEntry('UNKNOWN STORE', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules())
          .thenAnswer((_) async => []);

      when(() => mockTxnRepo.updateCategory(any(), any()))
          .thenAnswer((_) async {});

      final count = await service.categorizeUncategorized();

      expect(count, equals(1));
      verify(() => mockTxnRepo.updateCategory('txn-1', 'cat-dining')).called(1);
      verifyNever(() => mockTxnRepo.updateCategory('txn-2', any()));
    });

    test('returns 0 immediately when no uncategorized transactions', () async {
      when(() => mockTxnRepo.getUncategorizedTransactions())
          .thenAnswer((_) async => []);

      final count = await service.categorizeUncategorized();

      expect(count, equals(0));
      verifyNever(() => mockAutoCatRepo.getEnabledRules());
    });
  });

  group('categorizeUncategorized with accountType', () {
    late MockAccountRepository mockAccountRepo;
    late AutoCategorizeService serviceWithAccounts;

    setUp(() {
      mockAccountRepo = MockAccountRepository();
      serviceWithAccounts = AutoCategorizeService(
        mockAutoCatRepo,
        mockTxnRepo,
        accountRepo: mockAccountRepo,
      );
    });

    test('passes accountType from account lookup to investment rules',
        () async {
      final txns = [
        _makeTransaction(
          id: 'txn-1',
          payee: 'DIV - ISHARES RUSSELL 1000',
          amountCents: 2597,
          accountId: 'acc-401k',
        ),
      ];

      when(() => mockTxnRepo.getUncategorizedTransactions())
          .thenAnswer((_) async => txns);
      when(() => mockAccountRepo.getAllAccounts()).thenAnswer(
        (_) async => [_makeAccount(id: 'acc-401k', accountType: '401k')],
      );
      when(() => mockAutoCatRepo.getCacheEntry('DIV - ISHARES RUSSELL 1000', 'investment'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-div',
            priority: 1,
            payeeContains: 'DIV ',
            categoryId: 'cat-dividends',
            accountType: '401k',
          ),
        ],
      );
      when(() => mockTxnRepo.updateCategory(any(), any()))
          .thenAnswer((_) async {});

      final count = await serviceWithAccounts.categorizeUncategorized();

      expect(count, equals(1));
      verify(() => mockTxnRepo.updateCategory('txn-1', 'cat-dividends'))
          .called(1);
    });

    test('investment rule does NOT match without accountRepo', () async {
      // Service without accountRepo — investment rules should not fire
      final txns = [
        _makeTransaction(
          id: 'txn-1',
          payee: 'RECORDKEEPING FEE-WELLINGTON',
          amountCents: -117,
          accountId: 'acc-401k',
        ),
      ];

      when(() => mockTxnRepo.getUncategorizedTransactions())
          .thenAnswer((_) async => txns);
      // Without accountRepo, accountType resolves to null → 'standard'
      // bucket. The investment rule won't match because we lack account
      // context.
      when(() => mockAutoCatRepo.getCacheEntry(
              'RECORDKEEPING FEE-WELLINGTON', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-rk',
            priority: 1,
            payeeContains: 'RECORDKEEP',
            categoryId: 'cat-advisory-fees',
            accountType: '401k',
          ),
        ],
      );

      final count = await service.categorizeUncategorized();

      expect(count, equals(0));
      verifyNever(() => mockTxnRepo.updateCategory(any(), any()));
    });

    test('matches IQPA audit fee pattern for 401k', () async {
      final txns = [
        _makeTransaction(
          id: 'txn-1',
          payee: 'IQPA Audit Fees-Fidelity Mid Cap Index',
          amountCents: -5,
          accountId: 'acc-401k',
        ),
      ];

      when(() => mockTxnRepo.getUncategorizedTransactions())
          .thenAnswer((_) async => txns);
      when(() => mockAccountRepo.getAllAccounts()).thenAnswer(
        (_) async => [_makeAccount(id: 'acc-401k', accountType: '401k')],
      );
      when(() => mockAutoCatRepo.getCacheEntry(
              'IQPA AUDIT FEES-FIDELITY MID CAP INDEX', 'investment'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-iqpa',
            priority: 1,
            payeeContains: 'IQPA',
            categoryId: 'cat-advisory-fees',
            accountType: '401k',
          ),
        ],
      );
      when(() => mockTxnRepo.updateCategory(any(), any()))
          .thenAnswer((_) async {});

      final count = await serviceWithAccounts.categorizeUncategorized();

      expect(count, equals(1));
      verify(() => mockTxnRepo.updateCategory('txn-1', 'cat-advisory-fees'))
          .called(1);
    });

    test('matches Transfers In/Out pattern for 401k', () async {
      final txns = [
        _makeTransaction(
          id: 'txn-1',
          payee: 'Transfers In/Out-Fidelity 500 Index Fund',
          amountCents: 78664,
          accountId: 'acc-401k',
        ),
      ];

      when(() => mockTxnRepo.getUncategorizedTransactions())
          .thenAnswer((_) async => txns);
      when(() => mockAccountRepo.getAllAccounts()).thenAnswer(
        (_) async => [_makeAccount(id: 'acc-401k', accountType: '401k')],
      );
      when(() => mockAutoCatRepo.getCacheEntry(
              'TRANSFERS IN/OUT-FIDELITY 500 INDEX FUND', 'investment'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-xfer',
            priority: 1,
            payeeContains: 'TRANSFERS IN/OUT',
            categoryId: 'cat-investments',
            accountType: '401k',
          ),
        ],
      );
      when(() => mockTxnRepo.updateCategory(any(), any()))
          .thenAnswer((_) async {});

      final count = await serviceWithAccounts.categorizeUncategorized();

      expect(count, equals(1));
      verify(() => mockTxnRepo.updateCategory('txn-1', 'cat-investments'))
          .called(1);
    });

    test('investment rule does not match wrong account type', () async {
      final txns = [
        _makeTransaction(
          id: 'txn-1',
          payee: 'DIV - VANGUARD FUND',
          amountCents: 1000,
          accountId: 'acc-checking',
        ),
      ];

      when(() => mockTxnRepo.getUncategorizedTransactions())
          .thenAnswer((_) async => txns);
      when(() => mockAccountRepo.getAllAccounts()).thenAnswer(
        (_) async =>
            [_makeAccount(id: 'acc-checking', accountType: 'checking')],
      );
      // Checking account → 'standard' bucket
      when(() => mockAutoCatRepo.getCacheEntry('DIV - VANGUARD FUND', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-div',
            priority: 1,
            payeeContains: 'DIV ',
            categoryId: 'cat-dividends',
            accountType: '401k',
          ),
        ],
      );

      final count = await serviceWithAccounts.categorizeUncategorized();

      expect(count, equals(0));
      verifyNever(() => mockTxnRepo.updateCategory(any(), any()));
    });
  });

  group('categorizeWithTrace', () {
    test('returns source=cache when cache hit above threshold', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-coffee',
          confidence: 0.9,
          useCount: 5,
        ),
      );

      final trace = await service.categorizeWithTrace('Starbucks');

      expect(trace.source, equals(CategorizationSource.cache));
      expect(trace.categoryId, equals('cat-coffee'));
      expect(trace.normalizedPayee, equals('STARBUCKS'));
      expect(trace.cacheConfidence, equals(0.9));
      expect(trace.matchedRule, isNull);
    });

    test('returns source=rule when cache misses but a rule matches', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-1',
            priority: 1,
            payeeContains: 'STARBUCKS',
            categoryId: 'cat-coffee',
          ),
        ],
      );

      final trace = await service.categorizeWithTrace('Starbucks');

      expect(trace.source, equals(CategorizationSource.rule));
      expect(trace.categoryId, equals('cat-coffee'));
      expect(trace.matchedRule?.id, equals('rule-1'));
    });

    test('returns source=none when nothing matches; cacheConfidence carried '
        'through if sub-threshold cache row exists', () async {
      when(() => mockAutoCatRepo.getCacheEntry('UNKNOWN', 'standard'))
          .thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'UNKNOWN',
          categoryId: 'cat-guess',
          confidence: 0.6, // below 0.8 threshold
          useCount: 2,
        ),
      );
      when(() => mockAutoCatRepo.getEnabledRules())
          .thenAnswer((_) async => []);

      final trace = await service.categorizeWithTrace('Unknown');

      expect(trace.source, equals(CategorizationSource.none));
      expect(trace.categoryId, isNull);
      expect(trace.cacheConfidence, equals(0.6));
    });

    test('empty normalized payee returns source=none with empty payee', () async {
      final trace = await service.categorizeWithTrace('   ');
      expect(trace.source, equals(CategorizationSource.none));
      expect(trace.normalizedPayee, isEmpty);
      expect(trace.categoryId, isNull);
    });

    test(
        'source=rule carries sub-threshold cacheConfidence when a cache row '
        'exists but is below the auto-apply threshold', () async {
      // Documented behavior of CategorizationTrace: cacheConfidence is
      // populated whenever a cache row exists, even when the rule (not the
      // cache) is what produced the categoryId. Used by the UI to show
      // "we have a hint but didn't auto-apply" diagnostics.
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-guess',
          confidence: 0.6, // below 0.8 — doesn't drive the result
          useCount: 2,
        ),
      );
      when(() => mockAutoCatRepo.getEnabledRules()).thenAnswer(
        (_) async => [
          _makeRule(
            id: 'rule-coffee',
            priority: 1,
            payeeContains: 'STARBUCKS',
            categoryId: 'cat-coffee',
          ),
        ],
      );

      final trace = await service.categorizeWithTrace('Starbucks');

      expect(trace.source, equals(CategorizationSource.rule));
      expect(trace.categoryId, equals('cat-coffee'));
      expect(trace.matchedRule?.id, equals('rule-coffee'));
      expect(trace.cacheConfidence, equals(0.6));
    });
  });

  group('account-bucket cache isolation', () {
    test('cacheBucket maps investment account types to investment', () {
      expect(AutoCategorizeService.cacheBucket('brokerage'),
          equals('investment'));
      expect(AutoCategorizeService.cacheBucket('401k'), equals('investment'));
      expect(AutoCategorizeService.cacheBucket('ira'), equals('investment'));
      expect(AutoCategorizeService.cacheBucket('roth_ira'),
          equals('investment'));
      expect(AutoCategorizeService.cacheBucket('hsa'), equals('investment'));
      expect(AutoCategorizeService.cacheBucket('crypto'), equals('investment'));
    });

    test('cacheBucket maps non-investment account types to standard', () {
      expect(AutoCategorizeService.cacheBucket('checking'), equals('standard'));
      expect(AutoCategorizeService.cacheBucket('savings'), equals('standard'));
      expect(AutoCategorizeService.cacheBucket('credit_card'),
          equals('standard'));
    });

    test('cacheBucket defaults to standard for null accountType', () {
      expect(AutoCategorizeService.cacheBucket(null), equals('standard'));
    });

    test('categorize uses investment bucket when accountType is 401k', () async {
      // Standard bucket entry exists with high confidence, but the call is
      // for a 401k account — the lookup should target the investment bucket
      // and miss, falling through to rules (which we leave empty).
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'investment'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules())
          .thenAnswer((_) async => []);

      final result =
          await service.categorize('Starbucks', accountType: '401k');

      expect(result, isNull);
      verify(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'investment'))
          .called(1);
      verifyNever(
          () => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'));
    });

    test(
        'categorize hits separate cache entries per bucket for same payee',
        () async {
      // Two different cache entries: STARBUCKS in standard → Coffee, in
      // investment → Investment Fees. Each call hits the correct row.
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          accountBucket: 'standard',
          categoryId: 'cat-coffee',
          confidence: 0.9,
          useCount: 5,
        ),
      );
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'investment'))
          .thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          accountBucket: 'investment',
          categoryId: 'cat-fees',
          confidence: 0.9,
          useCount: 5,
        ),
      );

      final checkingResult =
          await service.categorize('Starbucks', accountType: 'checking');
      final brokerageResult =
          await service.categorize('Starbucks', accountType: 'brokerage');

      expect(checkingResult, equals('cat-coffee'));
      expect(brokerageResult, equals('cat-fees'));
    });

    test('recordCategoryAssignment writes to bucket derived from accountType',
        () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'investment'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-fees',
        accountType: 'brokerage',
      );

      final captured = verify(
        () => mockAutoCatRepo.upsertCacheEntry(captureAny()),
      ).captured.single as PayeeCategoryCacheCompanion;
      expect(captured.accountBucket.value, equals('investment'));
      expect(captured.payeeNormalized.value, equals('STARBUCKS'));
    });

    test('recordCategoryAssignment defaults to standard bucket when '
        'accountType is null', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS', 'standard'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.upsertCacheEntry(any()))
          .thenAnswer((_) async {});

      await service.recordCategoryAssignment(
        payee: 'Starbucks',
        categoryId: 'cat-coffee',
      );

      final captured = verify(
        () => mockAutoCatRepo.upsertCacheEntry(captureAny()),
      ).captured.single as PayeeCategoryCacheCompanion;
      expect(captured.accountBucket.value, equals('standard'));
    });
  });

  group('default rules data integrity', () {
    test('no entry uses the bare LOVE substring (false-positive risk)', () {
      // 'LOVE' as a payeeContains would match any payee with the
      // substring (e.g. "I LOVE PIZZA"). The actual gas chain is
      // 'Love's Travel Stops & Country Stores', which appears on
      // statements as 'LOVES TRAVEL' or "LOVE'S TRAVEL".
      final bare = defaultMerchantMappings.where((m) => m.$1 == 'LOVE');
      expect(bare, isEmpty);
    });

    test('LOVES TRAVEL variants map to Gas', () {
      final variants = defaultMerchantMappings
          .where((m) => m.$1.contains('LOVE') && m.$2 == 'Gas')
          .map((m) => m.$1)
          .toSet();
      expect(variants, contains('LOVES TRAVEL'));
      expect(variants, contains("LOVE'S TRAVEL"));
    });

    test('Auto Maintenance is a seeded subcategory of Transportation', () {
      final transport = DefaultCategories.expense
          .firstWhere((c) => c['name'] == 'Transportation');
      final children =
          (transport['children'] as List).cast<String>();
      expect(children, contains('Auto Maintenance'));
    });

    test('auto-maintenance merchants map to Auto Maintenance subcategory', () {
      const autoMerchants = {
        'JIFFY LUBE', 'VALVOLINE', 'FIRESTONE', 'AUTOZONE', 'PEP BOYS',
        "O'REILLY", 'ADVANCE AUTO', 'NAPA AUTO', 'MIDAS', 'GOODYEAR',
        'DISCOUNT TIRE', 'MAACO', 'MEINEKE', 'SAFELITE',
      };
      for (final m in autoMerchants) {
        final rule = defaultMerchantMappings
            .firstWhere((r) => r.$1 == m, orElse: () => ('', ''));
        expect(rule.$1, isNotEmpty,
            reason: '$m should be present in defaultMerchantMappings');
        expect(rule.$2, equals('Auto Maintenance'),
            reason: '$m should map to Auto Maintenance, got "${rule.$2}"');
      }
    });

    test('every default rule targets a category that exists in seed data', () {
      final allCategoryNames = <String>{
        for (final c in DefaultCategories.expense) ...[
          c['name'] as String,
          ...((c['children'] as List?) ?? const []).cast<String>(),
        ],
        for (final c in DefaultCategories.income) ...[
          c['name'] as String,
          ...((c['children'] as List?) ?? const []).cast<String>(),
        ],
      };
      for (final (payee, cat) in defaultMerchantMappings) {
        expect(allCategoryNames.contains(cat), isTrue,
            reason: 'Rule "$payee" targets unknown category "$cat"');
      }
    });
  });
}

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

PayeeCategoryCacheData _makeCacheEntry({
  required String payeeNormalized,
  required String categoryId,
  required double confidence,
  String accountBucket = 'standard',
  String source = 'user',
  int useCount = 1,
}) {
  return PayeeCategoryCacheData(
    payeeNormalized: payeeNormalized,
    accountBucket: accountBucket,
    categoryId: categoryId,
    confidence: confidence,
    source: source,
    useCount: useCount,
    updatedAt: 0,
  );
}

AutoCategorizeRule _makeRule({
  required String id,
  required int priority,
  required String categoryId,
  String? payeeContains,
  String? payeeExact,
  int? amountMinCents,
  int? amountMaxCents,
  String? accountId,
  String? accountType,
}) {
  return AutoCategorizeRule(
    id: id,
    name: 'Rule $id',
    priority: priority,
    payeeContains: payeeContains,
    payeeExact: payeeExact,
    amountMinCents: amountMinCents,
    amountMaxCents: amountMaxCents,
    accountId: accountId,
    accountType: accountType,
    categoryId: categoryId,
    isEnabled: true,
    createdAt: 0,
    updatedAt: 0,
  );
}

Transaction _makeTransaction({
  required String id,
  required String payee,
  required int amountCents,
  String accountId = 'acc-1',
}) {
  return Transaction(
    id: id,
    accountId: accountId,
    amountCents: amountCents,
    date: DateTime.now().millisecondsSinceEpoch,
    payee: payee,
    notes: null,
    categoryId: null,
    tags: null,
    externalId: null,
    isPending: false,
    isReviewed: false,
    createdAt: 0,
    updatedAt: 0,
    version: 1,
    syncStatus: 0,
  );
}

Account _makeAccount({
  required String id,
  required String accountType,
  String name = 'Test Account',
}) {
  return Account(
    id: id,
    name: name,
    accountType: accountType,
    balanceCents: 0,
    currencyCode: 'USD',
    isAsset: true,
    isHidden: false,
    displayOrder: 0,
    createdAt: 0,
    updatedAt: 0,
    version: 1,
    invertSign: false,
    syncStatus: 0,
  );
}
