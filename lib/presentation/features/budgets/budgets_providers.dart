import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../data/local/database/app_database.dart';

/// Watch all active budgets.
final budgetsProvider = StreamProvider.autoDispose<List<Budget>>((ref) {
  return ref.watch(budgetRepositoryProvider).watchActiveBudgets();
});

/// Get a single budget by ID.
final budgetByIdProvider =
    FutureProvider.autoDispose.family<Budget?, String>((ref, id) {
  return ref.watch(budgetRepositoryProvider).getBudgetById(id);
});

/// Budget with calculated spending data for the current period.
class BudgetWithSpent {
  final Budget budget;
  final int spentCents;
  final double percentage;

  const BudgetWithSpent({
    required this.budget,
    required this.spentCents,
    required this.percentage,
  });
}

/// Provides a list of budgets with their current-period spending amounts.
///
/// For monthly budgets, the period is the current calendar month.
/// For annual budgets, the period is the current calendar year.
/// Expenses are stored as negative cents, so we sum and negate to get a
/// positive "spent" value.
final budgetsWithSpentProvider =
    FutureProvider.autoDispose<List<BudgetWithSpent>>((ref) async {
  final budgets = await ref.watch(budgetsProvider.future);
  final transactionRepo = ref.watch(transactionRepositoryProvider);

  final now = DateTime.now();
  final monthStart = now.startOfMonth.millisecondsSinceEpoch;
  final monthEnd = now.endOfMonth.millisecondsSinceEpoch;
  final yearStart = DateTime(now.year, 1, 1).millisecondsSinceEpoch;
  final yearEnd =
      DateTime(now.year, 12, 31, 23, 59, 59, 999).millisecondsSinceEpoch;

  final categoryRepo = ref.watch(categoryRepositoryProvider);

  // Collect all category IDs per budget (parent + subcategories)
  final budgetCategoryIds = <Budget, List<String>>{};
  final allMonthlyIds = <String>{};
  final allAnnualIds = <String>{};

  for (final budget in budgets) {
    final subcategories =
        await categoryRepo.getSubcategories(budget.categoryId);
    final ids = [budget.categoryId, ...subcategories.map((c) => c.id)];
    budgetCategoryIds[budget] = ids;
    if (budget.periodType == 'monthly') {
      allMonthlyIds.addAll(ids);
    } else {
      allAnnualIds.addAll(ids);
    }
  }

  // Issue at most 2 queries instead of N*M
  final monthlySpending = allMonthlyIds.isNotEmpty
      ? await transactionRepo.getTotalExpensesByCategoryIds(
          monthStart, monthEnd, allMonthlyIds.toList())
      : <String, int>{};
  final annualSpending = allAnnualIds.isNotEmpty
      ? await transactionRepo.getTotalExpensesByCategoryIds(
          yearStart, yearEnd, allAnnualIds.toList())
      : <String, int>{};

  // Map back per budget
  final results = <BudgetWithSpent>[];
  for (final budget in budgets) {
    final isMonthly = budget.periodType == 'monthly';
    final spending = isMonthly ? monthlySpending : annualSpending;
    final ids = budgetCategoryIds[budget]!;
    var spentCents = 0;
    for (final id in ids) {
      spentCents += (spending[id] ?? 0).abs();
    }

    final percentage = budget.amountCents > 0
        ? spentCents.toDouble() / budget.amountCents
        : 0.0;

    results.add(BudgetWithSpent(
      budget: budget,
      spentCents: spentCents,
      percentage: percentage,
    ));
  }

  return results;
});
