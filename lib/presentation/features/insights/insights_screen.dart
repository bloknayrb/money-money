import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../data/local/database/models.dart';
import '../../shared/empty_states/empty_state_widget.dart';
import '../../shared/loading/shimmer_loading.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  bool _markedRead = false;

  @override
  Widget build(BuildContext context) {
    final insightsAsync = ref.watch(activeInsightsProvider);

    // Mark all as read once when data first loads
    if (!_markedRead) {
      insightsAsync.whenData((_) {
        _markedRead = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(insightRepositoryProvider).markAllRead();
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: insightsAsync.when(
        loading: () => const ShimmerTransactionList(),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (insights) {
          if (insights.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.notifications_none,
              title: 'No insights yet',
              description:
                  'Insights appear after syncing your accounts. '
                  'Budget alerts, bill reminders, and spending anomalies '
                  'will show up here.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: insights.length,
            itemBuilder: (context, index) {
              final insight = insights[index];
              return _InsightCard(
                insight: insight,
                onDismiss: () {
                  ref.read(insightRepositoryProvider).dismiss(insight.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final Insight insight;
  final VoidCallback onDismiss;

  const _InsightCard({
    required this.insight,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final (icon, color) = _severityStyle(insight.severity, colorScheme);

    return Dismissible(
      key: ValueKey(insight.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: colorScheme.errorContainer,
        child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
      ),
      onDismissed: (_) => onDismiss(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            insight.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: insight.isRead
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          insight.createdAt.toDateTime().toRelative(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insight.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _InsightTypeChip(type: insight.insightType),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (IconData, Color) _severityStyle(
      String severity, ColorScheme colorScheme) {
    return switch (severity) {
      'alert' => (Icons.error_outline, colorScheme.error),
      'warning' => (Icons.warning_amber_rounded, Colors.amber.shade700),
      _ => (Icons.info_outline, colorScheme.primary),
    };
  }
}

class _InsightTypeChip extends StatelessWidget {
  final String type;

  const _InsightTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      'budget' => 'Budget',
      'spending' => 'Spending',
      'saving' => 'Saving',
      'goal' => 'Goal',
      _ => 'General',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
