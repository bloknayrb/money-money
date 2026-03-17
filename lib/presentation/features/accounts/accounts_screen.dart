import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../data/local/database/models.dart';
import '../../shared/empty_states/empty_state_widget.dart';
import '../../shared/loading/shimmer_loading.dart';
import 'account_detail_screen.dart';
import 'accounts_providers.dart';

/// Accounts list screen grouped by account type with net worth header.
class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add account',
            onPressed: () => _navigateToAddAccount(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: accountsAsync.when(
        loading: () => const ShimmerTransactionList(itemCount: 5),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (accounts) {
          if (accounts.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.account_balance,
              title: 'No accounts yet',
              description:
                  'Add your bank accounts, credit cards, and investments to see your full financial picture.',
              actionLabel: 'Add Account',
              onAction: () => _navigateToAddAccount(context),
            );
          }
          return _AccountsListView(accounts: accounts);
        },
      ),
    );
  }

  void _navigateToAddAccount(BuildContext context) {
    context.push(AppRoutes.addAccount);
  }
}

/// Grouped account list with net worth summary header.
class _AccountsListView extends ConsumerWidget {
  final List<Account> accounts;

  const _AccountsListView({required this.accounts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final netWorthAsync = ref.watch(netWorthProvider);
    final grouped = _groupAccounts(accounts);

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // Net worth header
        _NetWorthHeader(netWorthAsync: netWorthAsync, accounts: accounts),
        const SizedBox(height: 8),

        // Grouped accounts
        for (final entry in grouped.entries) ...[
          _AccountGroupHeader(
            title: entry.key,
            total: entry.value.fold<int>(0, (sum, a) => sum + a.balanceCents),
          ),
          for (final account in entry.value)
            _AccountTile(account: account),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Map<String, List<Account>> _groupAccounts(List<Account> accounts) {
    final groups = <String, List<Account>>{};
    for (final account in accounts) {
      String groupName = 'Other';
      for (final entry in accountTypeGroups.entries) {
        if (entry.value.contains(account.accountType)) {
          groupName = entry.key;
          break;
        }
      }
      groups.putIfAbsent(groupName, () => []).add(account);
    }
    return groups;
  }
}

class _NetWorthHeader extends StatelessWidget {
  final AsyncValue<int> netWorthAsync;
  final List<Account> accounts;

  const _NetWorthHeader({
    required this.netWorthAsync,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int totalAssets = 0;
    int totalLiabilities = 0;
    for (final a in accounts) {
      if (a.isAsset) {
        totalAssets += a.balanceCents;
      } else {
        totalLiabilities += a.balanceCents;
      }
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Worth',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              netWorthAsync.when(
                data: (v) => v.toCurrency(),
                loading: () => '...',
                error: (_, _) => '--',
              ),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: (netWorthAsync.valueOrNull ?? 0) >= 0
                    ? colorScheme.primary
                    : colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assets',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                      Text(
                        totalAssets.toCurrency(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Liabilities',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                      Text(
                        totalLiabilities.toCurrency(),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountGroupHeader extends StatelessWidget {
  final String title;
  final int total;

  const _AccountGroupHeader({required this.title, required this.total});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            total.toCurrency(),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final Account account;

  const _AccountTile({required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typeLabel = getAccountTypeLabel(account.accountType);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: account.color != null
            ? Color(account.color!).withValues(alpha: 0.15)
            : colorScheme.primaryContainer,
        child: Icon(
          Icons.account_balance,
          color: account.color != null
              ? Color(account.color!)
              : colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        account.name,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        account.institutionName ?? typeLabel,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        account.balanceCents.toCurrency(),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: account.isAsset ? colorScheme.primary : colorScheme.error,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AccountDetailScreen(accountId: account.id),
          ),
        );
      },
    );
  }
}

