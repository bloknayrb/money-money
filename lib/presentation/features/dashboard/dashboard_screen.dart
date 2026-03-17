import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/usecases/sync/simplefin_sync_service.dart';
import '../../shared/utils/provider_invalidation.dart';
import 'dashboard_card_registry.dart';
import 'dashboard_providers.dart';
import 'widgets/dashboard_edit_mode.dart';
import 'widgets/sync_result_dialog.dart';

/// Whether a dashboard-triggered sync is in progress.
final _dashboardSyncingProvider = StateProvider<bool>((ref) => false);

/// Dashboard home screen with financial overview cards.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSyncing = ref.watch(_dashboardSyncingProvider);
    final isEditing = ref.watch(dashboardEditModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Money'),
        actions: [
          if (!isEditing) ...[
            IconButton(
              icon: isSyncing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              tooltip: 'Sync accounts',
              onPressed:
                  isSyncing ? null : () => _syncConnections(context, ref),
            ),
            _InsightsBadgeButton(),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Customize dashboard',
              onPressed: () {
                ref.read(dashboardEditModeProvider.notifier).state = true;
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'settings') {
                  context.push(AppRoutes.settings);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text('Settings'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: 'Done editing',
              onPressed: () {
                ref.read(dashboardEditModeProvider.notifier).state = false;
              },
            ),
        ],
      ),
      body: isEditing
          ? const DashboardEditMode()
          : _DashboardBody(isSyncing: isSyncing),
      floatingActionButton: isEditing
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.addTransaction),
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
            onPressed: () => context.push(AppRoutes.settings),
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
      final hasUnlinked = summary.accountDetails.any((d) => !d.linked);
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

/// Breakpoint for switching from single-column to multi-column layout.
const _wideBreakpoint = 600.0;

/// Dashboard body with registry-driven card rendering.
class _DashboardBody extends ConsumerWidget {
  final bool isSyncing;

  const _DashboardBody({required this.isSyncing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutAsync = ref.watch(dashboardLayoutProvider);

    return layoutAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const Center(child: Text('Error loading dashboard')),
      data: (layout) => _buildCardLayout(context, ref, layout),
    );
  }

  Widget _buildCardLayout(
    BuildContext context,
    WidgetRef ref,
    List<DashboardCardConfig> layout,
  ) {
    // Build the list of visible cards with their definitions
    final visibleCards = <(DashboardCardDefinition, DashboardCardConfig)>[];

    for (final config in layout) {
      if (!config.visible) continue;

      final def = dashboardCardDefinitionsMap[config.id];
      if (def == null) continue;

      // Check condition provider (auto-hide when no data)
      if (def.condition != null) {
        final conditionMet = ref.watch(def.condition!);
        if (!conditionMet) continue;
      }

      visibleCards.add((def, config));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _wideBreakpoint;
        const spacing = 16.0;

        if (!isWide) {
          // Phone: single column ListView
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (var i = 0; i < visibleCards.length; i++) ...[
                if (i > 0) const SizedBox(height: spacing),
                KeyedSubtree(
                  key: ValueKey(visibleCards[i].$1.id),
                  child: visibleCards[i].$1.builder(),
                ),
              ],
              const SizedBox(height: 80), // FAB clearance
            ],
          );
        }

        // Wide: Wrap layout with half-width support
        final fullWidth = constraints.maxWidth - 32; // 16px padding each side
        final halfWidth = (fullWidth - spacing) / 2;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final (def, config) in visibleCards)
                SizedBox(
                  width: config.size == DashboardCardSize.half &&
                          def.supportedSizes.contains(DashboardCardSize.half)
                      ? halfWidth
                      : fullWidth,
                  child: KeyedSubtree(
                    key: ValueKey(def.id),
                    child: def.builder(),
                  ),
                ),
              SizedBox(width: fullWidth, height: 80), // FAB clearance
            ],
          ),
        );
      },
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
