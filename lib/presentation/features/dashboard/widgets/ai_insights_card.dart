import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/local/database/app_database.dart';

class AiInsightsCard extends ConsumerStatefulWidget {
  const AiInsightsCard({super.key});

  @override
  ConsumerState<AiInsightsCard> createState() => _AiInsightsCardState();
}

class _AiInsightsCardState extends ConsumerState<AiInsightsCard> {
  bool _generating = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insightsAsync = ref.watch(activeInsightsProvider);
    final llmAsync = ref.watch(llmClientProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.auto_awesome, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'AI Insights',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (llmAsync.valueOrNull != null)
                  IconButton(
                    icon: _generating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh, size: 20),
                    onPressed: _generating ? null : _generateInsights,
                    tooltip: 'Generate insights',
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Content
            _buildContent(theme, insightsAsync, llmAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    AsyncValue<List<Insight>> insightsAsync,
    AsyncValue<dynamic> llmAsync,
  ) {
    // No LLM configured
    if (llmAsync.valueOrNull == null) {
      return _buildConfigurePrompt(theme);
    }

    return insightsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, st) => const Text('Failed to load insights'),
      data: (insights) {
        if (insights.isEmpty) {
          return _buildEmptyState(theme);
        }
        return _buildInsightsList(theme, insights);
      },
    );
  }

  Widget _buildConfigurePrompt(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              'Configure an LLM provider to get AI-powered insights',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push(AppRoutes.llmConfig),
              child: const Text('Set Up LLM Provider'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              'Tap refresh to generate financial insights',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: _generating ? null : _generateInsights,
              child: _generating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Generate Insights'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsList(ThemeData theme, List<Insight> insights) {
    return Column(
      children: insights.take(5).map((insight) {
        return _InsightTile(
          insight: insight,
          onDismiss: () => ref.read(insightRepositoryProvider).dismiss(insight.id),
        );
      }).toList(),
    );
  }

  Future<void> _generateInsights() async {
    final llmClient = ref.read(llmClientProvider).valueOrNull;
    if (llmClient == null) return;

    setState(() => _generating = true);

    try {
      final service = ref.read(insightGenerationServiceProvider);
      final count = await service.generate(llmClient);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generated $count insights')),
        );
      }
    } on LLMError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.userMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate insights: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }
}

class _InsightTile extends StatelessWidget {
  final Insight insight;
  final VoidCallback onDismiss;

  const _InsightTile({
    required this.insight,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = switch (insight.severity) {
      'alert' => theme.colorScheme.error,
      'warning' => Colors.orange,
      _ => theme.colorScheme.primary,
    };
    final severityIcon = switch (insight.severity) {
      'alert' => Icons.error,
      'warning' => Icons.warning_amber,
      _ => Icons.info_outline,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(severityIcon, size: 18, color: severityColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: insight.isRead ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  insight.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: onDismiss,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            tooltip: 'Dismiss',
          ),
        ],
      ),
    );
  }
}
