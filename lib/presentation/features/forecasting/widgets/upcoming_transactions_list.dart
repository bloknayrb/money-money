import 'package:flutter/material.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/usecases/forecasting/forecast_models.dart';

class UpcomingTransactionsList extends StatelessWidget {
  final CashFlowForecast forecast;

  const UpcomingTransactionsList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = theme.finance;

    // Collect days that have transactions, limit to next 30 days
    final daysWithTxns = forecast.days
        .take(31)
        .where((d) => d.transactions.isNotEmpty)
        .toList();

    if (daysWithTxns.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Transactions',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            ...daysWithTxns.map((day) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${_weekday(day.date)} ${day.date.month}/${day.date.day}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  ...day.transactions.map((txn) {
                    final isExpense = txn.amountCents < 0;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(txn.payee, style: theme.textTheme.bodyMedium),
                          Text(
                            txn.amountCents.abs().toCurrency(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isExpense
                                  ? finance.expense
                                  : finance.income,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 8),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  static String _weekday(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
