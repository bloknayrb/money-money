import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../data/local/database/app_database.dart';
import '../../shared/empty_states/empty_state_widget.dart';
import '../../shared/loading/shimmer_loading.dart';
import 'goals_providers.dart';

/// Goals list screen showing active and completed goals with progress.
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(allGoalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add goal',
            onPressed: () => _navigateToAddGoal(context),
          ),
        ],
      ),
      body: goalsAsync.when(
        loading: () => const ShimmerTransactionList(itemCount: 5),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (goals) {
          if (goals.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.flag_outlined,
              title: 'No goals yet',
              description:
                  'Set financial goals to track your savings, debt payoff, and net worth milestones.',
              actionLabel: 'Add Goal',
              onAction: () => _navigateToAddGoal(context),
            );
          }
          return _GoalsListView(goals: goals);
        },
      ),
      floatingActionButton: goalsAsync.maybeWhen(
        data: (goals) => goals.isEmpty
            ? null
            : FloatingActionButton(
                onPressed: () => _navigateToAddGoal(context),
                child: const Icon(Icons.add),
              ),
        orElse: () => null,
      ),
    );
  }

  void _navigateToAddGoal(BuildContext context) {
    context.push(AppRoutes.addGoal);
  }
}

class _GoalsListView extends StatelessWidget {
  final List<Goal> goals;

  const _GoalsListView({required this.goals});

  @override
  Widget build(BuildContext context) {
    final active = goals.where((g) => !g.isCompleted).toList();
    final completed = goals.where((g) => g.isCompleted).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        _GoalsSummaryHeader(
          totalCount: goals.length,
          completedCount: completed.length,
        ),
        if (active.isNotEmpty) ...[
          _SectionHeader(title: 'Active Goals', count: active.length),
          for (final goal in active) _GoalCard(goal: goal),
        ],
        if (completed.isNotEmpty) ...[
          _SectionHeader(title: 'Completed', count: completed.length),
          for (final goal in completed) _GoalCard(goal: goal),
        ],
      ],
    );
  }
}

class _GoalsSummaryHeader extends StatelessWidget {
  final int totalCount;
  final int completedCount;

  const _GoalsSummaryHeader({
    required this.totalCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Goals',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '$totalCount',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Completed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '$completedCount',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        '$title ($count)',
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Goal goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final goalColor = Color(goal.color);
    final progress = goal.targetAmountCents > 0
        ? (goal.currentAmountCents / goal.targetAmountCents).clamp(0.0, 1.0)
        : 0.0;
    final progressPercent = (progress * 100).toInt();

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: InkWell(
        onTap: () {
          context.push(AppRoutes.editGoal, extra: goal);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: goal.isCompleted
                        ? colorScheme.primaryContainer
                        : goalColor.withValues(alpha: 0.15),
                    child: goal.isCompleted
                        ? Icon(Icons.check, color: colorScheme.primary)
                        : Icon(
                            _iconFromName(goal.icon),
                            color: goalColor,
                            size: 20,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: goal.isCompleted
                                ? colorScheme.onSurfaceVariant
                                : null,
                          ),
                        ),
                        Text(
                          _goalTypeLabel(goal.goalType),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$progressPercent%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: goal.isCompleted
                          ? colorScheme.primary
                          : goalColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: goal.isCompleted ? colorScheme.primary : goalColor,
                ),
              ),
              const SizedBox(height: 8),
              // Amount labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    goal.currentAmountCents.toCurrency(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    goal.targetAmountCents.toCurrency(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              // Target date
              if (goal.targetDate != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Target: ${goal.targetDate!.toDateTime().toMediumDate()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _goalTypeLabel(String type) {
    switch (type) {
      case 'savings':
        return 'Savings Goal';
      case 'debt_payoff':
        return 'Debt Payoff';
      case 'net_worth':
        return 'Net Worth Milestone';
      case 'custom':
        return 'Custom Goal';
      default:
        return type;
    }
  }

  static IconData _iconFromName(String name) {
    return goalIconOptions.firstWhere(
      (e) => e.$1 == name,
      orElse: () => goalIconOptions.first,
    ).$2;
  }
}

/// Icon options for goals. (name, IconData, label)
const goalIconOptions = [
  ('savings', Icons.savings, 'Savings'),
  ('flag', Icons.flag, 'Flag'),
  ('home', Icons.home, 'Home'),
  ('school', Icons.school, 'Education'),
  ('flight', Icons.flight, 'Travel'),
  ('directions_car', Icons.directions_car, 'Car'),
  ('medical_services', Icons.medical_services, 'Medical'),
  ('trending_up', Icons.trending_up, 'Growth'),
  ('account_balance', Icons.account_balance, 'Finance'),
  ('card_giftcard', Icons.card_giftcard, 'Gift'),
  ('fitness_center', Icons.fitness_center, 'Fitness'),
  ('star', Icons.star, 'Star'),
];
