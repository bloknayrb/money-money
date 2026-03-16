/// Projected cash flow over a future time period.
class CashFlowForecast {
  final List<ForecastDay> days;
  final List<BalanceAlert> alerts;
  final int daysAhead;

  const CashFlowForecast({
    required this.days,
    required this.alerts,
    required this.daysAhead,
  });
}

/// Projected aggregate balance on a single day.
class ForecastDay {
  final DateTime date;
  final int projectedBalanceCents;
  final List<ScheduledTransaction> transactions;

  const ForecastDay({
    required this.date,
    required this.projectedBalanceCents,
    required this.transactions,
  });
}

/// A recurring transaction expected on a specific day.
class ScheduledTransaction {
  final String payee;
  final int amountCents;
  final String accountId;

  const ScheduledTransaction({
    required this.payee,
    required this.amountCents,
    required this.accountId,
  });
}

/// Alert when a projected balance drops below a threshold.
class BalanceAlert {
  final DateTime date;
  final String accountName;
  final int projectedBalanceCents;
  final String triggerPayee;

  const BalanceAlert({
    required this.date,
    required this.accountName,
    required this.projectedBalanceCents,
    required this.triggerPayee,
  });
}
