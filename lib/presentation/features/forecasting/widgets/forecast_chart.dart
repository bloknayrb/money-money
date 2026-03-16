import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/usecases/forecasting/forecast_models.dart';

class ForecastChart extends StatefulWidget {
  final CashFlowForecast forecast;

  const ForecastChart({super.key, required this.forecast});

  @override
  State<ForecastChart> createState() => _ForecastChartState();
}

class _ForecastChartState extends State<ForecastChart> {
  int _daysToShow = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final days = widget.forecast.days.take(_daysToShow + 1).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Projected Balance',
                  style: theme.textTheme.titleSmall,
                ),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 30, label: Text('30d')),
                    ButtonSegment(value: 60, label: Text('60d')),
                    ButtonSegment(value: 90, label: Text('90d')),
                  ],
                  selected: {_daysToShow},
                  onSelectionChanged: (v) =>
                      setState(() => _daysToShow = v.first),
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: WidgetStatePropertyAll(
                        theme.textTheme.bodySmall),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: days
                          .asMap()
                          .entries
                          .map((e) => FlSpot(
                                e.key.toDouble(),
                                e.value.projectedBalanceCents.toDouble(),
                              ))
                          .toList(),
                      isCurved: false,
                      color: theme.colorScheme.primary,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (_daysToShow / 4).ceilToDouble(),
                        getTitlesWidget: (value, _) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= days.length) {
                            return const SizedBox.shrink();
                          }
                          final d = days[idx].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${d.month}/${d.day}',
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, _) {
                          return Text(
                            value.round().toCompactCurrency(),
                            style: theme.textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          final day = days[spot.x.toInt()];
                          return LineTooltipItem(
                            '${day.date.month}/${day.date.day}\n'
                            '${day.projectedBalanceCents.toCurrency()}',
                            TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (widget.forecast.alerts.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...widget.forecast.alerts.take(3).map((alert) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 16, color: finance.expense),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${alert.date.month}/${alert.date.day}: '
                          '${alert.projectedBalanceCents.toCurrency()} '
                          'after ${alert.triggerPayee}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: finance.expense,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
