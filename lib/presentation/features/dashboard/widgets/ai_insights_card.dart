import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../data/remote/llm/llm_client.dart';
import '../../../../domain/usecases/ai/chat_service.dart';

class AiInsightsCard extends ConsumerStatefulWidget {
  const AiInsightsCard({super.key});

  @override
  ConsumerState<AiInsightsCard> createState() => _AiInsightsCardState();
}

class _AiInsightsCardState extends ConsumerState<AiInsightsCard> {
  String? _insight;
  bool _loading = false;
  String? _error;

  Future<void> _analyzeSpending() async {
    final clientAsync = ref.read(activeLlmClientProvider);
    final client = clientAsync.valueOrNull;
    if (client == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final contextBuilder = ref.read(contextBuilderProvider);
      final context = await contextBuilder.buildContext();

      final result = await client.complete(
        'You are a personal finance assistant. Be concise — 2-3 sentences max.',
        [
          ChatMessage(role: 'context', content: context),
          const ChatMessage(
            role: 'user',
            content:
                'Give me one key insight about my spending this month. Be specific with numbers.',
          ),
        ],
      );

      if (mounted) setState(() => _insight = result);
    } on RateLimitException {
      if (mounted) setState(() => _error = 'Daily limit reached.');
    } catch (e) {
      if (mounted) setState(() => _error = 'Analysis failed.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clientAsync = ref.watch(activeLlmClientProvider);
    final hasClient = clientAsync.valueOrNull != null;

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
            if (!hasClient)
              Center(
                child: Text(
                  'Add financial data to get personalized insights',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Text(_error!,
                  style: TextStyle(color: theme.colorScheme.error))
            else if (_insight != null)
              Text(_insight!, style: theme.textTheme.bodyMedium)
            else
              Center(
                child: FilledButton.icon(
                  onPressed: _analyzeSpending,
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: const Text('Analyze Spending'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
