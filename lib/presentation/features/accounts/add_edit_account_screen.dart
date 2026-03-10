import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../data/local/database/app_database.dart';
import 'accounts_providers.dart';

/// Add or edit an account.
class AddEditAccountScreen extends ConsumerStatefulWidget {
  final Account? account;

  const AddEditAccountScreen({super.key, this.account});

  @override
  ConsumerState<AddEditAccountScreen> createState() =>
      _AddEditAccountScreenState();
}

class _AddEditAccountScreenState extends ConsumerState<AddEditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _institutionController = TextEditingController();
  final _balanceController = TextEditingController();

  String _selectedType = 'checking';
  bool _isSaving = false;

  bool get _isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final a = widget.account!;
      _nameController.text = a.name;
      _institutionController.text = a.institutionName ?? '';
      _selectedType = a.accountType;
      _balanceController.text = a.balanceCents.toCurrencyValue();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(accountRepositoryProvider);
      final balanceCents = _balanceController.text.toCents()!;
      final isAsset = isAccountTypeAsset(_selectedType);
      final now = DateTime.now().millisecondsSinceEpoch;

      if (_isEditing) {
        await repo.updateAccount(AccountsCompanion(
          id: Value(widget.account!.id),
          name: Value(_nameController.text.trim()),
          institutionName: _institutionController.text.trim().isEmpty
              ? const Value(null)
              : Value(_institutionController.text.trim()),
          accountType: Value(_selectedType),
          balanceCents: Value(balanceCents),
          isAsset: Value(isAsset),
          updatedAt: Value(now),
        ));
      } else {
        await repo.insertAccount(AccountsCompanion.insert(
          id: const Uuid().v4(),
          name: _nameController.text.trim(),
          institutionName: _institutionController.text.trim().isEmpty
              ? const Value(null)
              : Value(_institutionController.text.trim()),
          accountType: _selectedType,
          balanceCents: balanceCents,
          isAsset: isAsset,
          displayOrder: 0,
          createdAt: now,
          updatedAt: now,
        ));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Account updated' : 'Account created'),
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
          'Delete "${widget.account!.name}"? All transactions in this account will also be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSaving = true);
    try {
      await ref.read(accountRepositoryProvider).deleteAccount(widget.account!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted')),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Account' : 'Add Account'),
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
            // Account name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Account Name *',
                hintText: 'e.g., Chase Checking',
                filled: true,
              ),
              textCapitalization: TextCapitalization.words,
              enabled: !_isSaving,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),

            // Institution
            TextFormField(
              controller: _institutionController,
              decoration: const InputDecoration(
                labelText: 'Institution',
                hintText: 'e.g., Chase Bank',
                filled: true,
              ),
              textCapitalization: TextCapitalization.words,
              enabled: !_isSaving,
            ),
            const SizedBox(height: 16),

            // Account type
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Account Type *',
                filled: true,
              ),
              items: accountTypes.map((t) {
                return DropdownMenuItem(
                  value: t.key,
                  child: Text(t.label),
                );
              }).toList(),
              onChanged: _isSaving
                  ? null
                  : (v) {
                      if (v != null) setState(() => _selectedType = v);
                    },
            ),
            const SizedBox(height: 16),

            // Balance
            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Current Balance *',
                hintText: '0.00',
                prefixText: '\$ ',
                filled: true,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true, signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
              ],
              enabled: !_isSaving,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Balance is required';
                if (v.toCents() == null) return 'Invalid amount';
                return null;
              },
            ),
            const SizedBox(height: 8),

            // Asset/liability indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                isAccountTypeAsset(_selectedType)
                    ? 'This is an asset account (increases net worth)'
                    : 'This is a liability account (decreases net worth)',
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
                  : Text(_isEditing ? 'Save Changes' : 'Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
