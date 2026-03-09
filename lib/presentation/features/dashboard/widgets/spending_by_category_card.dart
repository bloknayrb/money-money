import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../dashboard_providers.dart';

class SpendingByCategoryCard extends ConsumerWidget {
  const SpendingByCategoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(spendingByCategoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending by Category',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            dataAsync.when(
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const SizedBox(
                height: 200,
                child: Center(child: Text('Error loading data')),
              ),
              data: (data) {
                if (data.isEmpty) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No categorized spending this month',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }

                final total =
                    data.fold<int>(0, (sum, c) => sum + c.amountCents);

                return Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 36,
                          sections: data.map((c) {
                            final pct = total > 0
                                ? (c.amountCents / total * 100)
                                : 0.0;
                            return PieChartSectionData(
                              value: c.amountCents.toDouble(),
                              color: Color(c.color),
                              radius: 40,
                              title: pct >= 10
                                  ? '${pct.round()}%'
                                  : '',
                              titleStyle: theme.textTheme.labelSmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Legend
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: data.take(6).map((c) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color(c.color),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${c.categoryName} ${c.amountCents.toCurrency()}',
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
