import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/local/database/models.dart';
import '../../../shared/loading/shimmer_loading.dart';
import '../../transactions/transactions_providers.dart';

class RecentTransactionsCard extends ConsumerWidget {
  const RecentTransactionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final recentAsync = ref.watch(recentTransactionsProvider);

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
                  'Recent Transactions',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Switch to transactions tab (index 2)
                    StatefulNavigationShell.of(context).goBranch(2);
                  },
                  child: const Text('See all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            recentAsync.when(
              loading: () => const ShimmerTransactionList(itemCount: 3),
              error: (_, _) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text('Error loading transactions')),
              ),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No transactions yet. Add one or connect your bank.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: transactions
                      .take(5)
                      .map((t) => _RecentTransactionItem(transaction: t))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _RecentTransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final isIncome = transaction.amountCents > 0;

    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => context.push(AppRoutes.editTransaction, extra: transaction),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
              color: isIncome ? finance.income : theme.colorScheme.error,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                transaction.payee,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              transaction.amountCents.toCurrency(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isIncome ? finance.income : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
