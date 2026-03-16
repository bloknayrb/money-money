/// Debt payoff strategy.
enum DebtStrategy { snowball, avalanche }

/// Input: a single debt to include in payoff planning.
class DebtInfo {
  final String accountId;
  final String name;
  final int balanceCents;
  final int interestRateBps;
  final int minimumPaymentCents;

  const DebtInfo({
    required this.accountId,
    required this.name,
    required this.balanceCents,
    required this.interestRateBps,
    required this.minimumPaymentCents,
  });
}

/// Output: complete payoff plan for one strategy.
class DebtPayoffPlan {
  final DebtStrategy strategy;
  final int totalInterestCents;
  final DateTime debtFreeDate;
  final List<DebtPayoffEntry> perDebt;
  final List<DebtPayoffMonth> schedule;

  const DebtPayoffPlan({
    required this.strategy,
    required this.totalInterestCents,
    required this.debtFreeDate,
    required this.perDebt,
    required this.schedule,
  });
}

/// Per-debt summary within a payoff plan.
class DebtPayoffEntry {
  final String accountId;
  final String name;
  final DateTime payoffDate;
  final int totalInterestCents;
  final int originalBalanceCents;

  const DebtPayoffEntry({
    required this.accountId,
    required this.name,
    required this.payoffDate,
    required this.totalInterestCents,
    required this.originalBalanceCents,
  });
}

/// One month in the payoff schedule.
class DebtPayoffMonth {
  final DateTime month;
  final Map<String, int> payments;
  final Map<String, int> balances;
  final int totalRemainingCents;

  const DebtPayoffMonth({
    required this.month,
    required this.payments,
    required this.balances,
    required this.totalRemainingCents,
  });
}
