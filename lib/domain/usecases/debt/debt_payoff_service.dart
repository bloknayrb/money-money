import 'debt_models.dart';

export 'debt_models.dart';

/// Pure computation: calculates snowball or avalanche debt payoff schedules.
class DebtPayoffService {
  DebtPayoffPlan calculate({
    required List<DebtInfo> debts,
    required int extraMonthlyPaymentCents,
    required DebtStrategy strategy,
  }) {
    if (debts.isEmpty) {
      return DebtPayoffPlan(
        strategy: strategy,
        totalInterestCents: 0,
        debtFreeDate: DateTime.now(),
        perDebt: [],
        schedule: [],
      );
    }

    // Sort: snowball = smallest balance first, avalanche = highest rate first
    final sorted = List<DebtInfo>.from(debts);
    if (strategy == DebtStrategy.snowball) {
      sorted.sort((a, b) => a.balanceCents.compareTo(b.balanceCents));
    } else {
      sorted.sort((a, b) => b.interestRateBps.compareTo(a.interestRateBps));
    }

    // Working balances and interest trackers
    final balances = {for (final d in sorted) d.accountId: d.balanceCents.toDouble()};
    final interest = {for (final d in sorted) d.accountId: 0.0};
    final payoffDates = <String, DateTime>{};
    final schedule = <DebtPayoffMonth>[];

    final now = DateTime.now();
    var month = DateTime(now.year, now.month + 1, 1);
    const maxMonths = 600; // 50 year safety cap

    for (var m = 0; m < maxMonths; m++) {
      // Check if all debts are paid off
      if (balances.values.every((b) => b <= 0.005)) break;

      final monthPayments = <String, int>{};
      var extraRemaining = extraMonthlyPaymentCents.toDouble();

      // Step 1: Apply minimum payments and interest to all debts
      for (final d in sorted) {
        if (balances[d.accountId]! <= 0.005) continue;

        // Apply monthly interest
        final monthlyRate = d.interestRateBps / 10000.0 / 12.0;
        final interestCharge = balances[d.accountId]! * monthlyRate;
        interest[d.accountId] = interest[d.accountId]! + interestCharge;
        balances[d.accountId] = balances[d.accountId]! + interestCharge;

        // Apply minimum payment
        final minPayment = d.minimumPaymentCents.toDouble();
        final payment = minPayment < balances[d.accountId]!
            ? minPayment
            : balances[d.accountId]!;
        balances[d.accountId] = balances[d.accountId]! - payment;
        monthPayments[d.accountId] = payment.round();

        if (balances[d.accountId]! <= 0.005) {
          balances[d.accountId] = 0;
          payoffDates.putIfAbsent(d.accountId, () => month);
          // Freed-up minimum payment becomes extra
          extraRemaining += minPayment;
        }
      }

      // Step 2: Apply extra payment to priority debt
      for (final d in sorted) {
        if (balances[d.accountId]! <= 0.005 || extraRemaining <= 0) continue;

        final extraPayment = extraRemaining < balances[d.accountId]!
            ? extraRemaining
            : balances[d.accountId]!;
        balances[d.accountId] = balances[d.accountId]! - extraPayment;
        monthPayments[d.accountId] =
            (monthPayments[d.accountId] ?? 0) + extraPayment.round();
        extraRemaining -= extraPayment;

        if (balances[d.accountId]! <= 0.005) {
          balances[d.accountId] = 0;
          payoffDates.putIfAbsent(d.accountId, () => month);
        }

        break; // Extra goes to top-priority debt only
      }

      final totalRemaining = balances.values.fold<double>(0, (s, b) => s + b);
      schedule.add(DebtPayoffMonth(
        month: month,
        payments: Map.from(monthPayments),
        balances: {for (final e in balances.entries) e.key: e.value.round()},
        totalRemainingCents: totalRemaining.round(),
      ));

      month = DateTime(month.year, month.month + 1, 1);
    }

    final totalInterest =
        interest.values.fold<double>(0, (s, i) => s + i).round();
    final debtFreeDate =
        schedule.isNotEmpty ? schedule.last.month : DateTime.now();

    return DebtPayoffPlan(
      strategy: strategy,
      totalInterestCents: totalInterest,
      debtFreeDate: debtFreeDate,
      perDebt: sorted.map((d) {
        return DebtPayoffEntry(
          accountId: d.accountId,
          name: d.name,
          payoffDate: payoffDates[d.accountId] ?? debtFreeDate,
          totalInterestCents: interest[d.accountId]!.round(),
          originalBalanceCents: d.balanceCents,
        );
      }).toList(),
      schedule: schedule,
    );
  }
}
