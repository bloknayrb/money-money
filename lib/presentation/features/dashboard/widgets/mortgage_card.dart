import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../dashboard_providers.dart';

class MortgageCard extends ConsumerWidget {
  const MortgageCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accountsAsync = ref.watch(mortgageAccountsProvider);

    return accountsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (accounts) {
        if (accounts.isEmpty) return const SizedBox.shrink();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.house,
                        size: 20, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Mortgage',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final account in accounts) ...[
                  _MortgageRow(
                    name: account.name,
                    balanceCents: account.balanceCents,
                  ),
                  if (account != accounts.last) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MortgageRow extends StatelessWidget {
  final String name;
  final int balanceCents;

  const _MortgageRow({required this.name, required this.balanceCents});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    // Balance is negative for liabilities
    final balance = balanceCents.abs();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                name,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              balance.toCurrency(),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: finance.expense,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Remaining balance',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
