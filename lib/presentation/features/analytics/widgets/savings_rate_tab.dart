import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../analytics_providers.dart';

class SavingsRateTab extends ConsumerWidget {
  const SavingsRateTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final cashFlowAsync = ref.watch(monthlyCashFlowProvider);

    return cashFlowAsync.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(child: Text('No transaction data yet'));
        }

        final spots = data.asMap().entries.map((e) {
          return FlSpot(
            e.key.toDouble(),
            (e.value.savingsRate * 100).clamp(-50.0, 100.0),
          );
        }).toList();

        final avgRate =
            data.fold<double>(0, (s, cf) => s + cf.savingsRate) / data.length;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '${(data.last.savingsRate * 100).round()}%',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: data.last.savingsRate >= 0.2
                      ? finance.income
                      : finance.expense,
                ),
              ),
              Text(
                'this month (avg ${(avgRate * 100).round()}%)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: LineChart(
                  LineChartData(
                    minY: -50,
                    maxY: 100,
                    clipData: const FlClipData.all(),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: theme.colorScheme.primary,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, _, _, _) =>
                              FlDotCirclePainter(
                            radius: 4,
                            color: theme.colorScheme.primary,
                            strokeWidth: 0,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.1),
                        ),
                      ),
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 20),
                          FlSpot(data.length - 1, 20),
                        ],
                        isCurved: false,
                        color: finance.income.withValues(alpha: 0.5),
                        barWidth: 1,
                        dashArray: [8, 4],
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= data.length) {
                              return const SizedBox.shrink();
                            }
                            const months = [
                              'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                months[data[idx].month.month - 1],
                                style: theme.textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 25,
                          getTitlesWidget: (value, _) {
                            return Text(
                              '${value.round()}%',
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
                    gridData: FlGridData(
                      horizontalInterval: 25,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: theme.colorScheme.outlineVariant
                            .withValues(alpha: 0.3),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (spots) {
                          return spots.map((spot) {
                            if (spot.barIndex == 1) return null;
                            return LineTooltipItem(
                              '${spot.y.round()}%',
                              TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 1,
                    color: finance.income.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '20% goal',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
