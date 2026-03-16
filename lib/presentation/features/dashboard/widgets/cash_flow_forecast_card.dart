import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../forecasting/forecast_providers.dart';

class CashFlowForecastCard extends ConsumerWidget {
  const CashFlowForecastCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final forecastAsync = ref.watch(cashFlowForecastProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.forecast),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cash Flow Forecast',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              forecastAsync.when(
                data: (forecast) {
                  if (forecast.days.isEmpty) {
                    return const Text('No recurring transactions to forecast');
                  }
                  // Show 30-day preview
                  final previewDays = forecast.days.take(31).toList();
                  final hasAlerts = forecast.alerts.isNotEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 80,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: previewDays
                                    .asMap()
                                    .entries
                                    .map((e) => FlSpot(
                                          e.key.toDouble(),
                                          e.value.projectedBalanceCents
                                              .toDouble(),
                                        ))
                                    .toList(),
                                isCurved: false,
                                color: hasAlerts
                                    ? finance.expense
                                    : theme.colorScheme.primary,
                                barWidth: 2,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: (hasAlerts
                                          ? finance.expense
                                          : theme.colorScheme.primary)
                                      .withValues(alpha: 0.1),
                                ),
                              ),
                            ],
                            titlesData: const FlTitlesData(show: false),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            lineTouchData:
                                const LineTouchData(enabled: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (hasAlerts)
                        Row(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                size: 16, color: finance.expense),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${forecast.alerts.length} low balance '
                                '${forecast.alerts.length == 1 ? 'alert' : 'alerts'} '
                                'in the next 90 days',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: finance.expense,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Projected: ${previewDays.last.projectedBalanceCents.toCurrency()} in 30 days',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  );
                },
                loading: () => const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => const Text('Unable to forecast'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
