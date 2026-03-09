import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../data/local/database/app_database.dart';
import '../../shared/empty_states/empty_state_widget.dart';
import '../../shared/loading/shimmer_loading.dart';
import 'add_edit_transaction_screen.dart';
import 'transactions_providers.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/transaction_tile.dart';

/// Transaction list screen with search and filters.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search transactions...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  ref.read(transactionSearchQueryProvider.notifier).state = value;
                },
              )
            : const Text('Transactions'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: _isSearching ? 'Close search' : 'Search',
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(transactionSearchQueryProvider.notifier).state = '';
                }
              });
            },
          ),
          Builder(builder: (context) {
            final hasFilters = ref.watch(transactionFiltersProvider).hasAny;
            return IconButton(
              icon: Badge(
                isLabelVisible: hasFilters,
                child: const Icon(Icons.filter_list),
              ),
              tooltip: 'Filter',
              onPressed: () => _showFilterSheet(context),
            );
          }),
        ],
      ),
      body: transactionsAsync.when(
        loading: () => const ShimmerTransactionList(),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.receipt_long,
              title: 'No transactions yet',
              description:
                  'Your transactions will appear here once you add them manually or connect your bank.',
              actionLabel: 'Add Transaction',
              onAction: () => _navigateToAddTransaction(context),
            );
          }
          return _TransactionListView(transactions: transactions);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddTransaction(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddEditTransactionScreen(),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}

/// Transaction list grouped by date.
class _TransactionListView extends ConsumerWidget {
  final List<Transaction> transactions;

  const _TransactionListView({required this.transactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build category lookup map once at the list level
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final categoryNames = <String, String>{};
    categoriesAsync.whenData((categories) {
      for (final c in categories) {
        categoryNames[c.id] = c.name;
      }
    });

    // Group transactions by date
    final grouped = _groupByDate(transactions);
    final entries = grouped.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateHeader(date: entry.key),
            for (final transaction in entry.value)
              TransactionTile(
                transaction: transaction,
                categoryName: transaction.categoryId != null
                    ? categoryNames[transaction.categoryId!]
                    : null,
              ),
          ],
        );
      },
    );
  }

  Map<String, List<Transaction>> _groupByDate(List<Transaction> transactions) {
    final groups = <String, List<Transaction>>{};
    for (final t in transactions) {
      final date = t.date.toDateTime().toRelative();
      groups.putIfAbsent(date, () => []).add(t);
    }
    return groups;
  }
}

class _DateHeader extends StatelessWidget {
  final String date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        date,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
