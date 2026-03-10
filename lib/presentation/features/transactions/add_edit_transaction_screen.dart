import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/database/app_database.dart';
import '../../shared/utils/snackbar_helpers.dart';
import '../../shared/widgets/category_picker_sheet.dart';
import '../../shared/widgets/delete_confirmation_dialog.dart';
import '../accounts/accounts_providers.dart';

/// Add or edit a financial transaction.
class AddEditTransactionScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;
  final String? accountId;

  const AddEditTransactionScreen({super.key, this.transaction, this.accountId});

  @override
  ConsumerState<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _payeeController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedAccountId;
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  bool _isExpense = true;
  bool _isSaving = false;
  Timer? _payeeSuggestionTimer;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final t = widget.transaction!;
      _payeeController.text = t.payee;
      _amountController.text = t.amountCents.abs().toCurrencyValue();
      _notesController.text = t.notes ?? '';
      _tagsController.text = t.tags ?? '';
      _selectedDate = DateTime.fromMillisecondsSinceEpoch(t.date);
      _selectedAccountId = t.accountId;
      _selectedCategoryId = t.categoryId;
      _isExpense = t.amountCents < 0;
    } else {
      _selectedAccountId = widget.accountId;
      _payeeController.addListener(_onPayeeChanged);
    }
  }

  @override
  void dispose() {
    _payeeSuggestionTimer?.cancel();
    _payeeController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _onPayeeChanged() {
    _payeeSuggestionTimer?.cancel();
    if (_selectedCategoryId != null) return; // user already picked
    final text = _payeeController.text.trim();
    if (text.length < 3) return;
    _payeeSuggestionTimer = Timer(const Duration(milliseconds: 300), () async {
      final service = ref.read(autoCategorizeServiceProvider);
      final categoryId = await service.categorize(text);
      if (categoryId != null && _selectedCategoryId == null && mounted) {
        final category = await ref
            .read(categoryRepositoryProvider)
            .getCategoryById(categoryId);
        if (category != null && mounted) {
          setState(() {
            _selectedCategoryId = categoryId;
            _selectedCategoryName = category.name;
          });
        }
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showCategoryPicker() {
    final categoriesAsync = _isExpense
        ? ref.read(expenseCategoriesProvider)
        : ref.read(incomeCategoriesProvider);

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
      final repo = ref.read(transactionRepositoryProvider);
      final rawCents = _amountController.text.toCents()!;
      final amountCents = _isExpense ? -rawCents.abs() : rawCents.abs();
      final now = DateTime.now().millisecondsSinceEpoch;

      if (_isEditing) {
        await repo.updateTransaction(TransactionsCompanion(
          id: Value(widget.transaction!.id),
          accountId: Value(_selectedAccountId!),
          amountCents: Value(amountCents),
          date: Value(_selectedDate.millisecondsSinceEpoch),
          payee: Value(_payeeController.text.trim()),
          notes: _notesController.text.trim().isEmpty
              ? const Value(null)
              : Value(_notesController.text.trim()),
          categoryId: _selectedCategoryId == null
              ? const Value(null)
              : Value(_selectedCategoryId),
          tags: _tagsController.text.trim().isEmpty
              ? const Value(null)
              : Value(_tagsController.text.trim()),
          updatedAt: Value(now),
        ));
      } else {
        await repo.insertTransaction(TransactionsCompanion.insert(
          id: const Uuid().v4(),
          accountId: _selectedAccountId!,
          amountCents: amountCents,
          date: _selectedDate.millisecondsSinceEpoch,
          payee: _payeeController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? const Value(null)
              : Value(_notesController.text.trim()),
          categoryId: _selectedCategoryId == null
              ? const Value(null)
              : Value(_selectedCategoryId),
          tags: _tagsController.text.trim().isEmpty
              ? const Value(null)
              : Value(_tagsController.text.trim()),
          createdAt: now,
          updatedAt: now,
        ));
      }

      // Record category assignment for auto-categorize learning
      final payeeText = _payeeController.text.trim();
      final autoCatService = ref.read(autoCategorizeServiceProvider);
      if (_selectedCategoryId != null && payeeText.isNotEmpty) {
        await autoCatService.recordCategoryAssignment(
          payee: payeeText,
          categoryId: _selectedCategoryId!,
          transactionId: _isEditing ? widget.transaction!.id : null,
          oldCategoryId: _isEditing ? widget.transaction!.categoryId : null,
        );
      }

      if (!mounted) return;

      // Check for other uncategorized transactions with the same payee
      if (_selectedCategoryId != null && payeeText.isNotEmpty) {
        final matchCount = await autoCatService.countUncategorizedByPayee(
          payeeText,
          excludeTransactionId: _isEditing ? widget.transaction!.id : null,
        );

        if (matchCount > 0 && mounted) {
          final apply = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Apply to matching transactions?'),
              content: Text(
                'Found $matchCount other uncategorized '
                '${matchCount == 1 ? 'transaction' : 'transactions'} '
                'from "$payeeText". Apply "$_selectedCategoryName" '
                'to all of them?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('No'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Apply'),
                ),
              ],
            ),
          );

          if (apply == true) {
            final updated = await autoCatService.applyToMatchingPayee(
              payeeText,
              _selectedCategoryId!,
            );
            if (mounted) {
              showSuccessSnackbar(
                context,
                'Categorized $updated '
                '${updated == 1 ? 'transaction' : 'transactions'}',
              );
            }
          }
        }
      }

      if (mounted) {
        showSuccessSnackbar(
          context,
          _isEditing ? 'Transaction updated' : 'Transaction added',
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
    final payee = widget.transaction!.payee;
    final confirmed = await showDeleteConfirmation(
      context,
      itemName: payee.isNotEmpty ? payee : 'transaction',
    );

    if (!confirmed) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(transactionRepositoryProvider)
          .deleteTransaction(widget.transaction!.id);
      if (mounted) {
        showSuccessSnackbar(context, 'Transaction deleted');
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accountsAsync = ref.watch(accountsProvider);

    // Resolve category name if editing and not yet set
    if (_isEditing && _selectedCategoryName == null && _selectedCategoryId != null) {
      ref.watch(allCategoriesProvider).whenData((cats) {
        final cat = cats.where((c) => c.id == _selectedCategoryId).firstOrNull;
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
        title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction'),
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
                  : (v) {
                      setState(() {
                        _isExpense = v.first;
                        // Reset category since type changed
                        _selectedCategoryId = null;
                        _selectedCategoryName = null;
                      });
                    },
            ),
            const SizedBox(height: 20),

            // Payee
            TextFormField(
              controller: _payeeController,
              decoration: const InputDecoration(
                labelText: 'Payee / Description *',
                hintText: 'e.g., Grocery Store',
                filled: true,
              ),
              textCapitalization: TextCapitalization.words,
              enabled: !_isSaving,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Payee is required' : null,
            ),
            const SizedBox(height: 16),

            // Amount
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount *',
                hintText: '0.00',
                prefixText: '\$ ',
                filled: true,
                suffixIcon: Icon(
                  _isExpense ? Icons.remove_circle_outline : Icons.add_circle_outline,
                  color: _isExpense ? colorScheme.error : theme.finance.income,
                ),
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

            // Date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              subtitle: Text(_selectedDate.toMediumDate()),
              trailing: const Icon(Icons.chevron_right),
              onTap: _isSaving ? null : _pickDate,
            ),
            const Divider(),

            // Account
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
                if (accounts.isEmpty) {
                  return ListTile(
                    leading: const Icon(Icons.warning),
                    title: const Text('No accounts'),
                    subtitle: const Text('Create an account first'),
                    tileColor: colorScheme.errorContainer.withValues(alpha: 0.3),
                  );
                }

                // Auto-select first account if none selected
                _selectedAccountId ??= accounts.first.id;

                return DropdownButtonFormField<String>(
                  initialValue: _selectedAccountId,
                  decoration: const InputDecoration(
                    labelText: 'Account *',
                    filled: true,
                  ),
                  items: accounts.map((a) {
                    return DropdownMenuItem(
                      value: a.id,
                      child: Text(a.name),
                    );
                  }).toList(),
                  onChanged: _isSaving
                      ? null
                      : (v) => setState(() => _selectedAccountId = v),
                  validator: (v) => v == null ? 'Select an account' : null,
                );
              },
            ),
            const SizedBox(height: 16),

            // Category
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.category),
              title: const Text('Category'),
              subtitle: Text(
                _selectedCategoryName ?? 'Uncategorized',
                style: _selectedCategoryId == null
                    ? TextStyle(color: colorScheme.onSurfaceVariant)
                    : null,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _isSaving ? null : _showCategoryPicker,
            ),
            const Divider(),

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
            const SizedBox(height: 16),

            // Tags
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags',
                hintText: 'Comma-separated tags',
                filled: true,
              ),
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
                  : Text(
                      _isEditing ? 'Save Changes' : 'Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
