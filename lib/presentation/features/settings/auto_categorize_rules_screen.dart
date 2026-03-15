import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../../../data/local/database/app_database.dart';
import '../../shared/widgets/category_picker_sheet.dart';
import 'auto_categorize_providers.dart';

/// Screen for managing auto-categorization rules.
class AutoCategorizeRulesScreen extends ConsumerStatefulWidget {
  const AutoCategorizeRulesScreen({super.key});

  @override
  ConsumerState<AutoCategorizeRulesScreen> createState() =>
      _AutoCategorizeRulesScreenState();
}

class _AutoCategorizeRulesScreenState
    extends ConsumerState<AutoCategorizeRulesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rulesAsync = ref.watch(autoCategorizeRulesProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);

    // Build category name lookup
    final categoryNames = <String, String>{};
    categoriesAsync.whenData((cats) {
      for (final c in cats) {
        categoryNames[c.id] = c.name;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto-Categorization Rules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add rule',
            onPressed: () => _showRuleDialog(context, ref),
          ),
        ],
      ),
      body: rulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (rules) {
          if (rules.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No rules yet. Tap + to add one.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Filter rules by search query
          final query = _searchQuery.toLowerCase();
          final filtered = query.isEmpty
              ? rules
              : rules.where((rule) {
                  final name = rule.name.toLowerCase();
                  final payee =
                      (rule.payeeContains ?? '').toLowerCase();
                  final payeeExact =
                      (rule.payeeExact ?? '').toLowerCase();
                  final catName =
                      (categoryNames[rule.categoryId] ?? '').toLowerCase();
                  return name.contains(query) ||
                      payee.contains(query) ||
                      payeeExact.contains(query) ||
                      catName.contains(query);
                }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search rules...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) =>
                      setState(() => _searchQuery = value),
                ),
              ),
              if (query.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filtered.length} of ${rules.length} rules',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No rules match "$_searchQuery"',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final rule = filtered[index];
                          return _RuleTile(
                            rule: rule,
                            categoryNames: categoryNames,
                            onTap: () =>
                                _showRuleDialog(context, ref, rule: rule),
                            onToggle: (value) {
                              final now =
                                  DateTime.now().millisecondsSinceEpoch;
                              ref
                                  .read(autoCategorizeRepositoryProvider)
                                  .updateRule(
                                    AutoCategorizeRulesCompanion(
                                      id: Value(rule.id),
                                      isEnabled: Value(value),
                                      updatedAt: Value(now),
                                    ),
                                  );
                            },
                            onDelete: () {
                              ref
                                  .read(autoCategorizeRepositoryProvider)
                                  .deleteRule(rule.id);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showRuleDialog(BuildContext context, WidgetRef ref,
      {AutoCategorizeRule? rule}) {
    showDialog(
      context: context,
      builder: (ctx) => _RuleDialog(rule: rule),
    );
  }
}

class _RuleTile extends StatelessWidget {
  final AutoCategorizeRule rule;
  final Map<String, String> categoryNames;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const _RuleTile({
    required this.rule,
    required this.categoryNames,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(rule.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Rule'),
          content: Text('Delete "${rule.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        title: Text(rule.name),
        subtitle: Text(
          _ruleDescription(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Switch(
          value: rule.isEnabled,
          onChanged: onToggle,
        ),
        onTap: onTap,
      ),
    );
  }

  String _ruleDescription() {
    final parts = <String>[];
    if (rule.payeeContains != null) parts.add('Contains "${rule.payeeContains}"');
    if (rule.payeeExact != null) parts.add('Exact "${rule.payeeExact}"');
    final catName = categoryNames[rule.categoryId] ?? 'Unknown';
    parts.add('→ $catName');
    parts.add('Priority: ${rule.priority}');
    return parts.join(' · ');
  }
}

class _RuleDialog extends ConsumerStatefulWidget {
  final AutoCategorizeRule? rule;

  const _RuleDialog({this.rule});

  @override
  ConsumerState<_RuleDialog> createState() => _RuleDialogState();
}

class _RuleDialogState extends ConsumerState<_RuleDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _payeeContainsController;
  late final TextEditingController _priorityController;
  String? _selectedCategoryId;
  String? _selectedCategoryName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.rule?.name ?? '');
    _payeeContainsController =
        TextEditingController(text: widget.rule?.payeeContains ?? '');
    _priorityController =
        TextEditingController(text: '${widget.rule?.priority ?? 100}');
    _selectedCategoryId = widget.rule?.categoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _payeeContainsController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Resolve category name
    if (_selectedCategoryId != null && _selectedCategoryName == null) {
      ref.watch(allCategoriesProvider).whenData((cats) {
        final cat = cats.where((c) => c.id == _selectedCategoryId).firstOrNull;
        if (cat != null) _selectedCategoryName = cat.name;
      });
    }

    return AlertDialog(
      title: Text(widget.rule == null ? 'Add Rule' : 'Edit Rule'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Rule Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _payeeContainsController,
              decoration: const InputDecoration(
                labelText: 'Payee Contains',
                hintText: 'e.g. AMAZON',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priorityController,
              decoration: const InputDecoration(
                labelText: 'Priority (lower = higher)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Category'),
              subtitle: Text(_selectedCategoryName ?? 'Select category'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickCategory(context),
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

  Future<void> _pickCategory(BuildContext context) async {
    final result = await showCategoryPickerSheet(
      context: context,
      selectedCategoryId: _selectedCategoryId,
      showClear: false,
    );

    if (!mounted || result == null) return;
    if (!result.cleared) {
      setState(() {
        _selectedCategoryId = result.id;
        _selectedCategoryName = result.name;
      });
    }
  }

  void _save() {
    final name = _nameController.text.trim();
    final payeeContains = _payeeContainsController.text.trim();
    final priority = int.tryParse(_priorityController.text.trim()) ?? 100;

    if (name.isEmpty || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and category are required')),
      );
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final repo = ref.read(autoCategorizeRepositoryProvider);

    if (widget.rule != null) {
      repo.updateRule(AutoCategorizeRulesCompanion(
        id: Value(widget.rule!.id),
        name: Value(name),
        payeeContains: Value(payeeContains.isNotEmpty ? payeeContains : null),
        priority: Value(priority),
        categoryId: Value(_selectedCategoryId!),
        updatedAt: Value(now),
      ));
    } else {
      repo.insertRule(AutoCategorizeRulesCompanion.insert(
        id: const Uuid().v4(),
        name: name,
        priority: priority,
        payeeContains: Value(payeeContains.isNotEmpty ? payeeContains : null),
        categoryId: _selectedCategoryId!,
        createdAt: now,
        updatedAt: now,
      ));
    }

    Navigator.pop(context);
  }
}
