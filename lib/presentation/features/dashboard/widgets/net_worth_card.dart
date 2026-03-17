import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final assetsAsync = ref.watch(totalAssetsProvider);
    final liabilitiesAsync = ref.watch(totalLiabilitiesProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => StatefulNavigationShell.of(context).goBranch(1),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net Worth',
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
              // Assets / Liabilities row
              _buildAssetsLiabilitiesRow(theme, finance, assetsAsync, liabilitiesAsync),
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
              // Month-over-month delta
              historyAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (history) {
                  if (history.length < 2) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _NetWorthDelta(
                      current: history.last.netWorthCents,
                      previous: history[history.length - 2].netWorthCents,
                    ),
                  );
                },
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
      ),
    );
  }

  Widget _buildAssetsLiabilitiesRow(
    ThemeData theme,
    FinanceColors finance,
    AsyncValue<int> assetsAsync,
    AsyncValue<int> liabilitiesAsync,
  ) {
    final assets = assetsAsync.valueOrNull;
    final liabilities = liabilitiesAsync.valueOrNull;
    if (assets == null && liabilities == null) return const SizedBox.shrink();

    return Row(
      children: [
        Text(
          'Assets ${(assets ?? 0).toCurrency()}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: finance.income,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Liabilities ${(liabilities ?? 0).abs().toCurrency()}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: finance.expense,
          ),
        ),
      ],
    );
  }
}

class _NetWorthDelta extends StatelessWidget {
  final int current;
  final int previous;

  const _NetWorthDelta({required this.current, required this.previous});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final delta = current - previous;
    final isPositive = delta >= 0;
    final color = isPositive ? finance.income : finance.expense;

    String pctText = '';
    if (previous != 0) {
      final pct = (delta / previous.abs() * 100).abs().toStringAsFixed(1);
      pctText = ' ($pct%)';
    }

    return Row(
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}${delta.toCurrency()}$pctText this month',
          style: theme.textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
