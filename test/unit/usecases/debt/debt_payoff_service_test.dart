import 'package:flutter_test/flutter_test.dart';

import 'package:moneymoney/domain/usecases/debt/debt_payoff_service.dart';

void main() {
  late DebtPayoffService service;

  setUp(() {
    service = DebtPayoffService();
  });

  test('returns empty plan for no debts', () {
    final plan = service.calculate(
      debts: [],
      extraMonthlyPaymentCents: 10000,
      strategy: DebtStrategy.avalanche,
    );
    expect(plan.perDebt, isEmpty);
    expect(plan.schedule, isEmpty);
    expect(plan.totalInterestCents, 0);
  });

  test('single debt payoff with no interest', () {
    final plan = service.calculate(
      debts: [
        const DebtInfo(
          accountId: 'a1',
          name: 'Card',
          balanceCents: 100000, // $1000
          interestRateBps: 0,
          minimumPaymentCents: 25000, // $250/mo
        ),
      ],
      extraMonthlyPaymentCents: 0,
      strategy: DebtStrategy.avalanche,
    );

    expect(plan.totalInterestCents, 0);
    expect(plan.schedule.length, 4); // $1000 / $250 = 4 months
    expect(plan.perDebt.length, 1);
    expect(plan.perDebt.first.name, 'Card');
  });

  test('snowball orders by smallest balance first', () {
    final plan = service.calculate(
      debts: [
        const DebtInfo(
          accountId: 'big',
          name: 'Big Loan',
          balanceCents: 1000000,
          interestRateBps: 500,
          minimumPaymentCents: 20000,
        ),
        const DebtInfo(
          accountId: 'small',
          name: 'Small Card',
          balanceCents: 50000,
          interestRateBps: 2000,
          minimumPaymentCents: 5000,
        ),
      ],
      extraMonthlyPaymentCents: 10000,
      strategy: DebtStrategy.snowball,
    );

    // Small Card should be paid off first
    expect(plan.perDebt.first.name, 'Small Card');
    expect(
      plan.perDebt.first.payoffDate
          .isBefore(plan.perDebt.last.payoffDate),
      isTrue,
    );
  });

  test('avalanche orders by highest rate first', () {
    final plan = service.calculate(
      debts: [
        const DebtInfo(
          accountId: 'low',
          name: 'Low Rate',
          balanceCents: 50000,
          interestRateBps: 300,
          minimumPaymentCents: 5000,
        ),
        const DebtInfo(
          accountId: 'high',
          name: 'High Rate',
          balanceCents: 100000,
          interestRateBps: 2400,
          minimumPaymentCents: 5000,
        ),
      ],
      extraMonthlyPaymentCents: 10000,
      strategy: DebtStrategy.avalanche,
    );

    // High Rate should be first in the payoff order
    expect(plan.perDebt.first.name, 'High Rate');
  });

  test('avalanche saves more interest than snowball', () {
    final avalanche = service.calculate(
      debts: [
        const DebtInfo(
          accountId: 'a',
          name: 'Card A',
          balanceCents: 500000,
          interestRateBps: 2400, // 24%
          minimumPaymentCents: 10000,
        ),
        const DebtInfo(
          accountId: 'b',
          name: 'Loan B',
          balanceCents: 200000,
          interestRateBps: 600, // 6%
          minimumPaymentCents: 5000,
        ),
      ],
      extraMonthlyPaymentCents: 20000,
      strategy: DebtStrategy.avalanche,
    );

    final snowball = service.calculate(
      debts: [
        const DebtInfo(
          accountId: 'a',
          name: 'Card A',
          balanceCents: 500000,
          interestRateBps: 2400,
          minimumPaymentCents: 10000,
        ),
        const DebtInfo(
          accountId: 'b',
          name: 'Loan B',
          balanceCents: 200000,
          interestRateBps: 600,
          minimumPaymentCents: 5000,
        ),
      ],
      extraMonthlyPaymentCents: 20000,
      strategy: DebtStrategy.snowball,
    );

    expect(avalanche.totalInterestCents,
        lessThanOrEqualTo(snowball.totalInterestCents));
  });

  test('extra payment = 0 still pays off with minimums only', () {
    final plan = service.calculate(
      debts: [
        const DebtInfo(
          accountId: 'a1',
          name: 'Card',
          balanceCents: 100000,
          interestRateBps: 1800, // 18%
          minimumPaymentCents: 5000,
        ),
      ],
      extraMonthlyPaymentCents: 0,
      strategy: DebtStrategy.avalanche,
    );

    expect(plan.schedule, isNotEmpty);
    expect(plan.schedule.last.totalRemainingCents, 0);
  });

  test('handles 0% interest debt correctly', () {
    final plan = service.calculate(
      debts: [
        const DebtInfo(
          accountId: 'a1',
          name: 'Interest-free',
          balanceCents: 120000,
          interestRateBps: 0,
          minimumPaymentCents: 10000,
        ),
      ],
      extraMonthlyPaymentCents: 0,
      strategy: DebtStrategy.snowball,
    );

    expect(plan.totalInterestCents, 0);
    expect(plan.schedule.length, 12);
  });

  test('debt with same balance uses stable sort', () {
    final plan = service.calculate(
      debts: [
        const DebtInfo(
          accountId: 'a',
          name: 'A',
          balanceCents: 100000,
          interestRateBps: 1000,
          minimumPaymentCents: 5000,
        ),
        const DebtInfo(
          accountId: 'b',
          name: 'B',
          balanceCents: 100000,
          interestRateBps: 1000,
          minimumPaymentCents: 5000,
        ),
      ],
      extraMonthlyPaymentCents: 5000,
      strategy: DebtStrategy.snowball,
    );

    // Should complete without error
    expect(plan.perDebt.length, 2);
    expect(plan.schedule.last.totalRemainingCents, 0);
  });
}
