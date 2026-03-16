/// Monthly spending total for historical charts.
class MonthlySpending {
  final DateTime month;
  final int expenseCents;

  const MonthlySpending({required this.month, required this.expenseCents});
}

/// Spending breakdown by category for the current month.
class CategorySpending {
  final String categoryId;
  final String categoryName;
  final int color;
  final int amountCents;

  const CategorySpending({
    required this.categoryId,
    required this.categoryName,
    required this.color,
    required this.amountCents,
  });
}

/// Net worth at a month-end point in time.
class NetWorthSnapshot {
  final DateTime month;
  final int netWorthCents;

  const NetWorthSnapshot({required this.month, required this.netWorthCents});
}

/// Monthly income vs expense comparison with savings rate.
class MonthlyCashFlow {
  final DateTime month;
  final int incomeCents;
  final int expenseCents;
  final double savingsRate;

  const MonthlyCashFlow({
    required this.month,
    required this.incomeCents,
    required this.expenseCents,
    required this.savingsRate,
  });
}

/// Spending trend for a single category over multiple months.
class CategoryTrend {
  final String categoryId;
  final String categoryName;
  final int color;
  final List<({DateTime month, int amountCents})> monthlyAmounts;

  const CategoryTrend({
    required this.categoryId,
    required this.categoryName,
    required this.color,
    required this.monthlyAmounts,
  });
}
