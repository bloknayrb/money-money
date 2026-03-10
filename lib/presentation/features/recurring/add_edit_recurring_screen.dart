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
import '../../shared/widgets/category_picker_sheet.dart';
import '../../shared/widgets/delete_confirmation_dialog.dart';
import '../accounts/accounts_providers.dart';
import 'widgets/recurring_account_category_section.dart';

/// Frequency options for the dropdown.
const _frequencies = [
  ('weekly', 'Weekly'),
  ('biweekly', 'Every Two Weeks'),
  ('monthly', 'Monthly'),
  ('quarterly', 'Quarterly'),
  ('annual', 'Annual'),
];

/// Add or edit a recurring transaction.
class AddEditRecurringScreen extends ConsumerStatefulWidget {
  final RecurringTransaction? recurring;

  const AddEditRecurringScreen({super.key, this.recurring});

  @override
  ConsumerState<AddEditRecurringScreen> createState() =>
      _AddEditRecurringScreenState();
}

class _AddEditRecurringScreenState
    extends ConsumerState<AddEditRecurringScreen> {
  final _formKey = GlobalKey<FormState>();
  final _payeeController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _nextExpectedDate = DateTime.now();
  String? _selectedAccountId;
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  String _selectedFrequency = 'monthly';
  bool _isSubscription = false;
  bool _isExpense = true;
  bool _isSaving = false;

  bool get _isEditing => widget.recurring != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final r = widget.recurring!;
      _payeeController.text = r.payee;
      _amountController.text = r.amountCents.abs().toCurrencyValue();
      _notesController.text = r.notes ?? '';
      _nextExpectedDate =
          DateTime.fromMillisecondsSinceEpoch(r.nextExpectedDate);
      _selectedAccountId = r.accountId;
      _selectedCategoryId = r.categoryId;
      _selectedFrequency = r.frequency;
      _isSubscription = r.isSubscription;
      _isExpense = r.amountCents < 0;
    }
  }

  @override
  void dispose() {
    _payeeController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextExpectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() => _nextExpectedDate = picked);
    }
  }

  void _showCategoryPicker() {
    final categoriesAsync = ref.read(allCategoriesProvider);

    categoriesAsync.whenData((categories) async {
      final result = await showCategoryPickerSheet(
        context: context,
        categories: categories,
        selectedCategoryId: _selectedCategoryId,
      );

      if (!mounted || result == null) return;

      if (result.cleared) {
        setState(() {
          _selectedCategoryId = null;
          _selectedCategoryName = null;
        });
      } else {
        setState(() {
          _selectedCategoryId = result.id;
          _selectedCategoryName = result.name;
        });
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(recurringTransactionRepositoryProvider);
      final rawCents = _amountController.text.toCents()!;
      final amountCents = _isExpense ? -rawCents.abs() : rawCents.abs();
      final now = DateTime.now().millisecondsSinceEpoch;

      if (_isEditing) {
        await repo.updateRecurring(RecurringTransactionsCompanion(
          id: Value(widget.recurring!.id),
          payee: Value(_payeeController.text.trim()),
          amountCents: Value(amountCents),
          categoryId: _selectedCategoryId == null
              ? const Value(null)
              : Value(_selectedCategoryId),
          accountId: Value(_selectedAccountId!),
          frequency: Value(_selectedFrequency),
          nextExpectedDate:
              Value(_nextExpectedDate.millisecondsSinceEpoch),
          lastOccurrenceDate:
              Value(widget.recurring!.lastOccurrenceDate),
          isSubscription: Value(_isSubscription),
          notes: _notesController.text.trim().isEmpty
              ? const Value(null)
              : Value(_notesController.text.trim()),
          updatedAt: Value(now),
        ));
      } else {
        await repo.insertRecurring(RecurringTransactionsCompanion.insert(
          id: const Uuid().v4(),
          payee: _payeeController.text.trim(),
          amountCents: amountCents,
          categoryId: _selectedCategoryId == null
              ? const Value(null)
              : Value(_selectedCategoryId),
          accountId: _selectedAccountId!,
          frequency: _selectedFrequency,
          nextExpectedDate:
              _nextExpectedDate.millisecondsSinceEpoch,
          lastOccurrenceDate: now,
          isSubscription: Value(_isSubscription),
          notes: _notesController.text.trim().isEmpty
              ? const Value(null)
              : Value(_notesController.text.trim()),
          createdAt: now,
          updatedAt: now,
        ));
      }

      if (mounted) {
        showSuccessSnackbar(
          context,
          _isEditing ? 'Recurring updated' : 'Recurring added',
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
    final payee = widget.recurring!.payee;
    final confirmed = await showDeleteConfirmation(
      context,
      itemName: payee.isNotEmpty ? payee : 'recurring transaction',
    );

    if (!confirmed) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(recurringTransactionRepositoryProvider)
          .deleteRecurring(widget.recurring!.id);
      if (mounted) {
        showSuccessSnackbar(context, 'Recurring transaction deleted');
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
    final accountsAsync = ref.watch(accountsProvider);

    // Resolve category name if editing and not yet set.
    if (_isEditing &&
        _selectedCategoryName == null &&
        _selectedCategoryId != null) {
      ref.watch(allCategoriesProvider).whenData((cats) {
        final cat =
            cats.where((c) => c.id == _selectedCategoryId).firstOrNull;
        if (cat != null && _selectedCategoryName == null) {
          final name = cat.name;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _selectedCategoryName == null) {
              setState(() => _selectedCategoryName = name);
            }
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isEditing ? 'Edit Recurring' : 'Add Recurring'),
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
            // Income / Expense toggle
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('Expense'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('Income'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_isExpense},
              onSelectionChanged: _isSaving
                  ? null
                  : (v) => setState(() => _isExpense = v.first),
            ),
            const SizedBox(height: 20),

            // Payee
            TextFormField(
              controller: _payeeController,
              decoration: const InputDecoration(
                labelText: 'Payee / Description *',
                hintText: 'e.g., Netflix',
                filled: true,
              ),
              textCapitalization: TextCapitalization.words,
              enabled: !_isSaving,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Payee is required'
                  : null,
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount *',
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
                final cents = v.toCents();
                if (cents == null || cents <= 0) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Frequency
            DropdownButtonFormField<String>(
              initialValue: _selectedFrequency,
              decoration: const InputDecoration(
                labelText: 'Frequency *',
                filled: true,
              ),
              items: _frequencies.map((f) {
                return DropdownMenuItem(
                  value: f.$1,
                  child: Text(f.$2),
                );
              }).toList(),
              onChanged: _isSaving
                  ? null
                  : (v) {
                      if (v != null) {
                        setState(() => _selectedFrequency = v);
                      }
                    },
            ),
            const SizedBox(height: 16),

            // Next expected date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Next Expected Date'),
              subtitle: Text(_nextExpectedDate.toMediumDate()),
              trailing: const Icon(Icons.chevron_right),
              onTap: _isSaving ? null : _pickDate,
            ),
            const Divider(),

            // Account & Category
            accountsAsync.when(
              loading: () => const ListTile(
                leading: Icon(Icons.account_balance),
                title: Text('Loading accounts...'),
              ),
              error: (_, _) => const ListTile(
                leading: Icon(Icons.error),
                title: Text('Error loading accounts'),
              ),
              data: (accounts) {
                _selectedAccountId ??= accounts.isNotEmpty ? accounts.first.id : null;

                return RecurringAccountCategorySection(
                  accounts: accounts,
                  selectedAccountId: _selectedAccountId,
                  selectedCategoryName: _selectedCategoryName,
                  selectedCategoryId: _selectedCategoryId,
                  enabled: !_isSaving,
                  onAccountChanged: (v) =>
                      setState(() => _selectedAccountId = v),
                  onCategoryTap: _showCategoryPicker,
                );
              },
            ),
            const Divider(),

            // Subscription toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Subscription'),
              subtitle: const Text('Mark as a subscription service'),
              value: _isSubscription,
              onChanged:
                  _isSaving ? null : (v) => setState(() => _isSubscription = v),
            ),
            const SizedBox(height: 8),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Optional notes...',
                filled: true,
              ),
              maxLines: 3,
              enabled: !_isSaving,
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
                  : Text(_isEditing ? 'Save Changes' : 'Add Recurring'),
            ),
          ],
        ),
      ),
    );
  }
}
