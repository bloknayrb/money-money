import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../analytics/analytics_providers.dart';
import '../../transactions/transactions_providers.dart';
import '../dashboard_providers.dart';

/// Which view is active in the consolidated spending analytics card.
enum _AnalyticsView { expenses, category, incomeVsExpense, cashFlow, savings }

final _analyticsViewProvider =
    StateProvider.autoDispose<_AnalyticsView>((_) => _AnalyticsView.expenses);

/// Consolidated card combining monthly expenses, spending by category,
/// income vs expenses, cash flow, and savings rate.
class SpendingAnalyticsCard extends ConsumerWidget {
  const SpendingAnalyticsCard({super.key});

  static const _viewMeta = {
    _AnalyticsView.expenses: (Icons.bar_chart, 'Monthly Expenses'),
    _AnalyticsView.category: (Icons.pie_chart_outline, 'By Category'),
    _AnalyticsView.incomeVsExpense:
        (Icons.stacked_bar_chart, 'Income vs Expenses'),
    _AnalyticsView.cashFlow: (Icons.swap_vert, 'Cash Flow'),
    _AnalyticsView.savings: (Icons.savings_outlined, 'Savings Rate'),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final view = ref.watch(_analyticsViewProvider);
    final (_, title) = _viewMeta[view]!;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.analytics),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and chevron
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
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
              // View selector — icon-only segmented button
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<_AnalyticsView>(
                  showSelectedIcon: false,
                  segments: [
                    for (final v in _AnalyticsView.values)
                      ButtonSegment(
                        value: v,
                        icon: Icon(_viewMeta[v]!.$1, size: 18),
                      ),
                  ],
                  selected: {view},
                  onSelectionChanged: (s) =>
                      ref.read(_analyticsViewProvider.notifier).state = s.first,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Content area
              switch (view) {
                _AnalyticsView.expenses => const _ExpensesView(),
                _AnalyticsView.category => const _CategoryView(),
                _AnalyticsView.incomeVsExpense =>
                  const _IncomeVsExpenseView(),
                _AnalyticsView.cashFlow => const _CashFlowView(),
                _AnalyticsView.savings => const _SavingsView(),
              },
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// View 1: Monthly Expenses bar chart
// ---------------------------------------------------------------------------
class _ExpensesView extends ConsumerWidget {
  const _ExpensesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(monthlySpendingHistoryProvider);

    return dataAsync.when(
      loading: () => const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox(
        height: 180,
        child: Center(child: Text('Error loading data')),
      ),
      data: (data) {
        if (data.isEmpty || data.every((d) => d.expenseCents == 0)) {
          return _emptyState(theme, 'No spending data yet');
        }

        final maxY = data
            .map((d) => d.expenseCents.toDouble())
            .reduce((a, b) => a > b ? a : b);

        return SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY * 1.15,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      rod.toY.round().toCurrency(),
                      theme.textTheme.bodySmall!
                          .copyWith(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat.MMM().format(data[index].month),
                          style: theme.textTheme.labelSmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              barGroups: data.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.expenseCents.toDouble(),
                      color: theme.colorScheme.primary,
                      width: 24,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// View 2: Spending by category pie chart
// ---------------------------------------------------------------------------
class _CategoryView extends ConsumerWidget {
  const _CategoryView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(spendingByCategoryProvider);

    return dataAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox(
        height: 200,
        child: Center(child: Text('Error loading data')),
      ),
      data: (data) {
        if (data.isEmpty) {
          return _emptyState(theme, 'No categorized spending this month');
        }

        final total = data.fold<int>(0, (sum, c) => sum + c.amountCents);

        return Column(
          children: [
            SizedBox(
              height: 160,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,
                  sections: data.map((c) {
                    final pct =
                        total > 0 ? (c.amountCents / total * 100) : 0.0;
                    return PieChartSectionData(
                      value: c.amountCents.toDouble(),
                      color: Color(c.color),
                      radius: 40,
                      title: pct >= 10 ? '${pct.round()}%' : '',
                      titleStyle: theme.textTheme.labelSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 0,
              children: data.map((c) {
                return InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {
                    ref.read(transactionFiltersProvider.notifier).state =
                        TransactionFilters(categoryId: c.categoryId);
                    StatefulNavigationShell.of(context).goBranch(2);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Color(c.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${c.categoryName} ${c.amountCents.toCurrency()}',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// View 3: Income vs expenses grouped bars
// ---------------------------------------------------------------------------
class _IncomeVsExpenseView extends ConsumerWidget {
  const _IncomeVsExpenseView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final cashFlowAsync = ref.watch(monthlyCashFlowProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _LegendDot(color: finance.income, label: 'Income'),
            const SizedBox(width: 16),
            _LegendDot(color: finance.expense, label: 'Expenses'),
          ],
        ),
        const SizedBox(height: 8),
        cashFlowAsync.when(
          loading: () => const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const SizedBox(
            height: 180,
            child: Center(child: Text('Unable to load data')),
          ),
          data: (cashFlow) {
            if (cashFlow.isEmpty) {
              return _emptyState(theme, 'No data yet');
            }

            final monthFmt = DateFormat.MMM();
            return SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final value = rod.toY.round();
                        final label = rodIndex == 0 ? 'Income' : 'Expenses';
                        return BarTooltipItem(
                          '$label\n${value.toCurrency()}',
                          TextStyle(
                            color: theme.colorScheme.onInverseSurface,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= cashFlow.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              monthFmt.format(cashFlow[idx].month),
                              style: theme.textTheme.labelSmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: [
                    for (var i = 0; i < cashFlow.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: cashFlow[i].incomeCents / 100.0,
                            color: finance.income,
                            width: 8,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(2),
                            ),
                          ),
                          BarChartRodData(
                            toY: cashFlow[i].expenseCents.abs() /
                                100.0,
                            color: finance.expense,
                            width: 8,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(2),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// View 4: Cash flow this month
// ---------------------------------------------------------------------------
class _CashFlowView extends ConsumerWidget {
  const _CashFlowView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final incomeAsync = ref.watch(monthlyIncomeProvider);
    final expensesAsync = ref.watch(monthlyExpensesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Income', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    incomeAsync.when(
                      data: (v) => v.toCurrency(),
                      loading: () => '...',
                      error: (_, _) => '--',
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: finance.income,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expenses', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    expensesAsync.when(
                      data: (v) => v.abs().toCurrency(),
                      loading: () => '...',
                      error: (_, _) => '--',
                    ),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: finance.expense,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Income vs expense bar
        Builder(
          builder: (context) {
            final income = incomeAsync.valueOrNull ?? 0;
            final expenses = (expensesAsync.valueOrNull ?? 0).abs();
            final total = income + expenses;
            if (total == 0) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    children: [
                      Expanded(
                        flex: income,
                        child: ColoredBox(color: finance.income),
                      ),
                      Expanded(
                        flex: expenses,
                        child: ColoredBox(color: finance.expense),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // Net cash flow
        Builder(
          builder: (context) {
            final income = incomeAsync.valueOrNull ?? 0;
            final expenses = expensesAsync.valueOrNull ?? 0;
            final net = income + expenses; // expenses are negative
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    net.toCurrency(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: net >= 0 ? finance.income : finance.expense,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// View 5: Savings rate
// ---------------------------------------------------------------------------
class _SavingsView extends ConsumerWidget {
  const _SavingsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final rateAsync = ref.watch(savingsRateProvider);
    final cashFlowAsync = ref.watch(monthlyCashFlowProvider);

    return rateAsync.when(
      data: (rate) {
        final pct = (rate * 100).round();
        final isPositive = rate >= 0;
        final prevRate = cashFlowAsync.whenOrNull(
          data: (cashFlow) => cashFlow.length >= 2
              ? cashFlow[cashFlow.length - 2].savingsRate
              : null,
        );
        final trendUp = prevRate != null ? rate > prevRate : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$pct%',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPositive ? finance.income : finance.expense,
                  ),
                ),
                if (trendUp != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    trendUp ? Icons.trending_up : Icons.trending_down,
                    color: trendUp ? finance.income : finance.expense,
                    size: 20,
                  ),
                ],
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'of income saved',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (rate / 0.20).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: isPositive ? finance.income : finance.expense,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Goal: 20%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
      loading: () => Text('...', style: theme.textTheme.headlineLarge),
      error: (_, _) => Text('--', style: theme.textTheme.headlineLarge),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------
Widget _emptyState(ThemeData theme, String message) {
  return SizedBox(
    height: 180,
    child: Center(
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ),
  );
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
