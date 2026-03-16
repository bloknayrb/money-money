import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/usecases/analytics/analytics_models.dart';
import '../analytics_providers.dart';

class CashFlowTab extends ConsumerWidget {
  const CashFlowTab({super.key});

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
        return _CashFlowChart(data: data, finance: finance, theme: theme);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _CashFlowChart extends StatelessWidget {
  final List<MonthlyCashFlow> data;
  final FinanceColors finance;
  final ThemeData theme;

  const _CashFlowChart({
    required this.data,
    required this.finance,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = data.fold<int>(0, (max, cf) {
      final m = cf.incomeCents > cf.expenseCents
          ? cf.incomeCents
          : cf.expenseCents;
      return m > max ? m : max;
    });
    final interval = _calcInterval(maxVal);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _SummaryRow(data: data, finance: finance, theme: theme),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal.toDouble() * 1.1,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.round().toCurrency(),
                        TextStyle(
                          color: rod.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= data.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _monthLabel(data[idx].month),
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
                      interval: interval,
                      getTitlesWidget: (value, _) {
                        return Text(
                          value.round().toCompactCurrency(),
                          style: theme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(horizontalInterval: interval),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].incomeCents.toDouble(),
                        color: finance.income,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: data[i].expenseCents.toDouble(),
                        color: finance.expense,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: finance.income, label: 'Income'),
              const SizedBox(width: 24),
              _LegendDot(color: finance.expense, label: 'Expenses'),
            ],
          ),
        ],
      ),
    );
  }

  static String _monthLabel(DateTime month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month.month - 1];
  }

  static double _calcInterval(int maxVal) {
    if (maxVal <= 0) return 100.0;
    final dollars = maxVal / 100;
    if (dollars <= 1000) return 25000;
    if (dollars <= 5000) return 100000;
    return 250000;
  }
}

class _SummaryRow extends StatelessWidget {
  final List<MonthlyCashFlow> data;
  final FinanceColors finance;
  final ThemeData theme;

  const _SummaryRow({
    required this.data,
    required this.finance,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final latest = data.last;
    final net = latest.incomeCents - latest.expenseCents;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatColumn(
          label: 'Income',
          value: latest.incomeCents.toCurrency(),
          color: finance.income,
          theme: theme,
        ),
        _StatColumn(
          label: 'Expenses',
          value: latest.expenseCents.toCurrency(),
          color: finance.expense,
          theme: theme,
        ),
        _StatColumn(
          label: 'Net',
          value: net.toCurrency(),
          color: net >= 0 ? finance.income : finance.expense,
          theme: theme,
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall
              ?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
