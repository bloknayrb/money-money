import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/usecases/debt/debt_models.dart';
import 'debt_providers.dart';

class DebtPayoffScreen extends ConsumerWidget {
  const DebtPayoffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final finance = theme.finance;
    final planAsync = ref.watch(debtPayoffPlanProvider);
    final comparisonAsync = ref.watch(debtComparisonProvider);
    final strategy = ref.watch(selectedStrategyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Debt Payoff Planner')),
      body: planAsync.when(
        data: (plan) {
          if (plan == null) {
            return const Center(
              child: Text('No debt accounts found'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Strategy toggle
              SegmentedButton<DebtStrategy>(
                segments: const [
                  ButtonSegment(
                    value: DebtStrategy.avalanche,
                    label: Text('Avalanche'),
                    icon: Icon(Icons.trending_down),
                  ),
                  ButtonSegment(
                    value: DebtStrategy.snowball,
                    label: Text('Snowball'),
                    icon: Icon(Icons.ac_unit),
                  ),
                ],
                selected: {strategy},
                onSelectionChanged: (s) =>
                    ref.read(selectedStrategyProvider.notifier).state = s.first,
              ),
              const SizedBox(height: 16),

              // Extra payment input
              _ExtraPaymentField(),
              const SizedBox(height: 16),

              // Comparison card
              comparisonAsync.when(
                data: (comparison) {
                  if (comparison == null) return const SizedBox.shrink();
                  final saved = comparison.snowball.totalInterestCents -
                      comparison.avalanche.totalInterestCents;
                  if (saved.abs() < 100) return const SizedBox.shrink();

                  return Card(
                    color: theme.colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        saved > 0
                            ? 'Avalanche saves ${saved.toCurrency()} in interest'
                            : 'Snowball saves ${saved.abs().toCurrency()} in interest',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),

              // Summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Plan Summary', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 12),
                      _SummaryRow(
                        label: 'Debt-free date',
                        value:
                            '${plan.debtFreeDate.month}/${plan.debtFreeDate.year}',
                      ),
                      _SummaryRow(
                        label: 'Total interest',
                        value: plan.totalInterestCents.toCurrency(),
                        valueColor: finance.expense,
                      ),
                      _SummaryRow(
                        label: 'Months to payoff',
                        value: '${plan.schedule.length}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Per-debt cards
              Text('Payoff Order', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              ...plan.perDebt.map((entry) => Card(
                    child: ListTile(
                      title: Text(entry.name),
                      subtitle: Text(
                        'Payoff: ${entry.payoffDate.month}/${entry.payoffDate.year} '
                        '| Interest: ${entry.totalInterestCents.toCurrency()}',
                      ),
                      trailing: Text(
                        entry.originalBalanceCents.toCurrency(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: finance.expense,
                        ),
                      ),
                    ),
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ExtraPaymentField extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ExtraPaymentField> createState() => _ExtraPaymentFieldState();
}

class _ExtraPaymentFieldState extends ConsumerState<_ExtraPaymentField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final current = ref.read(extraPaymentProvider);
    _controller = TextEditingController(
      text: current > 0 ? (current / 100).toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        labelText: 'Extra monthly payment',
        prefixText: '\$ ',
        border: OutlineInputBorder(),
        helperText: 'Amount above minimums to throw at debt',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final parsed = double.tryParse(value);
        ref.read(extraPaymentProvider.notifier).state =
            parsed != null ? (parsed * 100).round() : 0;
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
