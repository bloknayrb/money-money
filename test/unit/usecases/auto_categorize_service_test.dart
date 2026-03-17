import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrimonium/data/local/database/app_database.dart';
import 'package:patrimonium/data/repositories/auto_categorize_repository.dart';
import 'package:patrimonium/data/repositories/transaction_repository.dart';
import 'package:patrimonium/domain/usecases/categorize/auto_categorize_service.dart';

class MockAutoCategorizeRepository extends Mock
    implements AutoCategorizeRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

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
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS')).thenAnswer(
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
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS')).thenAnswer(
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
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS'))
          .thenAnswer((_) async => null);
      when(() => mockAutoCatRepo.getEnabledRules())
          .thenAnswer((_) async => []);

      final result = await service.categorize('Starbucks');
      expect(result, isNull);
    });

    test('matches rule with payeeContains', () async {
      when(() => mockAutoCatRepo.getCacheEntry('WALMART SUPERCENTER'))
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
      when(() => mockAutoCatRepo.getCacheEntry('NETFLIX'))
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
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS'))
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
      when(() => mockAutoCatRepo.getCacheEntry('STORE'))
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
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS'))
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
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS')).thenAnswer(
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

    test('resets on category change', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.9,
          useCount: 4,
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

    test('logs correction when oldCategoryId differs', () async {
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS'))
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
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS'))
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
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS')).thenAnswer(
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
      when(() => mockAutoCatRepo.getCacheEntry('WALMART SUPERCENTER'))
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
      when(() => mockAutoCatRepo.getCacheEntry('UNKNOWN STORE'))
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
      when(() => mockAutoCatRepo.getCacheEntry('TARGET'))
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
      when(() => mockAutoCatRepo.getCacheEntry('STARBUCKS')).thenAnswer(
        (_) async => _makeCacheEntry(
          payeeNormalized: 'STARBUCKS',
          categoryId: 'cat-dining',
          confidence: 0.9,
        ),
      );

      // Unknown Store has no match
      when(() => mockAutoCatRepo.getCacheEntry('UNKNOWN STORE'))
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
  });
}

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

PayeeCategoryCacheData _makeCacheEntry({
  required String payeeNormalized,
  required String categoryId,
  required double confidence,
  String source = 'user',
  int useCount = 1,
}) {
  return PayeeCategoryCacheData(
    payeeNormalized: payeeNormalized,
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
