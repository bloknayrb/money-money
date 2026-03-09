import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../accounts/accounts_providers.dart';
import '../dashboard_providers.dart';

class NetWorthCard extends ConsumerWidget {
  const NetWorthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final netWorthAsync = ref.watch(netWorthProvider);
    final accountsAsync = ref.watch(accountsProvider);
    final historyAsync = ref.watch(netWorthHistoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Worth',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            netWorthAsync.when(
              data: (nw) => Text(
                nw.toCurrency(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: nw >= 0 ? finance.netWorthPositive : theme.colorScheme.error,
                ),
              ),
              loading: () => Text(
                '...',
                style: theme.textTheme.headlineMedium,
              ),
              error: (_, _) => Text(
                '--',
                style: theme.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 4),
            accountsAsync.when(
              data: (accounts) {
                if (accounts.isEmpty) {
                  return Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        'Add accounts to track your net worth',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  );
                }
                return Text(
                  '${accounts.length} account${accounts.length == 1 ? '' : 's'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            // Net worth trend chart
            historyAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (history) {
                if (history.length < 2) return const SizedBox.shrink();

                final spots = history.asMap().entries.map((e) {
                  return FlSpot(
                    e.key.toDouble(),
                    e.value.netWorthCents.toDouble(),
                  );
                }).toList();

                final minY = spots
                    .map((s) => s.y)
                    .reduce((a, b) => a < b ? a : b);
                final maxY = spots
                    .map((s) => s.y)
                    .reduce((a, b) => a > b ? a : b);
                final range = maxY - minY;

                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    height: 100,
                    child: LineChart(
                      LineChartData(
                        minY: minY - range * 0.1,
                        maxY: maxY + range * 0.1,
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (spots) {
                              return spots.map((spot) {
                                return LineTooltipItem(
                                  spot.y.round().toCurrency(),
                                  theme.textTheme.bodySmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= history.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    DateFormat.MMM()
                                        .format(history[index].month),
                                    style: theme.textTheme.labelSmall,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            color: finance.netWorthPositive,
                            barWidth: 2,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: finance.netWorthPositive
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
