import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../transactions/transactions_providers.dart';

/// Nudge card showing count of uncategorized transactions.
class UncategorizedNudgeCard extends ConsumerWidget {
  const UncategorizedNudgeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final countAsync = ref.watch(uncategorizedCountProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Set uncategorized filter, then switch to transactions tab
          ref.read(transactionFiltersProvider.notifier).state =
              const TransactionFilters(uncategorizedOnly: true);
          StatefulNavigationShell.of(context).goBranch(2);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.label_off_outlined,
                  color: theme.colorScheme.onErrorContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uncategorized Transactions',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    countAsync.when(
                      data: (count) => Text(
                        '$count transaction${count == 1 ? '' : 's'} need${count == 1 ? 's' : ''} review',
                        style: theme.textTheme.bodyMedium,
                      ),
                      loading: () => Text(
                        '...',
                        style: theme.textTheme.bodyMedium,
                      ),
                      error: (_, _) => Text(
                        'Unable to check',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
