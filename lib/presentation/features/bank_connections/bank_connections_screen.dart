import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/database/app_database.dart';
import '../../../core/di/providers.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/usecases/sync/simplefin_sync_service.dart';
import 'bank_connections_providers.dart';
import 'widgets/connection_card.dart';

/// Screen listing all bank connections with sync controls.
class BankConnectionsScreen extends ConsumerWidget {
  const BankConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionsAsync = ref.watch(bankConnectionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bank Connections')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.simplefinSetup),
        icon: const Icon(Icons.add),
        label: const Text('Connect'),
      ),
      body: connectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (connections) {
          if (connections.isEmpty) {
            return _buildEmptyState(context);
          }
          return RefreshIndicator(
            onRefresh: () => _syncAll(ref, connections),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: connections.length,
              itemBuilder: (context, index) {
                final connection = connections[index];
                return _ConnectionItem(connection: connection);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No bank connections yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Connect a bank to sync accounts automatically.'),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.simplefinSetup),
            icon: const Icon(Icons.add),
            label: const Text('Connect a Bank'),
          ),
        ],
      ),
    );
  }

  Future<void> _syncAll(WidgetRef ref, List connections) async {
    final syncService = ref.read(simplefinSyncServiceProvider);
    for (final connection in connections) {
      if (connection.status == ConnectionStatus.disconnected) continue;
      await syncService.syncConnection(connection.id);
    }
  }
}

class _ConnectionItem extends ConsumerWidget {
  const _ConnectionItem({required this.connection});

  final BankConnection connection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkedAccounts = ref.watch(
      linkedAccountsProvider(connection.id),
    );
    final syncInProgress = ref.watch(
      syncInProgressProvider(connection.id),
    );

    final accountCount = linkedAccounts.valueOrNull?.length ?? 0;

    return ConnectionCard(
      connection: connection,
      linkedAccountCount: accountCount,
      canSync: !syncInProgress && connection.status != 'disconnected',
      onSync: () => _sync(context, ref, connection.id),
      onTap: () => context.push(
        '${AppRoutes.connectionDetail}/${connection.id}',
      ),
    );
  }

  Future<void> _sync(
    BuildContext context,
    WidgetRef ref,
    String connectionId,
  ) async {
    ref.read(syncInProgressProvider(connectionId).notifier).state = true;

    try {
      final syncService = ref.read(simplefinSyncServiceProvider);
      final result = await syncService.syncConnection(connectionId);
      ref.read(lastSyncResultProvider(connectionId).notifier).state = result;

      if (context.mounted) {
        final msg = result.rateLimited
            ? 'Rate limited. Try again later.'
            : result.errorMessage ??
                'Synced: ${result.transactionsImported} new, '
                    '${result.transactionsSkipped} skipped';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } finally {
      ref.read(syncInProgressProvider(connectionId).notifier).state = false;
    }
  }
}
