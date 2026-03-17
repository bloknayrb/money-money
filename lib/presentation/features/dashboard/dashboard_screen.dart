import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/usecases/sync/simplefin_sync_service.dart';
import '../../shared/utils/provider_invalidation.dart';
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
import 'widgets/cash_flow_forecast_card.dart';
import 'widgets/health_score_card.dart';
import 'widgets/savings_rate_card.dart';
import 'widgets/sync_result_dialog.dart';

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
          _InsightsBadgeButton(),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
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
              context.push(AppRoutes.settings);
            },
          ),
        ),
      );
      return;
    }

    ref.read(_dashboardSyncingProvider.notifier).state = true;

    final summary =
        await ref.read(syncOrchestratorProvider).syncAllConnected(connected);

    ref.read(_dashboardSyncingProvider.notifier).state = false;
    invalidateFinancialData(ref);
    ref.read(alertServiceProvider).runAllChecks();

    if (!context.mounted) return;

    if (summary.firstError != null &&
        summary.transactionsImported == 0 &&
        summary.accountsUpdated == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sync error: ${summary.firstError}')),
      );
    } else {
      final hasUnlinked =
          summary.accountDetails.any((d) => !d.linked);
      final showDialog_ =
          hasUnlinked || summary.transactionsImported > 0;

      if (showDialog_ && summary.accountDetails.isNotEmpty) {
        showDialog(
          context: context,
          builder: (_) => SyncResultDialog(
            accountsUpdated: summary.accountsUpdated,
            transactionsImported: summary.transactionsImported,
            warning: summary.firstError,
            accountDetails: summary.accountDetails,
          ),
        );
      } else {
        final detail = summary.apiTransactionsReceived > 0
            ? '0 new (${summary.apiTransactionsReceived} checked)'
            : '0 new (0 from bank)';
        final warning =
            summary.firstError != null ? ' — ${summary.firstError}' : '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Synced ${summary.accountsUpdated} accounts, $detail$warning'),
          ),
        );
      }
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
        const HealthScoreCard(),
        const SizedBox(height: 16),
        const CashFlowForecastCard(),
        const SizedBox(height: 16),
        const NetWorthCard(),
        const SizedBox(height: 16),
        const SavingsRateCard(),
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
        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }
}

class _InsightsBadgeButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(unreadInsightsCountProvider);
    final count = countAsync.valueOrNull ?? 0;

    return IconButton(
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.notifications_outlined),
      ),
      tooltip: 'Insights',
      onPressed: () {
        StatefulNavigationShell.of(context).goBranch(4);
      },
    );
  }
}
