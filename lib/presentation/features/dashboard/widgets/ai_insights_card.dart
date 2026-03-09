import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/remote/llm/llm_client.dart';

/// Dashboard card for AI-generated spending insights.
///
/// Shows a placeholder when no LLM is configured.
/// When configured, shows an "Analyze Spending" button that runs a
/// one-shot [LlmClient.complete] call and displays the result.
class AiInsightsCard extends ConsumerStatefulWidget {
  const AiInsightsCard({super.key});

  @override
  ConsumerState<AiInsightsCard> createState() => _AiInsightsCardState();
}

class _AiInsightsCardState extends ConsumerState<AiInsightsCard> {
  String? _insight;
  bool _isLoading = false;

  Future<void> _analyzeSpending() async {
    final client = ref.read(activeLlmClientProvider).valueOrNull;
    if (client == null) return;

    setState(() {
      _isLoading = true;
      _insight = null;
    });

    try {
      final financialContext =
          await ref.read(contextBuilderProvider).buildContext();
      final result = await client.complete(
        'You are a personal finance analyst. Be concise — 2-3 sentences max.',
        [
          const ChatMessage(role: 'context', content: ''),
          ChatMessage(role: 'context', content: financialContext),
          const ChatMessage(
            role: 'user',
            content:
                'Give me one specific, actionable spending insight based on the data above.',
          ),
        ],
      );
      if (mounted) setState(() => _insight = result);
    } catch (e) {
      if (mounted) {
        setState(
            () => _insight = 'Could not generate insight. Try again later.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientAsync = ref.watch(activeLlmClientProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'AI Insights',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            clientAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => _placeholder(context, theme),
              data: (client) {
                if (client == null) return _placeholder(context, theme);

                if (_isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (_insight != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_insight!, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _analyzeSpending,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Refresh'),
                      ),
                    ],
                  );
                }

                return Center(
                  child: FilledButton.icon(
                    onPressed: _analyzeSpending,
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: const Text('Analyze Spending'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext ctx, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configure an AI provider to get personalized insights.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => ctx.push(AppRoutes.llmSettings),
          child: const Text('Set Up AI'),
        ),
      ],
    );
  }
}
