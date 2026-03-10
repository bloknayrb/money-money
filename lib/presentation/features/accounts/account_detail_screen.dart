import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/database/app_database.dart';
import '../../shared/loading/shimmer_loading.dart';
import '../transactions/transactions_providers.dart';
import 'accounts_providers.dart';

/// Account detail screen showing account info and its transaction history.
class AccountDetailScreen extends ConsumerWidget {
  final String accountId;

  const AccountDetailScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountByIdProvider(accountId));
    final transactionsAsync =
        ref.watch(accountTransactionsProvider(accountId));
    final theme = Theme.of(context);
    final finance = theme.finance;

    return Scaffold(
      appBar: AppBar(
        title: accountAsync.when(
          data: (a) => Text(a?.name ?? 'Account'),
          loading: () => const Text('Account'),
          error: (_, _) => const Text('Account'),
        ),
        actions: [
          accountAsync.when(
            data: (account) {
              if (account == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit account',
                onPressed: () {
                  context.push(AppRoutes.editAccount, extra: account);
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: accountAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (account) {
          if (account == null) {
            return const Center(child: Text('Account not found'));
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              // Balance header card
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        account.balanceCents.toCurrency(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: account.isAsset
                              ? theme.colorScheme.primary
                              : theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              getAccountTypeLabel(account.accountType),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              account.isAsset ? 'Asset' : 'Liability',
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      if (account.institutionName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          account.institutionName!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Transactions header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  'Transactions',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Transactions list
              transactionsAsync.when(
                loading: () => const ShimmerTransactionList(itemCount: 5),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error loading transactions: $e'),
                ),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'No transactions in this account yet',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: transactions
                        .map((t) => _AccountTransactionTile(
                              transaction: t,
                              finance: finance,
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.addTransaction, extra: accountId);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AccountTransactionTile extends StatelessWidget {
  final Transaction transaction;
  final FinanceColors finance;

  const _AccountTransactionTile({
    required this.transaction,
    required this.finance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIncome = transaction.amountCents > 0;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isIncome
            ? finance.income.withValues(alpha: 0.15)
            : colorScheme.errorContainer,
        child: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIncome ? finance.income : colorScheme.error,
          size: 20,
        ),
      ),
      title: Text(
        transaction.payee,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        transaction.date.toDateTime().toMediumDate(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        transaction.amountCents.toCurrency(),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isIncome ? finance.income : colorScheme.onSurface,
        ),
      ),
      onTap: () {
        context.push(AppRoutes.editTransaction, extra: transaction);
      },
    );
  }
}
