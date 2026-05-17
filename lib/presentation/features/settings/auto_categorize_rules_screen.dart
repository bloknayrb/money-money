import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../../../data/local/database/models.dart';
import '../../../domain/usecases/categorize/auto_categorize_service.dart';
import '../../../domain/usecases/categorize/rule_conflicts.dart';
import '../../shared/utils/provider_invalidation.dart';
import '../../shared/widgets/category_picker_sheet.dart';
import '../accounts/accounts_providers.dart';
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
  bool _isRunning = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _runRecategorize() async {
    if (_isRunning) return;
    setState(() => _isRunning = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(
      content: Text('Categorizing uncategorized transactions…'),
      duration: Duration(seconds: 2),
    ));
    try {
      // Snapshot the uncategorized total before running so we can
      // differentiate "nothing to do" from "ran but nothing matched".
      final pendingBefore = await ref
          .read(transactionRepositoryProvider)
          .getUncategorizedTransactions();
      final count =
          await ref.read(autoCategorizeServiceProvider).categorizeUncategorized();
      if (!mounted) return;
      invalidateFinancialData(ref);
      messenger.hideCurrentSnackBar();
      final String message;
      if (pendingBefore.isEmpty) {
        message = 'Nothing to categorize — no uncategorized transactions';
      } else if (count == 0) {
        message = '${pendingBefore.length} uncategorized transaction'
            '${pendingBefore.length == 1 ? '' : 's'} '
            'didn\'t match any rule';
      } else {
        message = 'Categorized $count transaction${count == 1 ? '' : 's'}';
      }
      messenger.showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(
        content: Text('Re-categorize failed: $e'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } finally {
      if (mounted) setState(() => _isRunning = false);
    }
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
            icon: _isRunning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            tooltip: 'Re-categorize uncategorized transactions',
            onPressed: _isRunning ? null : _runRecategorize,
          ),
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
              _TestPayeePanel(categoryNames: categoryNames),
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

  List<RuleConflict> _computeConflicts(List<AutoCategorizeRule> existing) {
    final priority =
        int.tryParse(_priorityController.text.trim()) ?? 100;
    return detectRuleConflicts(
      editingRuleId: widget.rule?.id,
      payeeContains: _payeeContainsController.text.trim().isEmpty
          ? null
          : _payeeContainsController.text.trim(),
      payeeExact: widget.rule?.payeeExact,
      categoryId: _selectedCategoryId,
      priority: priority,
      existingRules: existing,
    );
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

    final existingRules =
        ref.watch(autoCategorizeRulesProvider).valueOrNull ?? const [];
    final conflicts = _computeConflicts(existingRules);

    return AlertDialog(
      title: Text(widget.rule == null ? 'Add Rule' : 'Edit Rule'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priorityController,
              decoration: const InputDecoration(
                labelText: 'Priority (lower = higher)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Category'),
              subtitle: Text(_selectedCategoryName ?? 'Select category'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pickCategory(context),
            ),
            if (conflicts.isNotEmpty) ...[
              const SizedBox(height: 12),
              _ConflictWarning(
                conflicts: conflicts,
                priority: int.tryParse(_priorityController.text.trim()) ?? 100,
              ),
            ],
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

class _TestPayeePanel extends ConsumerStatefulWidget {
  const _TestPayeePanel({required this.categoryNames});

  final Map<String, String> categoryNames;

  @override
  ConsumerState<_TestPayeePanel> createState() => _TestPayeePanelState();
}

class _TestPayeePanelState extends ConsumerState<_TestPayeePanel> {
  final _payeeController = TextEditingController();
  final _amountController = TextEditingController();
  String? _accountId;
  CategorizationTrace? _result;
  bool _running = false;

  @override
  void dispose() {
    _payeeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final payee = _payeeController.text.trim();
    if (payee.isEmpty || _running) return;
    final amountText = _amountController.text.trim();
    final dollars = double.tryParse(amountText);
    final amountCents = dollars == null ? null : (dollars * 100).round();
    final accounts = ref.read(accountsProvider).valueOrNull ?? const [];
    final account =
        accounts.where((a) => a.id == _accountId).firstOrNull;
    setState(() => _running = true);
    try {
      final trace = await ref.read(autoCategorizeServiceProvider).categorizeWithTrace(
            payee,
            amountCents: amountCents,
            accountId: _accountId,
            accountType: account?.accountType,
          );
      if (mounted) setState(() => _result = trace);
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        margin: EdgeInsets.zero,
        child: ExpansionTile(
          leading: const Icon(Icons.science_outlined),
          title: const Text('Test a payee'),
          subtitle: Text(
            'See which rule or cache entry would match',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            TextField(
              controller: _payeeController,
              decoration: const InputDecoration(
                labelText: 'Payee',
                hintText: 'e.g. SQ *STARBUCKS #1234 CA 90210',
                isDense: true,
              ),
              onSubmitted: (_) => _run(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Amount (optional)',
                      hintText: '12.34',
                      prefixText: r'$ ',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String?>(
                    initialValue: _accountId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Account (optional)',
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('(any)'),
                      ),
                      for (final a in accounts)
                        DropdownMenuItem<String?>(
                          value: a.id,
                          child: Text(a.name, overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    onChanged: (v) => setState(() => _accountId = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _running ? null : _run,
                icon: _running
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow),
                label: const Text('Test'),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 12),
              _TestPayeeResult(
                trace: _result!,
                categoryNames: widget.categoryNames,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TestPayeeResult extends StatelessWidget {
  const _TestPayeeResult({required this.trace, required this.categoryNames});

  final CategorizationTrace trace;
  final Map<String, String> categoryNames;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final categoryName = trace.categoryId == null
        ? null
        : (categoryNames[trace.categoryId!] ?? 'Unknown');
    final (label, color) = switch (trace.source) {
      CategorizationSource.cache => ('Cache match', scheme.primary),
      CategorizationSource.rule => ('Rule match', scheme.tertiary),
      CategorizationSource.none => ('No match', scheme.outline),
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: color),
              const SizedBox(width: 6),
              Text(label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      )),
            ],
          ),
          const SizedBox(height: 4),
          if (trace.normalizedPayee.isNotEmpty)
            Text('Normalized: ${trace.normalizedPayee}',
                style: Theme.of(context).textTheme.bodySmall),
          if (categoryName != null)
            Text('Category: $categoryName',
                style: Theme.of(context).textTheme.bodyMedium),
          if (trace.source == CategorizationSource.cache &&
              trace.cacheConfidence != null)
            Text(
              'Confidence: ${(trace.cacheConfidence! * 100).round()}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (trace.source == CategorizationSource.rule &&
              trace.matchedRule != null)
            Text(
              'Rule: ${trace.matchedRule!.name} (priority ${trace.matchedRule!.priority})',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (trace.source == CategorizationSource.none &&
              trace.cacheConfidence != null)
            Text(
              'Cache hint: ${trace.cacheConfidence!.toStringAsFixed(2)} '
              '(below 0.8 threshold; user prompted instead of auto-applied)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}

class _ConflictWarning extends StatelessWidget {
  const _ConflictWarning({required this.conflicts, required this.priority});

  final List<RuleConflict> conflicts;
  final int priority;

  String _message(RuleConflict c) {
    final otherName = c.other.name;
    switch (c.kind) {
      case RuleConflictKind.samePatternDifferentCategory:
        return 'Rule "$otherName" uses the same pattern but maps to a '
            'different category. Whichever has lower priority wins.';
      case RuleConflictKind.shadowsOther:
        return 'Rule "$otherName" is more specific; with this priority it '
            'would never run.';
      case RuleConflictKind.shadowedByOther:
        return 'Rule "$otherName" is more general and runs first; lower '
            'this rule\'s priority below ${c.other.priority}.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.amber.shade800, size: 20),
              const SizedBox(width: 8),
              Text(
                conflicts.length == 1
                    ? 'Possible conflict'
                    : 'Possible conflicts (${conflicts.length})',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...conflicts.map(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                '• ${_message(c)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
