import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../analytics/analytics_providers.dart';

class SavingsRateCard extends ConsumerWidget {
  const SavingsRateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final rateAsync = ref.watch(savingsRateProvider);
    final cashFlowAsync = ref.watch(monthlyCashFlowProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.analytics),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Savings Rate',
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
              const SizedBox(height: 12),
              rateAsync.when(
                data: (rate) {
                  final pct = (rate * 100).round();
                  final isPositive = rate >= 0;
                  final prevRate = cashFlowAsync.whenOrNull(
                    data: (cashFlow) => cashFlow.length >= 2
                        ? cashFlow[cashFlow.length - 2].savingsRate
                        : null,
                  );
                  final trendUp =
                      prevRate != null ? rate > prevRate : null;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$pct%',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isPositive
                              ? finance.income
                              : finance.expense,
                        ),
                      ),
                      if (trendUp != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          trendUp
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: trendUp
                              ? finance.income
                              : finance.expense,
                          size: 20,
                        ),
                      ],
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'of income saved',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () =>
                    Text('...', style: theme.textTheme.headlineLarge),
                error: (_, _) =>
                    Text('--', style: theme.textTheme.headlineLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
