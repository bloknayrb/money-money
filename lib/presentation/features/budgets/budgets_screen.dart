import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/database/app_database.dart';
import '../../shared/empty_states/empty_state_widget.dart';
import '../../shared/loading/shimmer_loading.dart';
import 'add_edit_budget_screen.dart';
import 'ai_budget_suggestion_screen.dart';
import 'budgets_providers.dart';

/// Budget list screen with summary card and per-budget progress bars.
class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsWithSpentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          // AI suggestions — only visible when LLM is configured
          if (ref.watch(activeLlmClientProvider).valueOrNull != null)
            IconButton(
              icon: const Icon(Icons.auto_awesome),
              tooltip: 'AI budget suggestions',
              onPressed: () async {
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => const AiBudgetSuggestionScreen(),
                  ),
                );
                if (result == true) {
                  ref.invalidate(budgetsWithSpentProvider);
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add budget',
            onPressed: () => _navigateToAddBudget(context, ref),
          ),
        ],
      ),
      body: budgetsAsync.when(
        loading: () => const ShimmerTransactionList(itemCount: 5),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (budgets) {
          if (budgets.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.pie_chart_outline,
              title: 'No budgets yet',
              description:
                  'Create budgets to track your spending by category and stay on top of your finances.',
              actionLabel: 'Add Budget',
              onAction: () => _navigateToAddBudget(context, ref),
            );
          }
          return _BudgetsListView(budgets: budgets);
        },
      ),
    );
  }

  Future<void> _navigateToAddBudget(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const AddEditBudgetScreen(),
      ),
    );
    if (result == true) {
      ref.invalidate(budgetsWithSpentProvider);
    }
  }
}

/// List view with summary header and individual budget items.
class _BudgetsListView extends ConsumerWidget {
  final List<BudgetWithSpent> budgets;

  const _BudgetsListView({required this.budgets});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final categoryMap = categoriesAsync.whenData((cats) {
      return {for (final c in cats) c.id: c};
    });

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        _SummaryCard(budgets: budgets),
        const SizedBox(height: 8),
        for (final item in budgets)
          _BudgetTile(
            item: item,
            category: categoryMap.valueOrNull?[item.budget.categoryId],
          ),
      ],
    );
  }
}

/// Summary card showing total budgeted vs total spent this month.
class _SummaryCard extends StatelessWidget {
  final List<BudgetWithSpent> budgets;

  const _SummaryCard({required this.budgets});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final finance = theme.finance;

    final totalBudgeted =
        budgets.fold<int>(0, (sum, b) => sum + b.budget.amountCents);
    final totalSpent = budgets.fold<int>(0, (sum, b) => sum + b.spentCents);
    final overallPercentage =
        totalBudgeted > 0 ? totalSpent.toDouble() / totalBudgeted : 0.0;
    final progressColor = _budgetColor(finance, overallPercentage);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Overview',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Budgeted',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                      Text(
                        totalBudgeted.toCurrency(),
                        style: theme.textTheme.bodyLarge?.copyWith(
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
                      Text('Spent',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                      Text(
                        totalSpent.toCurrency(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: progressColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Remaining',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                      Text(
                        (totalBudgeted - totalSpent).toCurrency(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: progressColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: overallPercentage.clamp(0.0, 1.0),
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: progressColor,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single budget list item with category name, amounts, and progress bar.
class _BudgetTile extends ConsumerWidget {
  final BudgetWithSpent item;
  final Category? category;

  const _BudgetTile({required this.item, this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final finance = theme.finance;
    final progressColor = _budgetColor(finance, item.percentage);
    final remaining = item.budget.amountCents - item.spentCents;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: category != null
            ? Color(category!.color).withValues(alpha: 0.15)
            : colorScheme.primaryContainer,
        child: Icon(
          Icons.pie_chart_outline,
          color: category != null
              ? Color(category!.color)
              : colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        category?.name ?? 'Unknown Category',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.percentage.clamp(0.0, 1.0),
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: progressColor,
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${item.spentCents.toCurrency()} of ${item.budget.amountCents.toCurrency()}'
            ' ${remaining >= 0 ? '(${remaining.toCurrency()} left)' : '(${remaining.abs().toCurrency()} over)'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: progressColor,
            ),
          ),
        ],
      ),
      trailing: Text(
        item.budget.periodType == 'monthly' ? 'Monthly' : 'Annual',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () async {
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => AddEditBudgetScreen(budget: item.budget),
          ),
        );
        if (result == true) {
          ref.invalidate(budgetsWithSpentProvider);
        }
      },
    );
  }
}

/// Returns the appropriate budget color based on spending percentage.
/// On track: < 75%, Warning: 75-100%, Over: > 100%.
Color _budgetColor(FinanceColors finance, double percentage) {
  if (percentage > 1.0) return finance.budgetOver;
  if (percentage >= 0.75) return finance.budgetWarning;
  return finance.budgetOnTrack;
}
