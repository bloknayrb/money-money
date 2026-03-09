import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../data/local/database/app_database.dart';
import '../accounts/accounts_providers.dart';

// =============================================================================
// SPENDING HISTORY (Feature #34)
// =============================================================================

/// Monthly spending totals for the last 6 months.
class MonthlySpending {
  final DateTime month;
  final int expenseCents;

  const MonthlySpending({required this.month, required this.expenseCents});
}

final monthlySpendingHistoryProvider =
    FutureProvider.autoDispose<List<MonthlySpending>>((ref) async {
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final now = DateTime.now();
  final results = <MonthlySpending>[];

  for (var i = 5; i >= 0; i--) {
    final month = DateTime(now.year, now.month - i, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
    final expenses = await transactionRepo.getTotalExpenses(
      month.millisecondsSinceEpoch,
      end.millisecondsSinceEpoch,
    );
    results.add(MonthlySpending(month: month, expenseCents: expenses.abs()));
  }

  return results;
});

// =============================================================================
// SPENDING BY CATEGORY (Feature #34)
// =============================================================================

/// Spending breakdown by category for the current month.
class CategorySpending {
  final String categoryId;
  final String categoryName;
  final int color;
  final int amountCents;

  const CategorySpending({
    required this.categoryId,
    required this.categoryName,
    required this.color,
    required this.amountCents,
  });
}

final spendingByCategoryProvider =
    FutureProvider.autoDispose<List<CategorySpending>>((ref) async {
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final categoryRepo = ref.watch(categoryRepositoryProvider);
  final now = DateTime.now();
  final monthStart = now.startOfMonth.millisecondsSinceEpoch;
  final monthEnd = now.endOfMonth.millisecondsSinceEpoch;

  final transactions = await transactionRepo.getTransactionsByDateRange(
    monthStart,
    monthEnd,
  );
  final categories = await categoryRepo.getAllCategories();
  final categoryMap = {for (final c in categories) c.id: c};

  // Group expenses by categoryId
  final totals = <String, int>{};
  for (final t in transactions) {
    if (t.amountCents >= 0 || t.categoryId == null) continue;
    totals[t.categoryId!] = (totals[t.categoryId!] ?? 0) + t.amountCents.abs();
  }

  // Convert to list, resolve category names
  final results = totals.entries.map((e) {
    final cat = categoryMap[e.key];
    // If subcategory, use parent name for grouping
    final parentCat = cat?.parentId != null ? categoryMap[cat!.parentId] : null;
    final displayCat = parentCat ?? cat;
    return (
      categoryId: displayCat?.id ?? e.key,
      categoryName: displayCat?.name ?? 'Uncategorized',
      color: displayCat?.color ?? 0xFF9E9E9E,
      amountCents: e.value,
    );
  }).toList();

  // Merge by parent category
  final merged = <String, CategorySpending>{};
  for (final r in results) {
    final existing = merged[r.categoryId];
    if (existing != null) {
      merged[r.categoryId] = CategorySpending(
        categoryId: r.categoryId,
        categoryName: r.categoryName,
        color: r.color,
        amountCents: existing.amountCents + r.amountCents,
      );
    } else {
      merged[r.categoryId] = CategorySpending(
        categoryId: r.categoryId,
        categoryName: r.categoryName,
        color: r.color,
        amountCents: r.amountCents,
      );
    }
  }

  final sorted = merged.values.toList()
    ..sort((a, b) => b.amountCents.compareTo(a.amountCents));
  return sorted.take(8).toList(); // Top 8 categories
});

// =============================================================================
// NET WORTH HISTORY (Feature #35)
// =============================================================================

/// Net worth at each month-end for the last 6 months.
class NetWorthSnapshot {
  final DateTime month;
  final int netWorthCents;

  const NetWorthSnapshot({required this.month, required this.netWorthCents});
}

final netWorthHistoryProvider =
    FutureProvider.autoDispose<List<NetWorthSnapshot>>((ref) async {
  final accounts = await ref.watch(accountsProvider.future);
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final allTransactions = await transactionRepo.getAllTransactions();
  final now = DateTime.now();

  // Current balances by account
  final currentBalances = <String, int>{};
  final accountIsAsset = <String, bool>{};
  for (final a in accounts) {
    currentBalances[a.id] = a.balanceCents;
    accountIsAsset[a.id] = a.isAsset;
  }

  // Build month-end snapshots by working backwards from current balances
  final snapshots = <NetWorthSnapshot>[];

  for (var i = 0; i <= 5; i++) {
    final monthEnd = DateTime(now.year, now.month - i + 1, 0, 23, 59, 59, 999);
    final monthEndMs = monthEnd.millisecondsSinceEpoch;

    // For each account, subtract transactions after monthEnd to get balance at monthEnd
    var netWorth = 0;
    for (final a in accounts) {
      final afterMonthEnd = allTransactions
          .where((t) => t.accountId == a.id && t.date > monthEndMs)
          .fold<int>(0, (sum, t) => sum + t.amountCents);
      final balanceAtMonthEnd = currentBalances[a.id]! - afterMonthEnd;
      if (accountIsAsset[a.id]!) {
        netWorth += balanceAtMonthEnd;
      } else {
        netWorth += balanceAtMonthEnd; // Liabilities are already negative
      }
    }

    snapshots.add(NetWorthSnapshot(month: monthEnd, netWorthCents: netWorth));
  }

  return snapshots.reversed.toList();
});

// =============================================================================
// INVESTMENTS SUMMARY (Feature #36)
// =============================================================================

const _investmentTypes = {'brokerage', '401k', 'ira', 'roth_ira', 'crypto'};

final investmentAccountsProvider =
    StreamProvider.autoDispose<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAllAccounts().map(
    (accounts) => accounts
        .where((a) => _investmentTypes.contains(a.accountType))
        .toList(),
  );
});

// =============================================================================
// MORTGAGE SUMMARY (Feature #37)
// =============================================================================

final mortgageAccountsProvider =
    StreamProvider.autoDispose<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAllAccounts().map(
    (accounts) =>
        accounts.where((a) => a.accountType == 'mortgage').toList(),
  );
});

// =============================================================================
// RETIREMENT SUMMARY (Feature #38)
// =============================================================================

const _retirementTypes = {'401k', 'ira', 'roth_ira', 'hsa'};

final retirementAccountsProvider =
    StreamProvider.autoDispose<List<Account>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAllAccounts().map(
    (accounts) => accounts
        .where((a) => _retirementTypes.contains(a.accountType))
        .toList(),
  );
});
