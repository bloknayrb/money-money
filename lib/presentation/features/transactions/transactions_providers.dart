import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/local/database/models.dart';

// Re-export category providers so existing imports continue to work.
export '../../../core/di/providers.dart'
    show allCategoriesProvider, expenseCategoriesProvider, incomeCategoriesProvider;

// =============================================================================
// FILTER STATE
// =============================================================================

/// Holds all active filter criteria for the transactions list.
class TransactionFilters {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? categoryId;
  final String? accountId;
  final int? minAmountCents;
  final int? maxAmountCents;
  final bool uncategorizedOnly;

  const TransactionFilters({
    this.startDate,
    this.endDate,
    this.categoryId,
    this.accountId,
    this.minAmountCents,
    this.maxAmountCents,
    this.uncategorizedOnly = false,
  });

  bool get hasAny =>
      startDate != null ||
      endDate != null ||
      categoryId != null ||
      accountId != null ||
      minAmountCents != null ||
      maxAmountCents != null ||
      uncategorizedOnly;

  TransactionFilters copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    String? accountId,
    int? minAmountCents,
    int? maxAmountCents,
    bool? uncategorizedOnly,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearCategory = false,
    bool clearAccount = false,
    bool clearMinAmount = false,
    bool clearMaxAmount = false,
  }) {
    return TransactionFilters(
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      accountId: clearAccount ? null : (accountId ?? this.accountId),
      minAmountCents:
          clearMinAmount ? null : (minAmountCents ?? this.minAmountCents),
      maxAmountCents:
          clearMaxAmount ? null : (maxAmountCents ?? this.maxAmountCents),
      uncategorizedOnly: uncategorizedOnly ?? this.uncategorizedOnly,
    );
  }

  static const empty = TransactionFilters();
}

/// Current filter state.
final transactionFiltersProvider =
    StateProvider<TransactionFilters>((ref) => TransactionFilters.empty);

// =============================================================================
// CORE PROVIDERS
// =============================================================================

/// Watch all transactions (most recent first), with filters and search applied.
final transactionsProvider = StreamProvider.autoDispose<List<Transaction>>((ref) {
  final filters = ref.watch(transactionFiltersProvider);
  final searchQuery = ref.watch(transactionSearchQueryProvider);

  // Start with all transactions stream
  final stream = ref.watch(transactionRepositoryProvider).watchAllTransactions();

  // Apply client-side filtering
  return stream.map((transactions) {
    var result = transactions;

    // Search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result
          .where((t) => t.payee.toLowerCase().contains(query))
          .toList();
    }

    // Date range filter
    if (filters.startDate != null) {
      final startMs = filters.startDate!.millisecondsSinceEpoch;
      result = result.where((t) => t.date >= startMs).toList();
    }
    if (filters.endDate != null) {
      final endMs = filters.endDate!
          .add(const Duration(hours: 23, minutes: 59, seconds: 59))
          .millisecondsSinceEpoch;
      result = result.where((t) => t.date <= endMs).toList();
    }

    // Category filter
    if (filters.uncategorizedOnly) {
      result = result.where((t) => t.categoryId == null).toList();
    } else if (filters.categoryId != null) {
      result = result
          .where((t) => t.categoryId == filters.categoryId)
          .toList();
    }

    // Account filter
    if (filters.accountId != null) {
      result = result
          .where((t) => t.accountId == filters.accountId)
          .toList();
    }

    // Amount range filter (applied to absolute value)
    if (filters.minAmountCents != null) {
      result = result
          .where((t) => t.amountCents.abs() >= filters.minAmountCents!)
          .toList();
    }
    if (filters.maxAmountCents != null) {
      result = result
          .where((t) => t.amountCents.abs() <= filters.maxAmountCents!)
          .toList();
    }

    return result;
  });
});

/// Watch transactions for a specific account.
final accountTransactionsProvider =
    StreamProvider.autoDispose.family<List<Transaction>, String>((ref, accountId) {
  return ref
      .watch(transactionRepositoryProvider)
      .watchTransactionsForAccount(accountId);
});

/// Recent transactions for dashboard (last 10, reactive via stream).
final recentTransactionsProvider = StreamProvider.autoDispose<List<Transaction>>((ref) {
  return ref
      .watch(transactionRepositoryProvider)
      .watchRecentTransactions(limit: 10);
});

/// Total income for current month.
final monthlyIncomeProvider = FutureProvider.autoDispose<int>((ref) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
  return ref.watch(transactionRepositoryProvider).getTotalIncome(
    start.millisecondsSinceEpoch,
    end.millisecondsSinceEpoch,
  );
});

/// Total expenses for current month.
final monthlyExpensesProvider = FutureProvider.autoDispose<int>((ref) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
  return ref.watch(transactionRepositoryProvider).getTotalExpenses(
    start.millisecondsSinceEpoch,
    end.millisecondsSinceEpoch,
  );
});

/// Search query state.
final transactionSearchQueryProvider = StateProvider<String>((ref) => '');

/// Uncategorized transaction count (uses count query, not full fetch).
final uncategorizedCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref
      .watch(transactionRepositoryProvider)
      .getUncategorizedCount();
});
