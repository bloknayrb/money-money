import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../budgets/budgets_providers.dart';

class BudgetHealthCard extends ConsumerWidget {
  const BudgetHealthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final budgetsAsync = ref.watch(budgetsWithSpentProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget Health',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.push(AppRoutes.budgets);
                  },
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            budgetsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text('Error loading budgets')),
              ),
              data: (budgets) {
                if (budgets.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Create your first budget to track spending',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }

                // Build category name lookup
                final categoryNames = <String, String>{};
                categoriesAsync.whenData((cats) {
                  for (final c in cats) {
                    categoryNames[c.id] = c.name;
                  }
                });

                // Show top 3 budgets sorted by percentage (worst first)
                final sorted = List.of(budgets)
                  ..sort((a, b) => b.percentage.compareTo(a.percentage));
                final top = sorted.take(3);

                return Column(
                  children: [
                    for (final bws in top)
                      _BudgetRow(
                        name: categoryNames[bws.budget.categoryId] ??
                            'Budget',
                        spentCents: bws.spentCents,
                        limitCents: bws.budget.amountCents,
                        percentage: bws.percentage,
                        finance: finance,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  final String name;
  final int spentCents;
  final int limitCents;
  final double percentage;
  final FinanceColors finance;

  const _BudgetRow({
    required this.name,
    required this.spentCents,
    required this.limitCents,
    required this.percentage,
    required this.finance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = percentage > 1.0
        ? finance.budgetOver
        : percentage >= 0.75
            ? finance.budgetWarning
            : finance.budgetOnTrack;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  name,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${spentCents.toCurrency()} / ${limitCents.toCurrency()}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
