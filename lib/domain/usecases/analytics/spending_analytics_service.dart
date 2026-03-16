import '../../../core/extensions/money_extensions.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import 'analytics_models.dart';

export 'analytics_models.dart';

/// Domain service for dashboard analytics computations.
class SpendingAnalyticsService {
  SpendingAnalyticsService({
    required TransactionRepository transactionRepo,
    required CategoryRepository categoryRepo,
    required AccountRepository accountRepo,
  })  : _transactionRepo = transactionRepo,
        _categoryRepo = categoryRepo,
        _accountRepo = accountRepo;

  final TransactionRepository _transactionRepo;
  final CategoryRepository _categoryRepo;
  final AccountRepository _accountRepo;

  /// Top spending categories for the current month, merged by parent.
  Future<List<CategorySpending>> getTopCategorySpending(int topN) async {
    final now = DateTime.now();
    final monthStart = now.startOfMonth.millisecondsSinceEpoch;
    final monthEnd = now.endOfMonth.millisecondsSinceEpoch;

    final transactions = await _transactionRepo.getTransactionsByDateRange(
      monthStart,
      monthEnd,
    );
    final categories = await _categoryRepo.getAllCategories();
    final categoryMap = {for (final c in categories) c.id: c};

    // Group expenses by categoryId.
    final totals = <String, int>{};
    for (final t in transactions) {
      if (t.amountCents >= 0 || t.categoryId == null) continue;
      totals[t.categoryId!] = (totals[t.categoryId!] ?? 0) + t.amountCents.abs();
    }

    // Resolve to parent categories for grouping.
    final results = totals.entries.map((e) {
      final cat = categoryMap[e.key];
      final parentCat = cat?.parentId != null ? categoryMap[cat!.parentId] : null;
      final displayCat = parentCat ?? cat;
      return (
        categoryId: displayCat?.id ?? e.key,
        categoryName: displayCat?.name ?? 'Uncategorized',
        color: displayCat?.color ?? 0xFF9E9E9E,
        amountCents: e.value,
      );
    }).toList();

    // Merge by parent category.
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
    return sorted.take(topN).toList();
  }

  /// Net worth at each month-end for the last [months] months,
  /// reconstructed by subtracting future transactions from current balances.
  Future<List<NetWorthSnapshot>> getNetWorthHistory(int months) async {
    final accounts = await _accountRepo.getAllAccounts();
    final now = DateTime.now();

    final currentBalances = <String, int>{};
    for (final a in accounts) {
      currentBalances[a.id] = a.balanceCents;
    }

    // Build month-end dates and fetch all sums concurrently.
    final monthEnds = List.generate(months, (i) {
      return DateTime(now.year, now.month - i + 1, 0, 23, 59, 59, 999);
    });

    final allSums = await Future.wait(
      monthEnds.map((me) =>
          _transactionRepo.getTransactionSumsAfterDate(me.millisecondsSinceEpoch)),
    );

    final snapshots = <NetWorthSnapshot>[];
    for (var i = 0; i < monthEnds.length; i++) {
      final sumsAfter = allSums[i];
      var netWorth = 0;
      for (final a in accounts) {
        final afterMonthEnd = sumsAfter[a.id] ?? 0;
        netWorth += currentBalances[a.id]! - afterMonthEnd;
      }
      snapshots.add(NetWorthSnapshot(month: monthEnds[i], netWorthCents: netWorth));
    }

    return snapshots.reversed.toList();
  }

  /// Monthly income vs expenses for the last [months] months.
  Future<List<MonthlyCashFlow>> getMonthlyCashFlow(int months) async {
    final expenses = await _transactionRepo.getMonthlyExpenseTotals(months);
    final income = await _transactionRepo.getMonthlyIncomeTotals(months);

    final incomeMap = <String, int>{};
    for (final i in income) {
      incomeMap['${i.month.year}-${i.month.month}'] = i.incomeCents;
    }

    return expenses.map((e) {
      final key = '${e.month.year}-${e.month.month}';
      final inc = incomeMap[key] ?? 0;
      final exp = e.expenseCents; // already positive (abs applied)
      final rate = inc > 0 ? (inc - exp) / inc : 0.0;
      return MonthlyCashFlow(
        month: e.month,
        incomeCents: inc,
        expenseCents: exp,
        savingsRate: rate,
      );
    }).toList();
  }

  /// Current month's savings rate as a fraction (0.18 = 18%).
  /// Returns 0.0 if no income this month.
  Future<double> getCurrentSavingsRate() async {
    final now = DateTime.now();
    final monthStart = now.startOfMonth.millisecondsSinceEpoch;
    final monthEnd = now.endOfMonth.millisecondsSinceEpoch;

    final income = await _transactionRepo.getTotalIncome(monthStart, monthEnd);
    final expenses =
        await _transactionRepo.getTotalExpenses(monthStart, monthEnd);

    if (income <= 0) return 0.0;
    return (income + expenses) / income;
  }

  /// Top [topN] category spending trends over the last [months] months.
  Future<List<CategoryTrend>> getCategoryTrends(int months, int topN) async {
    final categories = await _categoryRepo.getAllCategories();
    final categoryMap = {for (final c in categories) c.id: c};

    final now = DateTime.now();
    final monthStarts = List.generate(months, (i) {
      return DateTime(now.year, now.month - (months - 1 - i), 1);
    });

    final topCats = await getTopCategorySpending(topN);
    final trackedIds = topCats.map((c) => c.categoryId).toSet();

    final trends = <String, List<({DateTime month, int amountCents})>>{};
    for (final id in trackedIds) {
      trends[id] = [];
    }

    for (final monthStart in monthStarts) {
      final monthEnd =
          DateTime(monthStart.year, monthStart.month + 1, 0, 23, 59, 59, 999);
      final txns = await _transactionRepo.getTransactionsByDateRange(
        monthStart.millisecondsSinceEpoch,
        monthEnd.millisecondsSinceEpoch,
      );

      final monthTotals = <String, int>{};
      for (final t in txns) {
        if (t.amountCents >= 0 || t.categoryId == null) continue;
        final cat = categoryMap[t.categoryId!];
        final parentCat =
            cat?.parentId != null ? categoryMap[cat!.parentId] : null;
        final displayId = (parentCat ?? cat)?.id ?? t.categoryId!;
        if (trackedIds.contains(displayId)) {
          monthTotals[displayId] =
              (monthTotals[displayId] ?? 0) + t.amountCents.abs();
        }
      }

      for (final id in trackedIds) {
        trends[id]!
            .add((month: monthStart, amountCents: monthTotals[id] ?? 0));
      }
    }

    return topCats.map((cat) {
      return CategoryTrend(
        categoryId: cat.categoryId,
        categoryName: cat.categoryName,
        color: cat.color,
        monthlyAmounts: trends[cat.categoryId] ?? [],
      );
    }).toList();
  }
}
