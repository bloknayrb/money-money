import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:patrimonium/data/local/database/app_database.dart';
import 'package:patrimonium/data/repositories/budget_repository.dart';
import 'package:patrimonium/data/repositories/category_repository.dart';
import 'package:patrimonium/data/repositories/insight_repository.dart';
import 'package:patrimonium/data/repositories/recurring_transaction_repository.dart';
import 'package:patrimonium/data/repositories/transaction_repository.dart';
import 'package:patrimonium/domain/usecases/alerts/alert_service.dart';
import 'package:patrimonium/domain/usecases/budgets/budget_spending_service.dart';

class MockInsightRepository extends Mock implements InsightRepository {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockBudgetSpendingService extends Mock implements BudgetSpendingService {}

class MockRecurringTransactionRepository extends Mock
    implements RecurringTransactionRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class FakeInsightsCompanion extends Fake implements InsightsCompanion {}

void main() {
  late MockInsightRepository mockInsightRepo;
  late MockBudgetRepository mockBudgetRepo;
  late MockBudgetSpendingService mockBudgetSpendingService;
  late MockRecurringTransactionRepository mockRecurringRepo;
  late MockTransactionRepository mockTransactionRepo;
  late MockCategoryRepository mockCategoryRepo;
  late AlertService service;

  setUpAll(() {
    registerFallbackValue(FakeInsightsCompanion());
  });

  setUp(() {
    mockInsightRepo = MockInsightRepository();
    mockBudgetRepo = MockBudgetRepository();
    mockBudgetSpendingService = MockBudgetSpendingService();
    mockRecurringRepo = MockRecurringTransactionRepository();
    mockTransactionRepo = MockTransactionRepository();
    mockCategoryRepo = MockCategoryRepository();
    service = AlertService(
      insightRepo: mockInsightRepo,
      budgetRepo: mockBudgetRepo,
      budgetSpendingService: mockBudgetSpendingService,
      recurringRepo: mockRecurringRepo,
      transactionRepo: mockTransactionRepo,
      categoryRepo: mockCategoryRepo,
    );

    when(() => mockInsightRepo.insertInsight(any())).thenAnswer((_) async {});
  });

  Budget _makeBudget({
    required String categoryId,
    int amountCents = 50000,
    double alertThreshold = 0.9,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return Budget(
      id: 'budget-$categoryId',
      categoryId: categoryId,
      amountCents: amountCents,
      periodType: 'monthly',
      startDate: now - 86400000,
      endDate: null,
      rollover: false,
      rolloverAmountCents: 0,
      alertThreshold: alertThreshold,
      createdAt: now,
      updatedAt: now,
      version: 1,
      syncStatus: 0,
    );
  }

  Category _makeCategory(String id, String name) {
    return Category(
      id: id,
      name: name,
      parentId: null,
      type: 'expense',
      icon: 'shopping_cart',
      color: 0xFF4CAF50,
      displayOrder: 0,
      isSystem: true,
      createdAt: 0,
      updatedAt: 0,
      version: 1,
      syncStatus: 0,
    );
  }

  group('checkBudgetThresholds', () {
    test('generates alert when spending exceeds threshold', () async {
      final budget = _makeBudget(categoryId: 'cat-1');
      when(() => mockBudgetRepo.getAllBudgets())
          .thenAnswer((_) async => [budget]);
      when(() => mockBudgetSpendingService.getBudgetsWithSpending([budget]))
          .thenAnswer((_) async => [
                BudgetWithSpent(
                    budget: budget, spentCents: 46000, percentage: 0.92),
              ]);
      when(() => mockCategoryRepo.getAllCategories())
          .thenAnswer((_) async => [_makeCategory('cat-1', 'Groceries')]);
      when(() => mockInsightRepo.hasRecentInsight(any(), any()))
          .thenAnswer((_) async => false);

      final count = await service.checkBudgetThresholds();

      expect(count, 1);
      verify(() => mockInsightRepo.insertInsight(any())).called(1);
    });

    test('skips alert when spending below threshold', () async {
      final budget = _makeBudget(categoryId: 'cat-1');
      when(() => mockBudgetRepo.getAllBudgets())
          .thenAnswer((_) async => [budget]);
      when(() => mockBudgetSpendingService.getBudgetsWithSpending([budget]))
          .thenAnswer((_) async => [
                BudgetWithSpent(
                    budget: budget, spentCents: 40000, percentage: 0.80),
              ]);
      when(() => mockCategoryRepo.getAllCategories())
          .thenAnswer((_) async => []);

      final count = await service.checkBudgetThresholds();

      expect(count, 0);
      verifyNever(() => mockInsightRepo.insertInsight(any()));
    });

    test('skips duplicate alert', () async {
      final budget = _makeBudget(categoryId: 'cat-1');
      when(() => mockBudgetRepo.getAllBudgets())
          .thenAnswer((_) async => [budget]);
      when(() => mockBudgetSpendingService.getBudgetsWithSpending([budget]))
          .thenAnswer((_) async => [
                BudgetWithSpent(
                    budget: budget, spentCents: 55000, percentage: 1.1),
              ]);
      when(() => mockCategoryRepo.getAllCategories())
          .thenAnswer((_) async => [_makeCategory('cat-1', 'Groceries')]);
      when(() => mockInsightRepo.hasRecentInsight(any(), any()))
          .thenAnswer((_) async => true);

      final count = await service.checkBudgetThresholds();

      expect(count, 0);
      verifyNever(() => mockInsightRepo.insertInsight(any()));
    });

    test('uses alert severity when over 100%', () async {
      final budget = _makeBudget(categoryId: 'cat-1');
      when(() => mockBudgetRepo.getAllBudgets())
          .thenAnswer((_) async => [budget]);
      when(() => mockBudgetSpendingService.getBudgetsWithSpending([budget]))
          .thenAnswer((_) async => [
                BudgetWithSpent(
                    budget: budget, spentCents: 55000, percentage: 1.1),
              ]);
      when(() => mockCategoryRepo.getAllCategories())
          .thenAnswer((_) async => [_makeCategory('cat-1', 'Groceries')]);
      when(() => mockInsightRepo.hasRecentInsight(any(), any()))
          .thenAnswer((_) async => false);

      await service.checkBudgetThresholds();

      final captured = verify(() => mockInsightRepo.insertInsight(captureAny()))
          .captured
          .first as InsightsCompanion;
      expect(captured.severity.value, 'alert');
      expect(captured.title.value, contains('exceeded'));
    });
  });

  group('checkUpcomingBills', () {
    test('generates alert for bill due tomorrow', () async {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      when(() => mockRecurringRepo.getActiveRecurring())
          .thenAnswer((_) async => [
                RecurringTransaction(
                  id: 'rec-1',
                  payee: 'Netflix',
                  amountCents: -1599,
                  categoryId: null,
                  accountId: 'acc-1',
                  frequency: 'monthly',
                  nextExpectedDate: tomorrow.millisecondsSinceEpoch,
                  lastOccurrenceDate: tomorrow
                      .subtract(const Duration(days: 30))
                      .millisecondsSinceEpoch,
                  isSubscription: true,
                  isActive: true,
                  notes: null,
                  createdAt: 0,
                  updatedAt: 0,
                ),
              ]);
      when(() => mockInsightRepo.hasRecentInsight(any(), any()))
          .thenAnswer((_) async => false);

      final count = await service.checkUpcomingBills();

      expect(count, 1);
      final captured = verify(() => mockInsightRepo.insertInsight(captureAny()))
          .captured
          .first as InsightsCompanion;
      expect(captured.title.value, contains('Netflix'));
      expect(captured.description.value, contains('subscription'));
    });

    test('skips bill due in 5 days', () async {
      final fiveDays = DateTime.now().add(const Duration(days: 5));
      when(() => mockRecurringRepo.getActiveRecurring())
          .thenAnswer((_) async => [
                RecurringTransaction(
                  id: 'rec-1',
                  payee: 'Rent',
                  amountCents: -150000,
                  categoryId: null,
                  accountId: 'acc-1',
                  frequency: 'monthly',
                  nextExpectedDate: fiveDays.millisecondsSinceEpoch,
                  lastOccurrenceDate: 0,
                  isSubscription: false,
                  isActive: true,
                  notes: null,
                  createdAt: 0,
                  updatedAt: 0,
                ),
              ]);

      final count = await service.checkUpcomingBills();

      expect(count, 0);
    });
  });

  group('runAllChecks', () {
    test('continues when one check fails', () async {
      when(() => mockBudgetRepo.getAllBudgets()).thenThrow(Exception('db error'));
      when(() => mockRecurringRepo.getActiveRecurring())
          .thenAnswer((_) async => []);
      when(() => mockTransactionRepo.getTransactionsByDateRange(any(), any()))
          .thenAnswer((_) async => []);
      when(() => mockCategoryRepo.getAllCategories())
          .thenAnswer((_) async => []);

      // Should not throw, should return 0
      final count = await service.runAllChecks();
      expect(count, 0);
    });
  });
}
