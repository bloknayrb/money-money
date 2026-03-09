import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/money_extensions.dart';
import '../../../shared/widgets/category_picker_sheet.dart';
import '../../accounts/accounts_providers.dart';
import '../transactions_providers.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late TransactionFilters _filters;
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();

  // Display names resolved lazily in build()
  String? _categoryName;
  String? _accountName;

  @override
  void initState() {
    super.initState();
    _filters = ref.read(transactionFiltersProvider);
    if (_filters.minAmountCents != null) {
      _minAmountController.text = _filters.minAmountCents!.toCurrencyValue();
    }
    if (_filters.maxAmountCents != null) {
      _maxAmountController.text = _filters.maxAmountCents!.toCurrencyValue();
    }
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  String _dateRangeLabel() {
    if (_filters.startDate == null && _filters.endDate == null) return 'All time';
    if (_filters.startDate != null && _filters.endDate != null) {
      return '${_filters.startDate!.toMediumDate()} - ${_filters.endDate!.toMediumDate()}';
    }
    if (_filters.startDate != null) return 'From ${_filters.startDate!.toMediumDate()}';
    return 'Until ${_filters.endDate!.toMediumDate()}';
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _filters.startDate != null && _filters.endDate != null
          ? DateTimeRange(start: _filters.startDate!, end: _filters.endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _filters = _filters.copyWith(
          startDate: picked.start,
          endDate: picked.end,
        );
      });
    }
  }

  void _showCategoryPicker() {
    final categoriesAsync = ref.read(allCategoriesProvider);
    categoriesAsync.whenData((categories) async {
      final result = await showCategoryPickerSheet(
        context: context,
        categories: categories,
        selectedCategoryId: _filters.categoryId,
        title: 'Filter by Category',
      );

      if (!mounted || result == null) return;

      if (result.cleared) {
        setState(() {
          _filters = _filters.copyWith(clearCategory: true);
          _categoryName = null;
        });
      } else {
        setState(() {
          _filters = _filters.copyWith(categoryId: result.id);
          _categoryName = result.name;
        });
      }
    });
  }

  void _showAccountPicker() {
    final accountsAsync = ref.read(accountsProvider);
    accountsAsync.whenData((accounts) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter by Account',
                      style: Theme.of(ctx).textTheme.titleLarge),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filters = _filters.copyWith(clearAccount: true);
                        _accountName = null;
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final account in accounts)
                ListTile(
                  leading: const Icon(Icons.account_balance),
                  title: Text(account.name),
                  subtitle: Text(account.balanceCents.toCurrency()),
                  selected: _filters.accountId == account.id,
                  onTap: () {
                    setState(() {
                      _filters =
                          _filters.copyWith(accountId: account.id);
                      _accountName = account.name;
                    });
                    Navigator.pop(ctx);
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  void _applyFilters() {
    // Parse amount fields
    final minText = _minAmountController.text.trim();
    final maxText = _maxAmountController.text.trim();

    var updatedFilters = _filters;
    if (minText.isNotEmpty) {
      final cents = minText.toCents();
      if (cents != null) {
        updatedFilters = updatedFilters.copyWith(minAmountCents: cents);
      }
    } else {
      updatedFilters = updatedFilters.copyWith(clearMinAmount: true);
    }

    if (maxText.isNotEmpty) {
      final cents = maxText.toCents();
      if (cents != null) {
        updatedFilters = updatedFilters.copyWith(maxAmountCents: cents);
      }
    } else {
      updatedFilters = updatedFilters.copyWith(clearMaxAmount: true);
    }

    ref.read(transactionFiltersProvider.notifier).state = updatedFilters;
    Navigator.pop(context);
  }

  void _clearAll() {
    ref.read(transactionFiltersProvider.notifier).state =
        TransactionFilters.empty;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Resolve display names reactively (handles async provider loading)
    if (_filters.categoryId != null && _categoryName == null) {
      ref.watch(allCategoriesProvider).whenData((cats) {
        final cat = cats.where((c) => c.id == _filters.categoryId).firstOrNull;
        if (cat != null) _categoryName = cat.name;
      });
    }
    if (_filters.accountId != null && _accountName == null) {
      ref.watch(accountsProvider).whenData((accts) {
        final acct = accts.where((a) => a.id == _filters.accountId).firstOrNull;
        if (acct != null) _accountName = acct.name;
      });
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: theme.textTheme.titleLarge),
              if (_filters.hasAny)
                TextButton(
                  onPressed: _clearAll,
                  child: const Text('Clear All'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Date range
          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Date Range'),
            subtitle: Text(_dateRangeLabel()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_filters.startDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => setState(() {
                      _filters = _filters.copyWith(
                        clearStartDate: true,
                        clearEndDate: true,
                      );
                    }),
                  ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: _pickDateRange,
          ),
          // Category
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Category'),
            subtitle: Text(_categoryName ?? 'All categories'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_filters.categoryId != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => setState(() {
                      _filters = _filters.copyWith(clearCategory: true);
                      _categoryName = null;
                    }),
                  ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: _showCategoryPicker,
          ),
          // Account
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Account'),
            subtitle: Text(_accountName ?? 'All accounts'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_filters.accountId != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => setState(() {
                      _filters = _filters.copyWith(clearAccount: true);
                      _accountName = null;
                    }),
                  ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: _showAccountPicker,
          ),
          // Amount range
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.attach_money),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _minAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Min',
                      hintText: '0.00',
                      prefixText: '\$ ',
                      isDense: true,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Text('to'),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Max',
                      hintText: '0.00',
                      prefixText: '\$ ',
                      isDense: true,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _applyFilters,
              child: const Text('Apply Filters'),
            ),
          ),
          const SizedBox(height: 8),
        ],
        ),
      ),
    );
  }
}
