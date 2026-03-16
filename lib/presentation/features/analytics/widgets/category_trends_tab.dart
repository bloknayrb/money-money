import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../analytics_providers.dart';

class CategoryTrendsTab extends ConsumerWidget {
  const CategoryTrendsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trendsAsync = ref.watch(categoryTrendsProvider);

    return trendsAsync.when(
      data: (trends) {
        if (trends.isEmpty) {
          return const Center(child: Text('No spending data yet'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: trends.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final trend = trends[index];
            final current = trend.monthlyAmounts.isNotEmpty
                ? trend.monthlyAmounts.last.amountCents
                : 0;
            final prev = trend.monthlyAmounts.length >= 2
                ? trend.monthlyAmounts[trend.monthlyAmounts.length - 2]
                    .amountCents
                : 0;
            final change =
                prev > 0 ? ((current - prev) / prev * 100).round() : 0;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(trend.color),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            trend.categoryName,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            current.toCurrency(),
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (change != 0) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${change > 0 ? '+' : ''}$change%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color:
                                    change > 0 ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _MiniBarRow(
                    monthlyAmounts: trend.monthlyAmounts,
                    color: Color(trend.color),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _MiniBarRow extends StatelessWidget {
  final List<({DateTime month, int amountCents})> monthlyAmounts;
  final Color color;

  const _MiniBarRow({required this.monthlyAmounts, required this.color});

  @override
  Widget build(BuildContext context) {
    if (monthlyAmounts.isEmpty) return const SizedBox.shrink();
    final maxAmount = monthlyAmounts.fold<int>(
        0, (max, m) => m.amountCents > max ? m.amountCents : max);
    if (maxAmount == 0) return const SizedBox(height: 24);

    return SizedBox(
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: monthlyAmounts.map((m) {
          final fraction = m.amountCents / maxAmount;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FractionallySizedBox(
                heightFactor: fraction.clamp(0.05, 1.0),
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.3 + fraction * 0.7),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(2)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
