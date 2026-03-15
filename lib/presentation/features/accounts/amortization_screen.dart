import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../domain/usecases/amortization/loan_params.dart';

/// Provider to load loan params for a given account ID.
final loanParamsProvider =
    FutureProvider.autoDispose.family<LoanParams?, String>((ref, accountId) {
  return ref.watch(loanParamsRepositoryProvider).getLoanParams(accountId);
});

/// Screen showing amortization schedule for a loan account.
class AmortizationScreen extends ConsumerWidget {
  final String accountId;
  final String accountName;

  const AmortizationScreen({
    super.key,
    required this.accountId,
    required this.accountName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paramsAsync = ref.watch(loanParamsProvider(accountId));

    return Scaffold(
      appBar: AppBar(
        title: Text('$accountName Amortization'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit loan details',
            onPressed: () => _showEditDialog(context, ref,
                paramsAsync.valueOrNull),
          ),
        ],
      ),
      body: paramsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (params) {
          if (params == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calculate_outlined, size: 64),
                  const SizedBox(height: 16),
                  const Text('No loan details configured'),
                  const SizedBox(height: 8),
                  const Text('Add interest rate, balance, and term to see\n'
                      'the amortization schedule.'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _showEditDialog(context, ref, null),
                    icon: const Icon(Icons.add),
                    label: const Text('Set Up Loan Details'),
                  ),
                ],
              ),
            );
          }

          return _AmortizationBody(params: params);
        },
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, LoanParams? existing) {
    showDialog(
      context: context,
      builder: (_) => _LoanParamsDialog(
        accountId: accountId,
        existing: existing,
      ),
    );
  }
}

class _AmortizationBody extends StatelessWidget {
  final LoanParams params;

  const _AmortizationBody({required this.params});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final schedule = params.schedule;
    final totalInterest = schedule.fold<int>(
        0, (sum, e) => sum + e.interestCents);
    final totalPaid = schedule.fold<int>(
        0, (sum, e) => sum + e.paymentCents);

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // Summary card
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loan Summary',
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                _SummaryRow(
                  label: 'Original Balance',
                  value: params.originalBalanceCents.toCurrency(),
                ),
                _SummaryRow(
                  label: 'Interest Rate',
                  value: '${params.annualRatePercent.toStringAsFixed(2)}%',
                ),
                _SummaryRow(
                  label: 'Loan Term',
                  value: '${params.loanTermMonths} months '
                      '(${(params.loanTermMonths / 12).toStringAsFixed(1)} years)',
                ),
                _SummaryRow(
                  label: 'Monthly Payment',
                  value: params.monthlyPaymentCents.toCurrency(),
                ),
                const Divider(),
                _SummaryRow(
                  label: 'Total Interest',
                  value: totalInterest.toCurrency(),
                  valueColor: theme.colorScheme.error,
                ),
                _SummaryRow(
                  label: 'Total Paid',
                  value: totalPaid.toCurrency(),
                ),
              ],
            ),
          ),
        ),

        // Schedule header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            'Payment Schedule',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Column headers
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                  width: 36,
                  child: Text('#',
                      style: theme.textTheme.labelSmall)),
              Expanded(
                  child: Text('Payment',
                      style: theme.textTheme.labelSmall)),
              Expanded(
                  child: Text('Principal',
                      style: theme.textTheme.labelSmall)),
              Expanded(
                  child: Text('Interest',
                      style: theme.textTheme.labelSmall)),
              Expanded(
                  child: Text('Balance',
                      style: theme.textTheme.labelSmall,
                      textAlign: TextAlign.end)),
            ],
          ),
        ),
        const Divider(height: 1),

        // Schedule rows
        ...schedule.map((entry) => _ScheduleRow(entry: entry)),
      ],
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
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          )),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          )),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final AmortizationEntry entry;

  const _ScheduleRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 36, child: Text('${entry.month}', style: style)),
          Expanded(child: Text(entry.paymentCents.toCurrency(), style: style)),
          Expanded(child: Text(entry.principalCents.toCurrency(), style: style)),
          Expanded(
              child: Text(
            entry.interestCents.toCurrency(),
            style: style?.copyWith(color: theme.colorScheme.error),
          )),
          Expanded(
              child: Text(
            entry.remainingBalanceCents.toCurrency(),
            style: style,
            textAlign: TextAlign.end,
          )),
        ],
      ),
    );
  }
}

/// Dialog for editing loan parameters.
class _LoanParamsDialog extends ConsumerStatefulWidget {
  final String accountId;
  final LoanParams? existing;

  const _LoanParamsDialog({
    required this.accountId,
    this.existing,
  });

  @override
  ConsumerState<_LoanParamsDialog> createState() => _LoanParamsDialogState();
}

class _LoanParamsDialogState extends ConsumerState<_LoanParamsDialog> {
  late final TextEditingController _rateController;
  late final TextEditingController _balanceController;
  late final TextEditingController _termController;
  late DateTime _originDate;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _rateController = TextEditingController(
      text: existing != null
          ? existing.annualRatePercent.toStringAsFixed(2)
          : '',
    );
    _balanceController = TextEditingController(
      text: existing != null
          ? existing.originalBalanceCents.toCurrencyValue()
          : '',
    );
    _termController = TextEditingController(
      text: existing != null ? '${existing.loanTermMonths ~/ 12}' : '',
    );
    _originDate = existing != null
        ? DateTime.fromMillisecondsSinceEpoch(existing.originationDate)
        : DateTime.now();
  }

  @override
  void dispose() {
    _rateController.dispose();
    _balanceController.dispose();
    _termController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Loan Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _rateController,
              decoration: const InputDecoration(
                labelText: 'Annual Interest Rate (%)',
                hintText: 'e.g. 6.50',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Original Loan Amount',
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _termController,
              decoration: const InputDecoration(
                labelText: 'Loan Term (years)',
                hintText: 'e.g. 30',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Origination Date'),
              subtitle: Text(
                '${_originDate.month}/${_originDate.day}/${_originDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _originDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _originDate = picked);
  }

  Future<void> _save() async {
    final rate = double.tryParse(_rateController.text.trim());
    final balance = double.tryParse(_balanceController.text.trim());
    final termYears = int.tryParse(_termController.text.trim());

    if (rate == null || balance == null || termYears == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    final params = LoanParams(
      interestRateBps: (rate * 100).round(),
      originalBalanceCents: (balance * 100).round(),
      loanTermMonths: termYears * 12,
      originationDate: _originDate.millisecondsSinceEpoch,
    );

    await ref
        .read(loanParamsRepositoryProvider)
        .saveLoanParams(widget.accountId, params);
    ref.invalidate(loanParamsProvider(widget.accountId));

    if (mounted) Navigator.pop(context);
  }
}
