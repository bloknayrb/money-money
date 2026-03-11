import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/usecases/sync/simplefin_sync_service.dart';
import 'dashboard_providers.dart';
import 'widgets/net_worth_card.dart';
import 'widgets/cash_flow_card.dart';
import 'widgets/spending_over_time_card.dart';
import 'widgets/spending_by_category_card.dart';
import 'widgets/budget_health_card.dart';
import 'widgets/investments_card.dart';
import 'widgets/mortgage_card.dart';
import 'widgets/retirement_card.dart';
import 'widgets/recent_transactions_card.dart';
import 'widgets/ai_insights_card.dart';

/// Whether a dashboard-triggered sync is in progress.
final _dashboardSyncingProvider = StateProvider<bool>((ref) => false);

/// Dashboard home screen with financial overview cards.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSyncing = ref.watch(_dashboardSyncingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Money'),
        actions: [
          IconButton(
            icon: isSyncing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            tooltip: 'Sync accounts',
            onPressed: isSyncing ? null : () => _syncConnections(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Insights',
            onPressed: () {
              StatefulNavigationShell.of(context).goBranch(3);
            },
          ),
        ],
      ),
      body: _DashboardBody(isSyncing: isSyncing),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.addTransaction);
        },
        icon: const Icon(Icons.add),
        label: const Text('Transaction'),
      ),
    );
  }

  Future<void> _syncConnections(BuildContext context, WidgetRef ref) async {
    final connections =
        await ref.read(bankConnectionRepositoryProvider).getAllConnections();

    final connected = connections
        .where((c) => c.status == ConnectionStatus.connected)
        .toList();

    if (!context.mounted) return;

    if (connected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'No bank connections configured. Add one in Settings.',
          ),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              StatefulNavigationShell.of(context).goBranch(4);
            },
          ),
        ),
      );
      return;
    }

    ref.read(_dashboardSyncingProvider.notifier).state = true;
    final syncService = ref.read(simplefinSyncServiceProvider);

    var totalAccounts = 0;
    var totalTransactions = 0;
    String? firstError;

    try {
      for (final conn in connected) {
        final result = await syncService.syncConnection(conn.id);
        totalAccounts += result.accountsUpdated;
        totalTransactions += result.transactionsImported;
        if (result.errorMessage != null && firstError == null) {
          firstError = result.errorMessage;
        }
      }
    } catch (e) {
      firstError = e.toString();
    } finally {
      ref.read(_dashboardSyncingProvider.notifier).state = false;
    }

    if (!context.mounted) return;

    if (firstError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sync error: $firstError')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Synced $totalAccounts accounts, $totalTransactions new transactions',
          ),
        ),
      );
    }
  }
}

/// Dashboard body with conditional card rendering based on account types.
class _DashboardBody extends ConsumerWidget {
  final bool isSyncing;

  const _DashboardBody({required this.isSyncing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investmentsAsync = ref.watch(investmentAccountsProvider);
    final mortgagesAsync = ref.watch(mortgageAccountsProvider);
    final retirementAsync = ref.watch(retirementAccountsProvider);

    final hasInvestments =
        (investmentsAsync.valueOrNull ?? []).isNotEmpty;
    final hasMortgages =
        (mortgagesAsync.valueOrNull ?? []).isNotEmpty;
    final hasRetirement =
        (retirementAsync.valueOrNull ?? []).isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const NetWorthCard(),
        const SizedBox(height: 16),
        const CashFlowCard(),
        const SizedBox(height: 16),
        const SpendingOverTimeCard(),
        const SizedBox(height: 16),
        const SpendingByCategoryCard(),
        const SizedBox(height: 16),
        const BudgetHealthCard(),
        if (hasInvestments) ...[
          const SizedBox(height: 16),
          const InvestmentsCard(),
        ],
        if (hasMortgages) ...[
          const SizedBox(height: 16),
          const MortgageCard(),
        ],
        if (hasRetirement) ...[
          const SizedBox(height: 16),
          const RetirementCard(),
        ],
        const SizedBox(height: 16),
        const RecentTransactionsCard(),
        const SizedBox(height: 16),
        const AiInsightsCard(),
        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }
}
