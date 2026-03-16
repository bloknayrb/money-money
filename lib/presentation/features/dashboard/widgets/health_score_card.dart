import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../health/health_providers.dart';

class HealthScoreCard extends ConsumerWidget {
  const HealthScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final healthAsync = ref.watch(financialHealthProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.health),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: healthAsync.when(
            data: (health) {
              final color = health.overallScore >= 70
                  ? Colors.green
                  : health.overallScore >= 40
                      ? Colors.orange
                      : Colors.red;

              return Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: health.overallScore / 100,
                          strokeWidth: 6,
                          backgroundColor: color.withValues(alpha: 0.15),
                          color: color,
                        ),
                        Text(
                          '${health.overallScore}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Financial Health',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                        if (health.currentStep != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            health.currentStep!.title,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(
              height: 64,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => const Text('Unable to calculate health score'),
          ),
        ),
      ),
    );
  }
}
