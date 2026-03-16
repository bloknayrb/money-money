import '../../../data/local/database/app_database.dart';
import 'forecast_models.dart';

export 'forecast_models.dart';

/// Projects account balances forward using recurring transactions.
class CashFlowForecastService {
  /// Pure computation — takes data, returns projections.
  CashFlowForecast forecast({
    required List<Account> accounts,
    required List<RecurringTransaction> recurring,
    int daysAhead = 90,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Current aggregate balance
    var balance = 0;
    final accountNames = <String, String>{};
    for (final a in accounts) {
      balance += a.balanceCents;
      accountNames[a.id] = a.name;
    }

    // Copy nextExpectedDate per recurring so we can advance independently
    final nextDates = <String, DateTime>{};
    final recurringMap = <String, RecurringTransaction>{};
    for (final r in recurring) {
      nextDates[r.id] = DateTime.fromMillisecondsSinceEpoch(r.nextExpectedDate);
      recurringMap[r.id] = r;
    }

    final days = <ForecastDay>[];
    final alerts = <BalanceAlert>[];

    for (var d = 0; d <= daysAhead; d++) {
      final date = today.add(Duration(days: d));
      final dayTxns = <ScheduledTransaction>[];

      // Check each recurring transaction
      for (final id in nextDates.keys.toList()) {
        var next = nextDates[id]!;
        final r = recurringMap[id]!;

        // Apply all occurrences that fall on this day
        while (_isSameDay(next, date)) {
          dayTxns.add(ScheduledTransaction(
            payee: r.payee,
            amountCents: r.amountCents,
            accountId: r.accountId,
          ));
          balance += r.amountCents;
          next = _advanceDate(next, r.frequency);
          nextDates[id] = next;
        }
      }

      days.add(ForecastDay(
        date: date,
        projectedBalanceCents: balance,
        transactions: dayTxns,
      ));

      // Check for low balance alerts after applying transactions
      if (dayTxns.isNotEmpty && balance < 0) {
        alerts.add(BalanceAlert(
          date: date,
          accountName: 'Total',
          projectedBalanceCents: balance,
          triggerPayee: dayTxns.last.payee,
        ));
      }
    }

    return CashFlowForecast(
      days: days,
      alerts: alerts,
      daysAhead: daysAhead,
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime _advanceDate(DateTime date, String frequency) {
    switch (frequency) {
      case 'weekly':
        return date.add(const Duration(days: 7));
      case 'biweekly':
        return date.add(const Duration(days: 14));
      case 'monthly':
        final next = DateTime(date.year, date.month + 1, date.day);
        // Clamp to end of month (e.g. Jan 31 + 1 month → Feb 28)
        final lastDay = DateTime(date.year, date.month + 2, 0).day;
        if (date.day > lastDay) {
          return DateTime(date.year, date.month + 1, lastDay);
        }
        return next;
      case 'quarterly':
        final next = DateTime(date.year, date.month + 3, date.day);
        final lastDay = DateTime(date.year, date.month + 4, 0).day;
        if (date.day > lastDay) {
          return DateTime(date.year, date.month + 3, lastDay);
        }
        return next;
      case 'annual':
        return DateTime(date.year + 1, date.month, date.day);
      default:
        return date.add(const Duration(days: 30));
    }
  }
}
