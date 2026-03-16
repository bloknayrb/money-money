import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../data/local/database/app_database.dart';
import '../../../data/repositories/budget_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/insight_repository.dart';
import '../../../data/repositories/recurring_transaction_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../budgets/budget_spending_service.dart';

const _uuid = Uuid();

/// Generates alerts as Insight records based on budgets, bills, and spending.
class AlertService {
  AlertService({
    required InsightRepository insightRepo,
    required BudgetRepository budgetRepo,
    required BudgetSpendingService budgetSpendingService,
    required RecurringTransactionRepository recurringRepo,
    required TransactionRepository transactionRepo,
    required CategoryRepository categoryRepo,
  })  : _insightRepo = insightRepo,
        _budgetRepo = budgetRepo,
        _budgetSpendingService = budgetSpendingService,
        _recurringRepo = recurringRepo,
        _transactionRepo = transactionRepo,
        _categoryRepo = categoryRepo;

  final InsightRepository _insightRepo;
  final BudgetRepository _budgetRepo;
  final BudgetSpendingService _budgetSpendingService;
  final RecurringTransactionRepository _recurringRepo;
  final TransactionRepository _transactionRepo;
  final CategoryRepository _categoryRepo;

  /// Run all alert checks. Returns total alerts generated.
  Future<int> runAllChecks() async {
    var generated = 0;
    try {
      generated += await checkBudgetThresholds();
    } catch (e) {
      if (kDebugMode) debugPrint('AlertService: budget check failed: $e');
    }
    try {
      generated += await checkUpcomingBills();
    } catch (e) {
      if (kDebugMode) debugPrint('AlertService: bill check failed: $e');
    }
    try {
      generated += await checkSpendingAnomalies();
    } catch (e) {
      if (kDebugMode) debugPrint('AlertService: anomaly check failed: $e');
    }
    return generated;
  }

  /// Check if any budget has exceeded its alert threshold.
  Future<int> checkBudgetThresholds() async {
    final budgets = await _budgetRepo.getAllBudgets();
    final now = DateTime.now().millisecondsSinceEpoch;
    final active =
        budgets.where((b) => b.endDate == null || b.endDate! >= now).toList();
    if (active.isEmpty) return 0;

    final withSpending =
        await _budgetSpendingService.getBudgetsWithSpending(active);

    final categories = await _categoryRepo.getAllCategories();
    final categoryNames = {for (final c in categories) c.id: c.name};

    final sevenDaysAgo =
        DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    var generated = 0;

    for (final bws in withSpending) {
      if (bws.percentage < bws.budget.alertThreshold) continue;

      final catName =
          categoryNames[bws.budget.categoryId] ?? bws.budget.categoryId;
      final isOver = bws.percentage >= 1.0;
      final pctStr = '${(bws.percentage * 100).round()}%';
      final title = isOver
          ? '$catName budget exceeded'
          : '$catName budget at $pctStr';

      if (await _insightRepo.hasRecentInsight(title, sevenDaysAgo)) continue;

      await _insightRepo.insertInsight(InsightsCompanion(
        id: Value(_uuid.v4()),
        title: Value(title),
        description: Value(
          '${bws.spentCents.toCurrency()} spent of '
          '${bws.budget.amountCents.toCurrency()} '
          '${bws.budget.periodType} budget.',
        ),
        insightType: const Value('budget'),
        severity: Value(isOver ? 'alert' : 'warning'),
        isRead: const Value(false),
        isDismissed: const Value(false),
        createdAt: Value(DateTime.now().millisecondsSinceEpoch),
        expiresAt: Value(DateTime.now()
            .add(const Duration(days: 7))
            .millisecondsSinceEpoch),
      ));
      generated++;
    }
    return generated;
  }

  /// Check for upcoming bills within the next 3 days.
  Future<int> checkUpcomingBills({int daysAhead = 3}) async {
    final recurring = await _recurringRepo.getActiveRecurring();
    final now = DateTime.now();
    final cutoff =
        now.add(Duration(days: daysAhead)).millisecondsSinceEpoch;
    final threeDaysAgo =
        now.subtract(const Duration(days: 3)).millisecondsSinceEpoch;

    var generated = 0;

    for (final r in recurring) {
      if (r.nextExpectedDate > cutoff) continue;
      if (r.nextExpectedDate < now.millisecondsSinceEpoch) continue;

      final daysUntil =
          ((r.nextExpectedDate - now.millisecondsSinceEpoch) /
                  (1000 * 60 * 60 * 24))
              .ceil();
      final dayStr = daysUntil == 0
          ? 'today'
          : daysUntil == 1
              ? 'tomorrow'
              : 'in $daysUntil days';
      final title = '${r.payee} due $dayStr';

      if (await _insightRepo.hasRecentInsight(title, threeDaysAgo)) continue;

      await _insightRepo.insertInsight(InsightsCompanion(
        id: Value(_uuid.v4()),
        title: Value(title),
        description: Value(
          '${r.amountCents.abs().toCurrency()} '
          '${r.isSubscription ? 'subscription' : 'payment'} '
          'expected $dayStr.',
        ),
        insightType: const Value('general'),
        severity: const Value('info'),
        isRead: const Value(false),
        isDismissed: const Value(false),
        createdAt: Value(DateTime.now().millisecondsSinceEpoch),
        expiresAt: Value(DateTime.now()
            .add(Duration(days: daysAhead + 1))
            .millisecondsSinceEpoch),
      ));
      generated++;
    }
    return generated;
  }

  /// Detect spending anomalies: categories where this week > 1.5x weekly avg.
  Future<int> checkSpendingAnomalies() async {
    final now = DateTime.now();
    final weekStart =
        now.subtract(Duration(days: now.weekday - 1));
    final fourWeeksAgo = weekStart.subtract(const Duration(days: 28));

    // Current week spending
    final currentWeekTxns = await _transactionRepo.getTransactionsByDateRange(
      DateTime(weekStart.year, weekStart.month, weekStart.day)
          .millisecondsSinceEpoch,
      now.millisecondsSinceEpoch,
    );

    // Last 4 weeks spending
    final prevTxns = await _transactionRepo.getTransactionsByDateRange(
      DateTime(fourWeeksAgo.year, fourWeeksAgo.month, fourWeeksAgo.day)
          .millisecondsSinceEpoch,
      DateTime(weekStart.year, weekStart.month, weekStart.day)
          .millisecondsSinceEpoch,
    );

    final categories = await _categoryRepo.getAllCategories();
    final categoryMap = {for (final c in categories) c.id: c};
    final categoryNames = {for (final c in categories) c.id: c.name};

    // Aggregate by parent category
    String resolveParent(String? catId) {
      if (catId == null) return 'uncategorized';
      final cat = categoryMap[catId];
      if (cat?.parentId != null) return cat!.parentId!;
      return catId;
    }

    final currentByCategory = <String, int>{};
    for (final t in currentWeekTxns) {
      if (t.amountCents >= 0) continue;
      final key = resolveParent(t.categoryId);
      currentByCategory[key] =
          (currentByCategory[key] ?? 0) + t.amountCents.abs();
    }

    final prevByCategory = <String, int>{};
    for (final t in prevTxns) {
      if (t.amountCents >= 0) continue;
      final key = resolveParent(t.categoryId);
      prevByCategory[key] =
          (prevByCategory[key] ?? 0) + t.amountCents.abs();
    }

    final sevenDaysAgo =
        now.subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    var generated = 0;

    for (final entry in currentByCategory.entries) {
      final weeklyAvg = (prevByCategory[entry.key] ?? 0) / 4;
      if (weeklyAvg <= 0 || entry.value <= weeklyAvg * 1.5) continue;
      // Minimum threshold: only alert if difference > $25
      if (entry.value - weeklyAvg < 2500) continue;

      final catName = categoryNames[entry.key] ?? 'Uncategorized';
      final multiplier = (entry.value / weeklyAvg).toStringAsFixed(1);
      final title = '$catName spending spike';

      if (await _insightRepo.hasRecentInsight(title, sevenDaysAgo)) continue;

      await _insightRepo.insertInsight(InsightsCompanion(
        id: Value(_uuid.v4()),
        title: Value(title),
        description: Value(
          '${entry.value.toCurrency()} this week — '
          '${multiplier}x your weekly average of '
          '${weeklyAvg.round().toCurrency()}.',
        ),
        insightType: const Value('spending'),
        severity: const Value('warning'),
        isRead: const Value(false),
        isDismissed: const Value(false),
        createdAt: Value(DateTime.now().millisecondsSinceEpoch),
        expiresAt: Value(now
            .add(const Duration(days: 7))
            .millisecondsSinceEpoch),
      ));
      generated++;
    }
    return generated;
  }
}
