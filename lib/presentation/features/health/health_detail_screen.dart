import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'health_providers.dart';
import 'widgets/pillar_card.dart';
import 'widgets/priority_ladder.dart';

class HealthDetailScreen extends ConsumerWidget {
  const HealthDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(financialHealthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Health')),
      body: healthAsync.when(
        data: (health) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ScoreHeader(score: health.overallScore),
            const SizedBox(height: 24),
            Text(
              'Health Pillars',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...health.pillars.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: PillarCard(pillar: p),
                )),
            const SizedBox(height: 16),
            Text(
              'Priority Ladder',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            PriorityLadder(steps: health.allSteps),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ScoreHeader extends StatelessWidget {
  final int score;

  const _ScoreHeader({required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = score >= 70
        ? Colors.green
        : score >= 40
            ? Colors.orange
            : Colors.red;

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: color.withValues(alpha: 0.15),
                  color: color,
                ),
                Text(
                  '$score',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            score >= 80
                ? 'Excellent'
                : score >= 60
                    ? 'Good'
                    : score >= 40
                        ? 'Fair'
                        : 'Needs Work',
            style: theme.textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
