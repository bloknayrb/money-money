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

  final results = <BudgetWithSpent>[];

  final categoryRepo = ref.watch(categoryRepositoryProvider);

  for (final budget in budgets) {
    final isMonthly = budget.periodType == 'monthly';
    final start = isMonthly ? monthStart : yearStart;
    final end = isMonthly ? monthEnd : yearEnd;

    // Include subcategories: budgets target parent categories but
    // transactions are assigned to subcategories.
    final subcategories =
        await categoryRepo.getSubcategories(budget.categoryId);
    final categoryIds = [
      budget.categoryId,
      ...subcategories.map((c) => c.id),
    ];

    var spentCents = 0;
    for (final catId in categoryIds) {
      final transactions = await transactionRepo.getTransactionsByDateRange(
        start,
        end,
        categoryId: catId,
      );
      spentCents += transactions
          .where((t) => t.amountCents < 0)
          .fold<int>(0, (sum, t) => sum + t.amountCents);
    }
    spentCents = spentCents.abs();

    final percentage =
        budget.amountCents > 0 ? spentCents.toDouble() / budget.amountCents : 0.0;

    results.add(BudgetWithSpent(
      budget: budget,
      spentCents: spentCents,
      percentage: percentage,
    ));
  }

  return results;
});
