import 'package:flutter/material.dart';

import '../../../../domain/usecases/analytics/health_models.dart';

class PriorityLadder extends StatelessWidget {
  final List<PriorityLadderStep> steps;

  const PriorityLadder({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: steps.map((step) {
        final color = step.isComplete
            ? Colors.green
            : step.isCurrent
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5);

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    step.isComplete
                        ? Icons.check_circle
                        : step.isCurrent
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                    color: color,
                    size: 24,
                  ),
                  if (step.order < steps.length)
                    Container(
                      width: 2,
                      height: 32,
                      color: color.withValues(alpha: 0.3),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight:
                            step.isCurrent ? FontWeight.w600 : FontWeight.w400,
                        color: step.isComplete || step.isCurrent
                            ? null
                            : theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                      ),
                    ),
                    if (step.isCurrent && step.progressPercent != null) ...[
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: step.progressPercent!,
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.15),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      step.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
