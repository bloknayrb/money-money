import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/database/app_database.dart';
import '../../../domain/usecases/recurring/recurring_detection_service.dart';
import '../../shared/empty_states/empty_state_widget.dart';
import '../../shared/loading/shimmer_loading.dart';
import 'recurring_providers.dart';

/// Frequency display labels.
const _frequencyLabels = {
  'weekly': 'Weekly',
  'biweekly': 'Every Two Weeks',
  'monthly': 'Monthly',
  'quarterly': 'Quarterly',
  'annual': 'Annual',
};

/// Screen showing recurring transactions with Active and Detected tabs.
class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recurring'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Detected'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ActiveTab(),
            _DetectedTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push(AppRoutes.addRecurring);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

/// Tab showing confirmed active recurring transactions.
class _ActiveTab extends ConsumerWidget {
  const _ActiveTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurringAsync = ref.watch(recurringTransactionsProvider);

    return recurringAsync.when(
      loading: () => const ShimmerTransactionList(),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (items) {
        if (items.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.repeat,
            title: 'No recurring transactions',
            description:
                'Add recurring transactions manually or check the Detected tab for suggestions.',
            actionLabel: 'Add Recurring',
            onAction: () {
              context.push(AppRoutes.addRecurring);
            },
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: items.length,
          itemBuilder: (context, index) =>
              _RecurringTile(recurring: items[index]),
        );
      },
    );
  }
}

/// Tab showing detected recurring patterns from transaction analysis.
class _DetectedTab extends ConsumerWidget {
  const _DetectedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detectedAsync = ref.watch(detectedRecurringProvider);

    return detectedAsync.when(
      loading: () => const ShimmerTransactionList(),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (patterns) {
        if (patterns.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.search,
            title: 'No patterns detected',
            description:
                'Add more transactions and patterns will be detected automatically.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: patterns.length,
          itemBuilder: (context, index) =>
              _DetectedTile(detected: patterns[index]),
        );
      },
    );
  }
}

/// List tile for an active recurring transaction.
class _RecurringTile extends StatelessWidget {
  final RecurringTransaction recurring;

  const _RecurringTile({required this.recurring});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final isIncome = recurring.amountCents > 0;
    final nextDate = recurring.nextExpectedDate.toDateTime();

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: recurring.isSubscription
            ? theme.colorScheme.primaryContainer
            : isIncome
                ? finance.income.withValues(alpha: 0.15)
                : theme.colorScheme.errorContainer,
        child: Icon(
          recurring.isSubscription
              ? Icons.subscriptions
              : Icons.repeat,
          color: recurring.isSubscription
              ? theme.colorScheme.primary
              : isIncome
                  ? finance.income
                  : theme.colorScheme.error,
          size: 20,
        ),
      ),
      title: Text(
        recurring.payee,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${_frequencyLabels[recurring.frequency] ?? recurring.frequency} '
        '- Next: ${nextDate.toRelative()}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        recurring.amountCents.toCurrency(),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: isIncome ? finance.income : theme.colorScheme.onSurface,
        ),
      ),
      onTap: () {
        context.push(AppRoutes.editRecurring, extra: recurring);
      },
    );
  }
}

/// List tile for a detected recurring pattern with an "Add" button.
class _DetectedTile extends ConsumerWidget {
  final DetectedRecurring detected;

  const _DetectedTile({required this.detected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final isIncome = detected.amountCents > 0;
    final confidencePercent = (detected.confidence * 100).round();

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isIncome
            ? finance.income.withValues(alpha: 0.15)
            : theme.colorScheme.errorContainer,
        child: Icon(
          Icons.auto_awesome,
          color: isIncome ? finance.income : theme.colorScheme.error,
          size: 20,
        ),
      ),
      title: Text(
        detected.payee,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${_frequencyLabels[detected.frequency] ?? detected.frequency} '
        '- ${detected.occurrenceCount} occurrences '
        '($confidencePercent% match)',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            detected.amountCents.toCurrency(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isIncome ? finance.income : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add as recurring',
            onPressed: () => _confirmDetected(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDetected(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final repo = ref.read(recurringTransactionRepositoryProvider);

    await repo.insertRecurring(RecurringTransactionsCompanion.insert(
      id: const Uuid().v4(),
      payee: detected.payee,
      amountCents: detected.amountCents,
      categoryId: detected.categoryId == null
          ? const Value(null)
          : Value(detected.categoryId),
      accountId: detected.accountId,
      frequency: detected.frequency,
      nextExpectedDate: detected.nextExpectedDate,
      lastOccurrenceDate: detected.lastOccurrenceDate,
      createdAt: now,
      updatedAt: now,
    ));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added "${detected.payee}" as recurring')),
      );
      // Refresh the detected list.
      ref.invalidate(detectedRecurringProvider);
    }
  }
}
