import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:moneymoney/data/repositories/account_repository.dart';
import 'package:moneymoney/data/repositories/category_repository.dart';
import 'package:moneymoney/data/repositories/transaction_repository.dart';
import 'package:moneymoney/domain/usecases/analytics/spending_analytics_service.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  late MockTransactionRepository mockTransactionRepo;
  late MockCategoryRepository mockCategoryRepo;
  late MockAccountRepository mockAccountRepo;
  late SpendingAnalyticsService service;

  setUp(() {
    mockTransactionRepo = MockTransactionRepository();
    mockCategoryRepo = MockCategoryRepository();
    mockAccountRepo = MockAccountRepository();
    service = SpendingAnalyticsService(
      transactionRepo: mockTransactionRepo,
      categoryRepo: mockCategoryRepo,
      accountRepo: mockAccountRepo,
    );
  });

  group('getMonthlyCashFlow', () {
    test('returns cash flow with correct savings rate', () async {
      when(() => mockTransactionRepo.getMonthlyExpenseTotals(3)).thenAnswer(
        (_) async => [
          (month: DateTime(2026, 1), expenseCents: 300000),
          (month: DateTime(2026, 2), expenseCents: 250000),
          (month: DateTime(2026, 3), expenseCents: 400000),
        ],
      );
      when(() => mockTransactionRepo.getMonthlyIncomeTotals(3)).thenAnswer(
        (_) async => [
          (month: DateTime(2026, 1), incomeCents: 500000),
          (month: DateTime(2026, 2), incomeCents: 500000),
          (month: DateTime(2026, 3), incomeCents: 500000),
        ],
      );

      final result = await service.getMonthlyCashFlow(3);

      expect(result.length, 3);
      expect(result[0].incomeCents, 500000);
      expect(result[0].expenseCents, 300000);
      expect(result[0].savingsRate, closeTo(0.4, 0.001));
      expect(result[1].savingsRate, closeTo(0.5, 0.001));
      expect(result[2].savingsRate, closeTo(0.2, 0.001));
    });

    test('returns 0 savings rate when no income', () async {
      when(() => mockTransactionRepo.getMonthlyExpenseTotals(1)).thenAnswer(
        (_) async => [(month: DateTime(2026, 1), expenseCents: 100000)],
      );
      when(() => mockTransactionRepo.getMonthlyIncomeTotals(1)).thenAnswer(
        (_) async => [(month: DateTime(2026, 1), incomeCents: 0)],
      );

      final result = await service.getMonthlyCashFlow(1);

      expect(result.length, 1);
      expect(result[0].savingsRate, 0.0);
    });

    test('handles negative savings rate when expenses exceed income', () async {
      when(() => mockTransactionRepo.getMonthlyExpenseTotals(1)).thenAnswer(
        (_) async => [(month: DateTime(2026, 1), expenseCents: 600000)],
      );
      when(() => mockTransactionRepo.getMonthlyIncomeTotals(1)).thenAnswer(
        (_) async => [(month: DateTime(2026, 1), incomeCents: 400000)],
      );

      final result = await service.getMonthlyCashFlow(1);

      expect(result[0].savingsRate, closeTo(-0.5, 0.001));
    });

    test('returns empty list when no data', () async {
      when(() => mockTransactionRepo.getMonthlyExpenseTotals(6))
          .thenAnswer((_) async => []);
      when(() => mockTransactionRepo.getMonthlyIncomeTotals(6))
          .thenAnswer((_) async => []);

      final result = await service.getMonthlyCashFlow(6);

      expect(result, isEmpty);
    });
  });

  group('getCurrentSavingsRate', () {
    test('returns correct rate for normal month', () async {
      when(() => mockTransactionRepo.getTotalIncome(any(), any()))
          .thenAnswer((_) async => 500000);
      when(() => mockTransactionRepo.getTotalExpenses(any(), any()))
          .thenAnswer((_) async => -300000);

      final rate = await service.getCurrentSavingsRate();

      // (500000 + (-300000)) / 500000 = 0.4
      expect(rate, closeTo(0.4, 0.001));
    });

    test('returns 0 when no income', () async {
      when(() => mockTransactionRepo.getTotalIncome(any(), any()))
          .thenAnswer((_) async => 0);
      when(() => mockTransactionRepo.getTotalExpenses(any(), any()))
          .thenAnswer((_) async => -100000);

      final rate = await service.getCurrentSavingsRate();

      expect(rate, 0.0);
    });

    test('returns negative rate when overspending', () async {
      when(() => mockTransactionRepo.getTotalIncome(any(), any()))
          .thenAnswer((_) async => 300000);
      when(() => mockTransactionRepo.getTotalExpenses(any(), any()))
          .thenAnswer((_) async => -500000);

      final rate = await service.getCurrentSavingsRate();

      // (300000 + (-500000)) / 300000 = -0.667
      expect(rate, closeTo(-0.667, 0.001));
    });
  });
}
