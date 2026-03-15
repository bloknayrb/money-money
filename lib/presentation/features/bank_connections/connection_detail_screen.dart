import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../data/local/database/app_database.dart';
import '../../../domain/usecases/sync/simplefin_sync_service.dart';
import '../budgets/budgets_providers.dart';
import '../dashboard/dashboard_providers.dart';
import '../transactions/transactions_providers.dart';
import 'bank_connections_providers.dart';
import 'widgets/sync_history_card.dart';

final _syncHistoryProvider =
    StreamProvider.autoDispose.family<List<ImportHistoryData>, String>(
  (ref, connectionId) => ref
      .watch(importRepositoryProvider)
      .watchImportHistoryByConnection(connectionId),
);

/// Detail screen for a single bank connection.
class ConnectionDetailScreen extends ConsumerWidget {
  const ConnectionDetailScreen({super.key, required this.connectionId});

  final String connectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionAsync = ref.watch(bankConnectionByIdProvider(connectionId));
    final linkedAsync = ref.watch(linkedAccountsProvider(connectionId));
    final historyAsync = ref.watch(_syncHistoryProvider(connectionId));
    return Scaffold(
      appBar: AppBar(title: const Text('Connection Details')),
      body: connectionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (connection) {
          if (connection == null) {
            return const Center(child: Text('Connection not found.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionTitle(title: 'Connection Info'),
              _InfoRow('Institution', connection.institutionName),
              _InfoRow('Provider', connection.provider),
              _InfoRow('Status', connection.status),
              if (connection.lastSyncedAt != null)
                _InfoRow('Last Synced',
                    connection.lastSyncedAt!.toDateTime().toRelative()),
              _InfoRow('Connected',
                  connection.createdAt.toDateTime().toMediumDate()),
              if (connection.status == ConnectionStatus.error &&
                  connection.errorMessage != null) ...[
                const SizedBox(height: 12),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: Theme.of(context).colorScheme.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(connection.errorMessage!,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onErrorContainer)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const _SectionTitle(title: 'Linked Accounts'),
              linkedAsync.when(
                loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator())),
                error: (e, _) => Text('Error: $e'),
                data: (accounts) {
                  if (accounts.isEmpty) {
                    return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('No accounts linked.'));
                  }
                  return Column(
                    children: accounts
                        .map((a) => ListTile(
                              dense: true,
                              leading:
                                  const Icon(Icons.account_balance, size: 20),
                              title: Text(a.name),
                              subtitle: Text(a.accountType),
                              trailing: Text(a.balanceCents.toCurrency(),
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              const _SectionTitle(title: 'Sync History'),
              historyAsync.when(
                loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator())),
                error: (e, _) => Text('Error: $e'),
                data: (records) {
                  if (records.isEmpty) {
                    return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('No sync history yet.'));
                  }
                  return Column(
                      children:
                          records.map((r) => SyncHistoryCard(record: r)).toList());
                },
              ),
              const SizedBox(height: 20),
              const _SectionTitle(title: 'Actions'),
              const SizedBox(height: 8),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: connection.status != ConnectionStatus.disconnected
                        ? () => _sync(context, ref)
                        : null,
                    icon: const Icon(Icons.sync),
                    label: const Text('Sync Now'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () =>
                        context.push('${AppRoutes.accountLinking}/$connectionId'),
                    child: const Text('Re-link Accounts'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _confirmDisconnect(context, ref),
                icon: Icon(Icons.link_off,
                    color: Theme.of(context).colorScheme.error),
                label: Text('Disconnect',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Future<void> _sync(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(simplefinSyncServiceProvider).syncConnection(connectionId);
    // Refresh cached FutureProviders after sync
    ref.invalidate(monthlyIncomeProvider);
    ref.invalidate(monthlyExpensesProvider);
    ref.invalidate(spendingByCategoryProvider);
    ref.invalidate(monthlySpendingHistoryProvider);
    ref.invalidate(netWorthHistoryProvider);
    ref.invalidate(uncategorizedCountProvider);
    ref.invalidate(budgetsWithSpentProvider);
    if (context.mounted) {
      final String msg;
      if (result.rateLimited) {
        msg = 'Rate limited. Try again later.';
      } else if (result.errorMessage != null &&
          result.transactionsImported == 0 &&
          result.accountsUpdated == 0) {
        msg = 'Sync error: ${result.errorMessage}';
      } else {
        final detail = result.transactionsImported > 0
            ? '${result.transactionsImported} new'
            : result.apiTransactionsReceived > 0
                ? '0 new (${result.apiTransactionsReceived} checked)'
                : '0 new (0 from bank)';
        final warning =
            result.errorMessage != null ? ' — ${result.errorMessage}' : '';
        msg = 'Synced: $detail, ${result.transactionsSkipped} skipped$warning';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _confirmDisconnect(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Bank?'),
        content: const Text(
            'This will unlink all accounts from this connection. '
            'Your transaction history will be preserved.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Disconnect')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(simplefinSyncServiceProvider).disconnect(connectionId);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Bank disconnected.')));
        context.pop();
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600)),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
                width: 120,
                child:
                    Text(label, style: Theme.of(context).textTheme.bodySmall)),
            Expanded(
                child:
                    Text(value, style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
      );
}
