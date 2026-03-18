import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:moneymoney/data/local/database/app_database.dart';
import 'package:moneymoney/data/repositories/account_repository.dart';
import 'package:moneymoney/data/repositories/budget_repository.dart';
import 'package:moneymoney/data/repositories/goal_repository.dart';
import 'package:moneymoney/data/repositories/recurring_transaction_repository.dart';
import 'package:moneymoney/data/repositories/transaction_repository.dart';
import 'package:moneymoney/domain/usecases/analytics/financial_health_service.dart';
import 'package:moneymoney/domain/usecases/analytics/spending_analytics_service.dart';
import 'package:moneymoney/domain/usecases/budgets/budget_spending_service.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockBudgetSpendingService extends Mock implements BudgetSpendingService {}

class MockBudgetRepository extends Mock implements BudgetRepository {}

class MockRecurringTransactionRepository extends Mock
    implements RecurringTransactionRepository {}

class MockGoalRepository extends Mock implements GoalRepository {}

class MockSpendingAnalyticsService extends Mock
    implements SpendingAnalyticsService {}

void main() {
  late FinancialHealthService service;
  late MockAccountRepository mockAccountRepo;
  late MockTransactionRepository mockTransactionRepo;
  late MockBudgetSpendingService mockBudgetSpendingService;
  late MockBudgetRepository mockBudgetRepo;
  late MockRecurringTransactionRepository mockRecurringRepo;
  late MockGoalRepository mockGoalRepo;
  late MockSpendingAnalyticsService mockAnalyticsService;

  setUp(() {
    mockAccountRepo = MockAccountRepository();
    mockTransactionRepo = MockTransactionRepository();
    mockBudgetSpendingService = MockBudgetSpendingService();
    mockBudgetRepo = MockBudgetRepository();
    mockRecurringRepo = MockRecurringTransactionRepository();
    mockGoalRepo = MockGoalRepository();
    mockAnalyticsService = MockSpendingAnalyticsService();

    service = FinancialHealthService(
      accountRepo: mockAccountRepo,
      transactionRepo: mockTransactionRepo,
      budgetSpendingService: mockBudgetSpendingService,
      budgetRepo: mockBudgetRepo,
      recurringRepo: mockRecurringRepo,
      goalRepo: mockGoalRepo,
      analyticsService: mockAnalyticsService,
    );

    // Default stubs for all repos to avoid unhandled mock errors
    when(() => mockAccountRepo.getAllAccounts()).thenAnswer((_) async => []);
    when(() => mockTransactionRepo.getTotalIncome(any(), any()))
        .thenAnswer((_) async => 0);
    when(() => mockTransactionRepo.getTotalExpenses(any(), any()))
        .thenAnswer((_) async => 0);
    when(() => mockRecurringRepo.getActiveRecurring())
        .thenAnswer((_) async => []);
    when(() => mockBudgetRepo.getAllBudgets()).thenAnswer((_) async => []);
    when(() => mockGoalRepo.watchActiveGoals())
        .thenAnswer((_) => Stream.value([]));
    when(() => mockAnalyticsService.getCurrentSavingsRate())
        .thenAnswer((_) async => 0.0);
    when(() => mockAnalyticsService.getNetWorthHistory(any()))
        .thenAnswer((_) async => []);
  });

  test('returns score between 0 and 100', () async {
    final result = await service.calculateScore();
    expect(result.overallScore, greaterThanOrEqualTo(0));
    expect(result.overallScore, lessThanOrEqualTo(100));
  });

  test('returns 6 pillars', () async {
    final result = await service.calculateScore();
    expect(result.pillars.length, 6);
  });

  test('savings rate pillar scores 100 when rate >= 20%', () async {
    when(() => mockAnalyticsService.getCurrentSavingsRate())
        .thenAnswer((_) async => 0.25);

    final result = await service.calculateScore();
    final savingsPillar =
        result.pillars.firstWhere((p) => p.name == 'Savings Rate');

    expect(savingsPillar.score, 100);
    expect(savingsPillar.status, 'excellent');
  });

  test('savings rate pillar scores 0 when negative', () async {
    when(() => mockAnalyticsService.getCurrentSavingsRate())
        .thenAnswer((_) async => -0.1);

    final result = await service.calculateScore();
    final savingsPillar =
        result.pillars.firstWhere((p) => p.name == 'Savings Rate');

    expect(savingsPillar.score, 0);
  });

  test('budget adherence is unavailable when no budgets', () async {
    when(() => mockBudgetRepo.getAllBudgets()).thenAnswer((_) async => []);

    final result = await service.calculateScore();
    final budgetPillar =
        result.pillars.firstWhere((p) => p.name == 'Budget Adherence');

    expect(budgetPillar.status, 'unavailable');
  });

  test('retirement readiness is unavailable when no retirement goal', () async {
    when(() => mockGoalRepo.watchActiveGoals())
        .thenAnswer((_) => Stream.value([]));

    final result = await service.calculateScore();
    final retirementPillar =
        result.pillars.firstWhere((p) => p.name == 'Retirement Readiness');

    expect(retirementPillar.status, 'unavailable');
  });

  test('priority ladder includes starter emergency fund step', () async {
    final result = await service.calculateScore();
    expect(
      result.allSteps.any((s) => s.title.contains('1,000')),
      isTrue,
    );
  });

  test('overall score handles all unavailable pillars gracefully', () async {
    // All repos return empty data → most pillars unavailable
    final result = await service.calculateScore();
    // Should not crash; score is 0 or derived from whatever is available
    expect(result.overallScore, greaterThanOrEqualTo(0));
  });

  test('failed pillar does not crash overall calculation', () async {
    // Make one repo throw
    when(() => mockAccountRepo.getAllAccounts())
        .thenThrow(Exception('db error'));

    final result = await service.calculateScore();
    expect(result.overallScore, greaterThanOrEqualTo(0));
    // Emergency fund and DTI pillars should be 'unavailable'
    final efPillar =
        result.pillars.firstWhere((p) => p.name == 'Emergency Fund');
    expect(efPillar.status, 'unavailable');
  });
}
