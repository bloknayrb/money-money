import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrimonium/core/di/providers.dart';
import 'package:patrimonium/data/local/database/app_database.dart';
import 'package:patrimonium/data/repositories/account_repository.dart';
import 'package:patrimonium/data/repositories/budget_repository.dart';
import 'package:patrimonium/data/repositories/category_repository.dart';
import 'package:patrimonium/data/repositories/transaction_repository.dart';
import 'package:patrimonium/presentation/features/accounts/accounts_providers.dart';
import 'package:patrimonium/presentation/features/budgets/budgets_providers.dart';
import 'package:patrimonium/presentation/features/dashboard/dashboard_providers.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

// Fake Account for use in tests
Account _fakeAccount({
  required String id,
  String name = 'Test',
  String accountType = 'checking',
  int balanceCents = 10000,
  bool isAsset = true,
}) {
  // Create a minimal Account data class matching Drift's generated class.
  return Account(
    id: id,
    name: name,
    institutionName: null,
    accountType: accountType,
    accountSubtype: null,
    balanceCents: balanceCents,
    currencyCode: 'USD',
    isAsset: isAsset,
    isHidden: false,
    displayOrder: 0,
    color: null,
    icon: null,
    bankConnectionId: null,
    externalId: null,
    lastSyncedAt: null,
    createdAt: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
    version: 1,
    syncStatus: 0,
  );
}

Transaction _fakeTransaction({
  required String id,
  required String accountId,
  required int amountCents,
  required int date,
  String? categoryId,
  String payee = 'Store',
}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return Transaction(
    id: id,
    accountId: accountId,
    amountCents: amountCents,
    date: date,
    payee: payee,
    categoryId: categoryId,
    notes: null,
    isReviewed: false,
    isPending: false,
    externalId: null,
    transferAccountId: null,
    createdAt: now,
    updatedAt: now,
    version: 1,
    syncStatus: 0,
  );
}

Category _fakeCategory({
  required String id,
  required String name,
  String? parentId,
  String type = 'expense',
  int color = 0xFF4CAF50,
}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return Category(
    id: id,
    name: name,
    icon: 'category',
    color: color,
    type: type,
    parentId: parentId,
    displayOrder: 0,
    isSystem: false,
    createdAt: now,
    updatedAt: now,
    version: 1,
    syncStatus: 0,
  );
}

Budget _fakeBudget({
  required String id,
  required String categoryId,
  required int amountCents,
  String periodType = 'monthly',
}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return Budget(
    id: id,
    categoryId: categoryId,
    amountCents: amountCents,
    periodType: periodType,
    rollover: false,
    rolloverAmountCents: 0,
    alertThreshold: 80,
    startDate: now,
    endDate: null,
    createdAt: now,
    updatedAt: now,
    version: 1,
    syncStatus: 0,
  );
}

void main() {
  late MockAccountRepository mockAccountRepo;
  late MockTransactionRepository mockTxnRepo;
  late MockCategoryRepository mockCategoryRepo;
  late MockBudgetRepository mockBudgetRepo;

  setUp(() {
    mockAccountRepo = MockAccountRepository();
    mockTxnRepo = MockTransactionRepository();
    mockCategoryRepo = MockCategoryRepository();
    mockBudgetRepo = MockBudgetRepository();
  });

  /// Helper to create a ProviderContainer with mocked repos and an accounts
  /// stream override.
  ProviderContainer createContainer({
    List<Account> accounts = const [],
  }) {
    // accountsProvider is a StreamProvider that watches accountRepositoryProvider,
    // so we override it directly with a stream.
    return ProviderContainer(
      overrides: [
        accountRepositoryProvider.overrideWithValue(mockAccountRepo),
        transactionRepositoryProvider.overrideWithValue(mockTxnRepo),
        categoryRepositoryProvider.overrideWithValue(mockCategoryRepo),
        budgetRepositoryProvider.overrideWithValue(mockBudgetRepo),
        accountsProvider
            .overrideWith((ref) => Stream.value(accounts)),
      ],
    );
  }

  group('netWorthHistoryProvider', () {
    test('returns 6 monthly snapshots in chronological order', () async {
      final accounts = [
        _fakeAccount(id: 'acc-1', balanceCents: 100000, isAsset: true),
      ];

      // getTransactionSumsAfterDate returns empty map (no transactions)
      when(() => mockTxnRepo.getTransactionSumsAfterDate(any()))
          .thenAnswer((_) async => <String, int>{});

      final container = createContainer(accounts: accounts);
      addTearDown(container.dispose);

      final result = await container.read(netWorthHistoryProvider.future);

      expect(result.length, 6);
      // Should be chronological (oldest first)
      for (var i = 1; i < result.length; i++) {
        expect(result[i].month.isAfter(result[i - 1].month), isTrue);
      }
    });

    test('calculates historical net worth by subtracting post-month transactions',
        () async {
      final accounts = [
        _fakeAccount(id: 'acc-1', balanceCents: 100000, isAsset: true),
      ];

      // For the most recent month-end, 20000 cents of transactions happened after
      when(() => mockTxnRepo.getTransactionSumsAfterDate(any()))
          .thenAnswer((_) async => {'acc-1': 20000});

      final container = createContainer(accounts: accounts);
      addTearDown(container.dispose);

      final result = await container.read(netWorthHistoryProvider.future);

      // Each snapshot should be 100000 - 20000 = 80000
      for (final snapshot in result) {
        expect(snapshot.netWorthCents, 80000);
      }
    });

    test('handles accounts with no transactions', () async {
      final accounts = [
        _fakeAccount(id: 'acc-1', balanceCents: 50000),
      ];

      when(() => mockTxnRepo.getTransactionSumsAfterDate(any()))
          .thenAnswer((_) async => <String, int>{});

      final container = createContainer(accounts: accounts);
      addTearDown(container.dispose);

      final result = await container.read(netWorthHistoryProvider.future);

      // All months should equal current balance
      for (final snapshot in result) {
        expect(snapshot.netWorthCents, 50000);
      }
    });

    test('handles empty account list', () async {
      when(() => mockTxnRepo.getTransactionSumsAfterDate(any()))
          .thenAnswer((_) async => <String, int>{});

      final container = createContainer(accounts: []);
      addTearDown(container.dispose);

      final result = await container.read(netWorthHistoryProvider.future);

      expect(result.length, 6);
      for (final snapshot in result) {
        expect(snapshot.netWorthCents, 0);
      }
    });
  });

  group('monthlySpendingHistoryProvider', () {
    test('returns 6 monthly spending totals', () async {
      final now = DateTime.now();
      final totals = <({DateTime month, int expenseCents})>[];
      for (var i = 5; i >= 0; i--) {
        totals.add((
          month: DateTime(now.year, now.month - i, 1),
          expenseCents: (i + 1) * 1000,
        ));
      }

      when(() => mockTxnRepo.getMonthlyExpenseTotals(6))
          .thenAnswer((_) async => totals);

      final container = createContainer();
      addTearDown(container.dispose);

      final result =
          await container.read(monthlySpendingHistoryProvider.future);

      expect(result.length, 6);
      // Values should be positive (abs of expenses)
      for (final m in result) {
        expect(m.expenseCents, greaterThan(0));
      }
    });

    test('handles months with no transactions', () async {
      final now = DateTime.now();
      final totals = <({DateTime month, int expenseCents})>[];
      for (var i = 5; i >= 0; i--) {
        totals
            .add((month: DateTime(now.year, now.month - i, 1), expenseCents: 0));
      }

      when(() => mockTxnRepo.getMonthlyExpenseTotals(6))
          .thenAnswer((_) async => totals);

      final container = createContainer();
      addTearDown(container.dispose);

      final result =
          await container.read(monthlySpendingHistoryProvider.future);

      expect(result.length, 6);
      for (final m in result) {
        expect(m.expenseCents, 0);
      }
    });
  });

  group('spendingByCategoryProvider', () {
    test('groups spending by parent category', () async {
      final now = DateTime.now();
      final midMonth = DateTime(now.year, now.month, 15);

      final parentCat =
          _fakeCategory(id: 'cat-food', name: 'Food & Dining');
      final subCat = _fakeCategory(
          id: 'cat-groceries', name: 'Groceries', parentId: 'cat-food');

      when(() => mockTxnRepo.getTransactionsByDateRange(any(), any()))
          .thenAnswer((_) async => [
                _fakeTransaction(
                  id: 'txn-1',
                  accountId: 'acc-1',
                  amountCents: -5000,
                  date: midMonth.millisecondsSinceEpoch,
                  categoryId: 'cat-food',
                ),
                _fakeTransaction(
                  id: 'txn-2',
                  accountId: 'acc-1',
                  amountCents: -3000,
                  date: midMonth.millisecondsSinceEpoch,
                  categoryId: 'cat-groceries',
                ),
              ]);
      when(() => mockCategoryRepo.getAllCategories())
          .thenAnswer((_) async => [parentCat, subCat]);

      final container = createContainer();
      addTearDown(container.dispose);

      final result =
          await container.read(spendingByCategoryProvider.future);

      // Both should be merged under parent 'Food & Dining'
      expect(result.length, 1);
      expect(result[0].categoryName, 'Food & Dining');
      expect(result[0].amountCents, 8000); // 5000 + 3000
    });

    test('excludes income (positive amounts)', () async {
      final now = DateTime.now();
      final midMonth = DateTime(now.year, now.month, 15);
      final cat = _fakeCategory(id: 'cat-1', name: 'Salary', type: 'income');

      when(() => mockTxnRepo.getTransactionsByDateRange(any(), any()))
          .thenAnswer((_) async => [
                _fakeTransaction(
                  id: 'txn-1',
                  accountId: 'acc-1',
                  amountCents: 500000,
                  date: midMonth.millisecondsSinceEpoch,
                  categoryId: 'cat-1',
                ),
              ]);
      when(() => mockCategoryRepo.getAllCategories())
          .thenAnswer((_) async => [cat]);

      final container = createContainer();
      addTearDown(container.dispose);

      final result =
          await container.read(spendingByCategoryProvider.future);

      expect(result, isEmpty);
    });

    test('excludes uncategorized transactions', () async {
      final now = DateTime.now();
      final midMonth = DateTime(now.year, now.month, 15);

      when(() => mockTxnRepo.getTransactionsByDateRange(any(), any()))
          .thenAnswer((_) async => [
                _fakeTransaction(
                  id: 'txn-1',
                  accountId: 'acc-1',
                  amountCents: -5000,
                  date: midMonth.millisecondsSinceEpoch,
                  categoryId: null,
                ),
              ]);
      when(() => mockCategoryRepo.getAllCategories())
          .thenAnswer((_) async => []);

      final container = createContainer();
      addTearDown(container.dispose);

      final result =
          await container.read(spendingByCategoryProvider.future);

      expect(result, isEmpty);
    });

    test('returns top 8 categories sorted by amount', () async {
      final now = DateTime.now();
      final midMonth = DateTime(now.year, now.month, 15);

      // Create 10 categories
      final categories = List.generate(
        10,
        (i) => _fakeCategory(id: 'cat-$i', name: 'Category $i'),
      );

      final transactions = List.generate(
        10,
        (i) => _fakeTransaction(
          id: 'txn-$i',
          accountId: 'acc-1',
          amountCents: -(i + 1) * 1000,
          date: midMonth.millisecondsSinceEpoch,
          categoryId: 'cat-$i',
        ),
      );

      when(() => mockTxnRepo.getTransactionsByDateRange(any(), any()))
          .thenAnswer((_) async => transactions);
      when(() => mockCategoryRepo.getAllCategories())
          .thenAnswer((_) async => categories);

      final container = createContainer();
      addTearDown(container.dispose);

      final result =
          await container.read(spendingByCategoryProvider.future);

      expect(result.length, 8);
      // Should be sorted by amount descending
      expect(result[0].amountCents, 10000); // cat-9
      expect(result[1].amountCents, 9000); // cat-8
    });
  });

  group('budgetsWithSpentProvider', () {
    test('calculates percentage correctly for monthly budget', () async {
      final budget = _fakeBudget(
        id: 'bud-1',
        categoryId: 'cat-food',
        amountCents: 50000,
        periodType: 'monthly',
      );

      when(() => mockBudgetRepo.watchActiveBudgets())
          .thenAnswer((_) => Stream.value([budget]));
      when(() => mockCategoryRepo.getSubcategories('cat-food'))
          .thenAnswer((_) async => []);
      // Expenses are negative in the DB
      when(() => mockTxnRepo.getTotalExpensesByCategoryIds(
              any(), any(), any()))
          .thenAnswer((_) async => {'cat-food': -25000});

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(mockAccountRepo),
          transactionRepositoryProvider.overrideWithValue(mockTxnRepo),
          categoryRepositoryProvider.overrideWithValue(mockCategoryRepo),
          budgetRepositoryProvider.overrideWithValue(mockBudgetRepo),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(budgetsWithSpentProvider.future);

      expect(result.length, 1);
      expect(result[0].spentCents, 25000);
      expect(result[0].percentage, closeTo(0.5, 0.01));
    });

    test('includes subcategory spending in parent budget', () async {
      final budget = _fakeBudget(
        id: 'bud-1',
        categoryId: 'cat-food',
        amountCents: 50000,
      );
      final subCat = _fakeCategory(
          id: 'cat-groceries', name: 'Groceries', parentId: 'cat-food');

      when(() => mockBudgetRepo.watchActiveBudgets())
          .thenAnswer((_) => Stream.value([budget]));
      when(() => mockCategoryRepo.getSubcategories('cat-food'))
          .thenAnswer((_) async => [subCat]);
      when(() => mockTxnRepo.getTotalExpensesByCategoryIds(
              any(), any(), any()))
          .thenAnswer((_) async => {
                'cat-food': -10000,
                'cat-groceries': -15000,
              });

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(mockAccountRepo),
          transactionRepositoryProvider.overrideWithValue(mockTxnRepo),
          categoryRepositoryProvider.overrideWithValue(mockCategoryRepo),
          budgetRepositoryProvider.overrideWithValue(mockBudgetRepo),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(budgetsWithSpentProvider.future);

      expect(result.length, 1);
      // 10000 + 15000 = 25000
      expect(result[0].spentCents, 25000);
      expect(result[0].percentage, closeTo(0.5, 0.01));
    });

    test('batches monthly and annual budget queries separately', () async {
      final monthlyBudget = _fakeBudget(
        id: 'bud-1',
        categoryId: 'cat-food',
        amountCents: 50000,
        periodType: 'monthly',
      );
      final annualBudget = _fakeBudget(
        id: 'bud-2',
        categoryId: 'cat-travel',
        amountCents: 200000,
        periodType: 'annual',
      );

      when(() => mockBudgetRepo.watchActiveBudgets())
          .thenAnswer((_) => Stream.value([monthlyBudget, annualBudget]));
      when(() => mockCategoryRepo.getSubcategories(any()))
          .thenAnswer((_) async => []);

      // Track separate calls for monthly vs annual date ranges
      final calls = <List<dynamic>>[];
      when(() => mockTxnRepo.getTotalExpensesByCategoryIds(
              any(), any(), any()))
          .thenAnswer((invocation) async {
        calls.add(invocation.positionalArguments);
        return {};
      });

      final container = ProviderContainer(
        overrides: [
          accountRepositoryProvider.overrideWithValue(mockAccountRepo),
          transactionRepositoryProvider.overrideWithValue(mockTxnRepo),
          categoryRepositoryProvider.overrideWithValue(mockCategoryRepo),
          budgetRepositoryProvider.overrideWithValue(mockBudgetRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(budgetsWithSpentProvider.future);

      // Should have exactly 2 batch calls: one for monthly IDs, one for annual IDs
      expect(calls.length, 2);
    });
  });
}
