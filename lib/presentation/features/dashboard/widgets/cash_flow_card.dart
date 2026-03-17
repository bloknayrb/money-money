import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../transactions/transactions_providers.dart';

class CashFlowCard extends ConsumerWidget {
  const CashFlowCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final incomeAsync = ref.watch(monthlyIncomeProvider);
    final expensesAsync = ref.watch(monthlyExpensesProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.analytics),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cash Flow This Month',
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
              const SizedBox(height: 16),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
          ),
        ),
      ),
    );
  }
}
