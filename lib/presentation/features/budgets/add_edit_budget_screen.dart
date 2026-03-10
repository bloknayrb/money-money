import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../data/local/database/app_database.dart';
import '../../shared/utils/snackbar_helpers.dart';
import '../../shared/widgets/delete_confirmation_dialog.dart';

/// Add or edit a budget.
class AddEditBudgetScreen extends ConsumerStatefulWidget {
  final Budget? budget;

  const AddEditBudgetScreen({super.key, this.budget});

  @override
  ConsumerState<AddEditBudgetScreen> createState() =>
      _AddEditBudgetScreenState();
}

class _AddEditBudgetScreenState extends ConsumerState<AddEditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _thresholdController = TextEditingController();

  String? _selectedCategoryId;
  String _periodType = 'monthly';
  bool _rollover = false;
  bool _isSaving = false;

  bool get _isEditing => widget.budget != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final b = widget.budget!;
      _amountController.text = b.amountCents.toCurrencyValue();
      _thresholdController.text = (b.alertThreshold * 100).round().toString();
      _selectedCategoryId = b.categoryId;
      _periodType = b.periodType;
      _rollover = b.rollover;
    } else {
      _thresholdController.text = '90';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      showErrorSnackbar(context, 'Please select a category');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(budgetRepositoryProvider);
      final amountCents = _amountController.text.toCents()!;
      final threshold = (int.parse(_thresholdController.text)) / 100.0;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (_isEditing) {
        await repo.updateBudget(BudgetsCompanion(
          id: Value(widget.budget!.id),
          categoryId: Value(_selectedCategoryId!),
          amountCents: Value(amountCents),
          periodType: Value(_periodType),
          rollover: Value(_rollover),
          alertThreshold: Value(threshold),
          updatedAt: Value(now),
        ));
      } else {
        await repo.insertBudget(BudgetsCompanion.insert(
          id: const Uuid().v4(),
          categoryId: _selectedCategoryId!,
          amountCents: amountCents,
          periodType: _periodType,
          startDate: now,
          rollover: Value(_rollover),
          alertThreshold: Value(threshold),
          createdAt: now,
          updatedAt: now,
        ));
      }

      if (mounted) {
        showSuccessSnackbar(
          context,
          _isEditing ? 'Budget updated' : 'Budget created',
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, 'Error: $e');
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDeleteConfirmation(
      context,
      itemName: 'budget',
    );

    if (!confirmed) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(budgetRepositoryProvider)
          .deleteBudget(widget.budget!.id);
      if (mounted) {
        showSuccessSnackbar(context, 'Budget deleted');
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, 'Error: $e');
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(expenseCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Budget' : 'Add Budget'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: _isSaving ? null : _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Category picker
            categoriesAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error loading categories: $e'),
              data: (categories) {
                return DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category *',
                    filled: true,
                  ),
                  items: categories.map((c) {
                    return DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name),
                    );
                  }).toList(),
                  onChanged: _isSaving
                      ? null
                      : (v) {
                          if (v != null) {
                            setState(() => _selectedCategoryId = v);
                          }
                        },
                  validator: (v) => v == null ? 'Category is required' : null,
                );
              },
            ),
            const SizedBox(height: 16),

            // Budget amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Budget Amount *',
                hintText: '0.00',
                prefixText: '\$ ',
                filled: true,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              enabled: !_isSaving,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Amount is required';
                if (v.toCents() == null || v.toCents()! <= 0) {
                  return 'Enter a valid positive amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Period type
            DropdownButtonFormField<String>(
              initialValue: _periodType,
              decoration: const InputDecoration(
                labelText: 'Period *',
                filled: true,
              ),
              items: const [
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                DropdownMenuItem(value: 'annual', child: Text('Annual')),
              ],
              onChanged: _isSaving
                  ? null
                  : (v) {
                      if (v != null) setState(() => _periodType = v);
                    },
            ),
            const SizedBox(height: 16),

            // Rollover toggle
            SwitchListTile(
              title: const Text('Rollover unused budget'),
              subtitle: const Text(
                'Carry unspent amounts into the next period',
              ),
              value: _rollover,
              onChanged:
                  _isSaving ? null : (v) => setState(() => _rollover = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),

            // Alert threshold
            TextFormField(
              controller: _thresholdController,
              decoration: const InputDecoration(
                labelText: 'Alert Threshold (%)',
                hintText: '90',
                suffixText: '%',
                filled: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              enabled: !_isSaving,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                final val = int.tryParse(v);
                if (val == null || val < 1 || val > 100) {
                  return 'Enter a value between 1 and 100';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'You will be alerted when spending reaches this percentage of your budget.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Save Changes' : 'Create Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
