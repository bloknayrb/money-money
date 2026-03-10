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
import '../accounts/accounts_providers.dart';
import 'widgets/goal_appearance_section.dart';

/// Goal type options: (value, label).
const goalTypes = [
  ('savings', 'Savings Goal'),
  ('debt_payoff', 'Debt Payoff'),
  ('net_worth', 'Net Worth Milestone'),
  ('custom', 'Custom Goal'),
];

/// Preset color options for goals.
const goalColorOptions = [
  Color(0xFF1565C0), // Blue
  Color(0xFF2E7D32), // Green
  Color(0xFFC62828), // Red
  Color(0xFF6A1B9A), // Purple
  Color(0xFFEF6C00), // Orange
  Color(0xFF00838F), // Teal
  Color(0xFF4E342E), // Brown
  Color(0xFF37474F), // Blue Grey
];

/// Add or edit a goal.
class AddEditGoalScreen extends ConsumerStatefulWidget {
  final Goal? goal;

  const AddEditGoalScreen({super.key, this.goal});

  @override
  ConsumerState<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends ConsumerState<AddEditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();

  String _selectedType = 'savings';
  String _selectedIcon = 'savings';
  Color _selectedColor = goalColorOptions.first;
  DateTime? _targetDate;
  String? _linkedAccountId;
  bool _isSaving = false;

  bool get _isEditing => widget.goal != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final g = widget.goal!;
      _nameController.text = g.name;
      _targetAmountController.text = g.targetAmountCents.toCurrencyValue();
      _currentAmountController.text = g.currentAmountCents.toCurrencyValue();
      _selectedType = g.goalType;
      _selectedIcon = g.icon;
      _selectedColor = Color(g.color);
      _targetDate = g.targetDate?.toDateTime();
      _linkedAccountId = g.linkedAccountId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  Future<void> _pickTargetDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 30)),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(goalRepositoryProvider);
      final targetCents = _targetAmountController.text.toCents()!;
      final currentCents = _currentAmountController.text.toCents() ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (_isEditing) {
        await repo.updateGoal(GoalsCompanion(
          id: Value(widget.goal!.id),
          name: Value(_nameController.text.trim()),
          goalType: Value(_selectedType),
          targetAmountCents: Value(targetCents),
          currentAmountCents: Value(currentCents),
          targetDate: _targetDate != null
              ? Value(_targetDate!.millisecondsSinceEpoch)
              : const Value(null),
          linkedAccountId: _linkedAccountId != null
              ? Value(_linkedAccountId)
              : const Value(null),
          icon: Value(_selectedIcon),
          color: Value(_selectedColor.toARGB32()),
          updatedAt: Value(now),
        ));
      } else {
        await repo.insertGoal(GoalsCompanion.insert(
          id: const Uuid().v4(),
          name: _nameController.text.trim(),
          goalType: _selectedType,
          targetAmountCents: targetCents,
          currentAmountCents: Value(currentCents),
          targetDate: _targetDate != null
              ? Value(_targetDate!.millisecondsSinceEpoch)
              : const Value.absent(),
          linkedAccountId: _linkedAccountId != null
              ? Value(_linkedAccountId)
              : const Value.absent(),
          icon: _selectedIcon,
          color: _selectedColor.toARGB32(),
          createdAt: now,
          updatedAt: now,
        ));
      }

      if (mounted) {
        showSuccessSnackbar(
          context,
          _isEditing ? 'Goal updated' : 'Goal created',
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
      itemName: widget.goal!.name,
    );

    if (!confirmed) return;

    setState(() => _isSaving = true);
    try {
      await ref.read(goalRepositoryProvider).deleteGoal(widget.goal!.id);
      if (mounted) {
        showSuccessSnackbar(context, 'Goal deleted');
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Goal' : 'Add Goal'),
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
            // Goal name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Goal Name *',
                hintText: 'e.g., Emergency Fund',
                filled: true,
              ),
              textCapitalization: TextCapitalization.words,
              enabled: !_isSaving,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),

            // Goal type
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Goal Type *',
                filled: true,
              ),
              items: goalTypes.map((t) {
                return DropdownMenuItem(
                  value: t.$1,
                  child: Text(t.$2),
                );
              }).toList(),
              onChanged: _isSaving
                  ? null
                  : (v) {
                      if (v != null) setState(() => _selectedType = v);
                    },
            ),
            const SizedBox(height: 16),

            // Target amount
            TextFormField(
              controller: _targetAmountController,
              decoration: const InputDecoration(
                labelText: 'Target Amount *',
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
                if (v == null || v.trim().isEmpty) {
                  return 'Target amount is required';
                }
                final cents = v.toCents();
                if (cents == null || cents <= 0) return 'Invalid amount';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Current amount
            TextFormField(
              controller: _currentAmountController,
              decoration: const InputDecoration(
                labelText: 'Current Amount',
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
                if (v != null && v.trim().isNotEmpty && v.toCents() == null) {
                  return 'Invalid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Target date
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Target Date (optional)'),
              subtitle: Text(
                _targetDate != null
                    ? _targetDate!.toMediumDate()
                    : 'No target date set',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_targetDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _isSaving
                          ? null
                          : () => setState(() => _targetDate = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _isSaving ? null : _pickTargetDate,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Linked account
            accountsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const SizedBox.shrink(),
              data: (accounts) {
                return DropdownButtonFormField<String?>(
                  initialValue: _linkedAccountId,
                  decoration: const InputDecoration(
                    labelText: 'Linked Account (optional)',
                    filled: true,
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...accounts.map((a) {
                      return DropdownMenuItem<String?>(
                        value: a.id,
                        child: Text(a.name),
                      );
                    }),
                  ],
                  onChanged: _isSaving
                      ? null
                      : (v) => setState(() => _linkedAccountId = v),
                );
              },
            ),
            const SizedBox(height: 24),

            GoalAppearanceSection(
              selectedIcon: _selectedIcon,
              selectedColor: _selectedColor,
              enabled: !_isSaving,
              onIconChanged: (icon) =>
                  setState(() => _selectedIcon = icon),
              onColorChanged: (color) =>
                  setState(() => _selectedColor = color),
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
                  : Text(_isEditing ? 'Save Changes' : 'Create Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
