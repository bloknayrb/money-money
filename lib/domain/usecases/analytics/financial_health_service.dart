import 'package:flutter/foundation.dart';

import '../../../core/extensions/money_extensions.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/budget_repository.dart';
import '../../../data/repositories/goal_repository.dart';
import '../../../data/repositories/recurring_transaction_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../budgets/budget_spending_service.dart';
import 'health_models.dart';
import 'spending_analytics_service.dart';

export 'health_models.dart';

/// Computes a 0-100 financial health score from 6 weighted pillars.
class FinancialHealthService {
  FinancialHealthService({
    required AccountRepository accountRepo,
    required TransactionRepository transactionRepo,
    required BudgetSpendingService budgetSpendingService,
    required BudgetRepository budgetRepo,
    required RecurringTransactionRepository recurringRepo,
    required GoalRepository goalRepo,
    required SpendingAnalyticsService analyticsService,
  })  : _accountRepo = accountRepo,
        _transactionRepo = transactionRepo,
        _budgetSpendingService = budgetSpendingService,
        _budgetRepo = budgetRepo,
        _recurringRepo = recurringRepo,
        _goalRepo = goalRepo,
        _analyticsService = analyticsService;

  final AccountRepository _accountRepo;
  final TransactionRepository _transactionRepo;
  final BudgetSpendingService _budgetSpendingService;
  final BudgetRepository _budgetRepo;
  final RecurringTransactionRepository _recurringRepo;
  final GoalRepository _goalRepo;
  final SpendingAnalyticsService _analyticsService;

  Future<FinancialHealthScore> calculateScore() async {
    final pillars = <HealthPillar>[];

    pillars.add(await _safeCalc('Emergency Fund', 0.20, _calcEmergencyFund));
    pillars.add(await _safeCalc('Debt-to-Income', 0.20, _calcDebtToIncome));
    pillars.add(await _safeCalc('Savings Rate', 0.20, _calcSavingsRate));
    pillars.add(await _safeCalc('Budget Adherence', 0.15, _calcBudgetAdherence));
    pillars.add(await _safeCalc('Net Worth Trend', 0.15, _calcNetWorthTrend));
    pillars.add(
        await _safeCalc('Retirement Readiness', 0.10, _calcRetirementReadiness));

    // Calculate weighted score, redistributing unavailable pillar weights
    final available = pillars.where((p) => p.status != 'unavailable').toList();
    final totalWeight = available.fold<double>(0, (s, p) => s + p.weight);
    final overallScore = totalWeight > 0
        ? available.fold<double>(
                0, (s, p) => s + p.score * (p.weight / totalWeight))
            .round()
        : 0;

    List<PriorityLadderStep> allSteps;
    try {
      allSteps = await _buildPriorityLadder();
    } catch (e) {
      if (kDebugMode) debugPrint('HealthService: priority ladder failed: $e');
      allSteps = [];
    }
    final currentStep =
        allSteps.where((s) => s.isCurrent).firstOrNull;

    return FinancialHealthScore(
      overallScore: overallScore.clamp(0, 100),
      pillars: pillars,
      currentStep: currentStep,
      allSteps: allSteps,
    );
  }

  Future<HealthPillar> _safeCalc(
    String name,
    double weight,
    Future<HealthPillar> Function(double weight) calc,
  ) async {
    try {
      return await calc(weight);
    } catch (e) {
      if (kDebugMode) debugPrint('HealthService: $name failed: $e');
      return HealthPillar(
        name: name,
        score: 0,
        weight: weight,
        status: 'unavailable',
        nextAction: 'Unable to calculate',
      );
    }
  }

  Future<HealthPillar> _calcEmergencyFund(double weight) async {
    final accounts = await _accountRepo.getAllAccounts();
    final liquidBalance = accounts
        .where((a) => a.accountType == 'checking' || a.accountType == 'savings')
        .fold<int>(0, (s, a) => s + a.balanceCents);

    // Estimate monthly essential expenses from recurring non-subscriptions
    final recurring = await _recurringRepo.getActiveRecurring();
    final monthlyEssentials = recurring
        .where((r) => !r.isSubscription && r.amountCents < 0)
        .fold<int>(0, (s, r) {
      final monthly = _toMonthlyCents(r.amountCents.abs(), r.frequency);
      return s + monthly;
    });

    // Fallback: use total monthly expenses * 0.6
    final now = DateTime.now();
    final monthStart = now.startOfMonth.millisecondsSinceEpoch;
    final monthEnd = now.endOfMonth.millisecondsSinceEpoch;
    final totalExpenses =
        (await _transactionRepo.getTotalExpenses(monthStart, monthEnd)).abs();
    final essentials =
        monthlyEssentials > 0 ? monthlyEssentials : (totalExpenses * 0.6).round();

    if (essentials <= 0) {
      return HealthPillar(
        name: 'Emergency Fund',
        score: 100,
        weight: weight,
        status: 'excellent',
        nextAction: 'No expenses tracked yet',
      );
    }

    final monthsCovered = liquidBalance / essentials;
    final score = (monthsCovered / 6 * 100).round().clamp(0, 100);
    final status = _statusFromScore(score);

    return HealthPillar(
      name: 'Emergency Fund',
      score: score,
      weight: weight,
      status: status,
      nextAction: monthsCovered >= 6
          ? 'Fully funded'
          : 'Save ${((6 - monthsCovered) * essentials).round().toCurrency()} more',
      detail: '${monthsCovered.toStringAsFixed(1)} months of essential expenses',
    );
  }

  Future<HealthPillar> _calcDebtToIncome(double weight) async {
    final accounts = await _accountRepo.getAllAccounts();
    final nonMortgageDebt = accounts
        .where((a) =>
            !a.isAsset &&
            a.accountType != 'mortgage' &&
            a.accountType != 'real_estate')
        .fold<int>(0, (s, a) => s + a.balanceCents.abs());

    final now = DateTime.now();
    final monthStart = now.startOfMonth.millisecondsSinceEpoch;
    final monthEnd = now.endOfMonth.millisecondsSinceEpoch;
    final monthlyIncome =
        await _transactionRepo.getTotalIncome(monthStart, monthEnd);

    if (monthlyIncome <= 0) {
      return HealthPillar(
        name: 'Debt-to-Income',
        score: nonMortgageDebt == 0 ? 100 : 0,
        weight: weight,
        status: nonMortgageDebt == 0 ? 'excellent' : 'unavailable',
        nextAction:
            nonMortgageDebt == 0 ? 'No non-mortgage debt' : 'No income data',
      );
    }

    final annualIncome = monthlyIncome * 12;
    final dti = nonMortgageDebt / annualIncome;
    // 0% DTI = 100, 40% DTI = 0
    final score = ((1 - dti / 0.4) * 100).round().clamp(0, 100);

    return HealthPillar(
      name: 'Debt-to-Income',
      score: score,
      weight: weight,
      status: _statusFromScore(score),
      nextAction: nonMortgageDebt == 0
          ? 'Debt free'
          : 'Pay down ${nonMortgageDebt.toCurrency()} in non-mortgage debt',
      detail: '${(dti * 100).round()}% debt-to-annual-income',
    );
  }

  Future<HealthPillar> _calcSavingsRate(double weight) async {
    final rate = await _analyticsService.getCurrentSavingsRate();
    // 20% = 100, 0% = 0, negative = 0
    final score = rate >= 0 ? (rate / 0.2 * 100).round().clamp(0, 100) : 0;

    return HealthPillar(
      name: 'Savings Rate',
      score: score,
      weight: weight,
      status: _statusFromScore(score),
      nextAction: rate >= 0.2
          ? 'On track at ${(rate * 100).round()}%'
          : 'Increase savings to 20% of income',
      detail: '${(rate * 100).round()}% of income saved',
    );
  }

  Future<HealthPillar> _calcBudgetAdherence(double weight) async {
    final budgets = await _budgetRepo.getAllBudgets();
    final now = DateTime.now().millisecondsSinceEpoch;
    final active =
        budgets.where((b) => b.endDate == null || b.endDate! >= now).toList();

    if (active.isEmpty) {
      return HealthPillar(
        name: 'Budget Adherence',
        score: 0,
        weight: weight,
        status: 'unavailable',
        nextAction: 'Set up budgets to track adherence',
      );
    }

    final withSpending =
        await _budgetSpendingService.getBudgetsWithSpending(active);
    final avgPct = withSpending.fold<double>(0, (s, b) => s + b.percentage) /
        withSpending.length;
    // 80% or less = 100, 120% or more = 0
    final score = avgPct <= 0.8
        ? 100
        : avgPct >= 1.2
            ? 0
            : ((1.2 - avgPct) / 0.4 * 100).round().clamp(0, 100);

    final overBudget =
        withSpending.where((b) => b.percentage > 1.0).length;

    return HealthPillar(
      name: 'Budget Adherence',
      score: score,
      weight: weight,
      status: _statusFromScore(score),
      nextAction: overBudget > 0
          ? '$overBudget budget${overBudget == 1 ? '' : 's'} over limit'
          : 'All budgets on track',
      detail: '${(avgPct * 100).round()}% average utilization',
    );
  }

  Future<HealthPillar> _calcNetWorthTrend(double weight) async {
    final snapshots = await _analyticsService.getNetWorthHistory(4);
    if (snapshots.length < 2) {
      return HealthPillar(
        name: 'Net Worth Trend',
        score: 50,
        weight: weight,
        status: 'fair',
        nextAction: 'Need more data to assess trend',
      );
    }

    // Count consecutive growing months from the most recent
    var growingMonths = 0;
    for (var i = snapshots.length - 1; i > 0; i--) {
      if (snapshots[i].netWorthCents > snapshots[i - 1].netWorthCents) {
        growingMonths++;
      } else {
        break;
      }
    }

    // 3+ growing months = 100, 0 = 0
    final score = (growingMonths / 3 * 100).round().clamp(0, 100);

    return HealthPillar(
      name: 'Net Worth Trend',
      score: score,
      weight: weight,
      status: _statusFromScore(score),
      nextAction: growingMonths >= 3
          ? 'Growing $growingMonths consecutive months'
          : 'Net worth declined recently',
      detail: '$growingMonths consecutive months of growth',
    );
  }

  Future<HealthPillar> _calcRetirementReadiness(double weight) async {
    final goals = await _goalRepo.watchActiveGoals().first;
    final retirementGoal = goals
        .where((g) => g.goalType == 'retirement')
        .firstOrNull;

    if (retirementGoal == null || retirementGoal.targetAmountCents <= 0) {
      return HealthPillar(
        name: 'Retirement Readiness',
        score: 0,
        weight: weight,
        status: 'unavailable',
        nextAction: 'Set up a retirement goal',
      );
    }

    final progress =
        retirementGoal.currentAmountCents / retirementGoal.targetAmountCents;
    final score = (progress * 100).round().clamp(0, 100);

    return HealthPillar(
      name: 'Retirement Readiness',
      score: score,
      weight: weight,
      status: _statusFromScore(score),
      nextAction: progress >= 1.0
          ? 'On track for retirement'
          : '${retirementGoal.currentAmountCents.toCurrency()} of '
              '${retirementGoal.targetAmountCents.toCurrency()} target',
      detail: '${(progress * 100).round()}% of target',
    );
  }

  Future<List<PriorityLadderStep>> _buildPriorityLadder() async {
    final accounts = await _accountRepo.getAllAccounts();
    final liquidBalance = accounts
        .where((a) => a.accountType == 'checking' || a.accountType == 'savings')
        .fold<int>(0, (s, a) => s + a.balanceCents);

    final has401k =
        accounts.any((a) => a.accountType == '401k');
    final hasHsa = accounts.any((a) => a.accountType == 'hsa');
    final hasIra = accounts.any((a) =>
        a.accountType == 'ira' || a.accountType == 'roth_ira');
    final hasDebt = accounts.any(
        (a) => !a.isAsset && a.accountType != 'mortgage');

    // Estimate monthly expenses for emergency fund sizing
    final now = DateTime.now();
    final monthStart = now.startOfMonth.millisecondsSinceEpoch;
    final monthEnd = now.endOfMonth.millisecondsSinceEpoch;
    final monthlyExpenses =
        (await _transactionRepo.getTotalExpenses(monthStart, monthEnd)).abs();
    final threeMonths = monthlyExpenses * 3;
    final sixMonths = monthlyExpenses * 6;

    final steps = <PriorityLadderStep>[];
    var foundCurrent = false;

    void addStep(int order, String title, String desc, bool complete,
        {double? progress}) {
      final isCurrent = !complete && !foundCurrent;
      if (isCurrent) foundCurrent = true;
      steps.add(PriorityLadderStep(
        order: order,
        title: title,
        description: desc,
        isComplete: complete,
        isCurrent: isCurrent,
        progressPercent: progress,
      ));
    }

    addStep(1, 'Build \$1,000 starter emergency fund',
        'Cash buffer for unexpected expenses', liquidBalance >= 100000,
        progress: (liquidBalance / 100000).clamp(0, 1));
    if (has401k) {
      addStep(2, 'Capture employer 401(k) match',
          'Free money — contribute at least to the match', has401k);
    }
    if (hasDebt) {
      addStep(3, 'Pay off high-rate debt (>6%)',
          'Credit cards and high-rate loans first', !hasDebt);
    }
    addStep(
        4,
        'Build 3-month emergency fund',
        'Cover essential expenses for 3 months',
        monthlyExpenses > 0 && liquidBalance >= threeMonths,
        progress: threeMonths > 0
            ? (liquidBalance / threeMonths).clamp(0, 1)
            : null);
    if (hasHsa) {
      addStep(5, 'Max HSA contributions',
          'Triple tax advantage — best account type available', false);
    }
    if (hasIra) {
      addStep(6, 'Max Roth IRA contributions',
          'Tax-free growth for retirement', false);
    }
    if (has401k) {
      addStep(7, 'Max 401(k) contributions',
          'Additional tax-deferred retirement savings', false);
    }
    addStep(
        8,
        'Build 6-month emergency fund',
        'Full financial safety net',
        monthlyExpenses > 0 && liquidBalance >= sixMonths,
        progress: sixMonths > 0
            ? (liquidBalance / sixMonths).clamp(0, 1)
            : null);
    addStep(9, 'Taxable investing', 'Build wealth beyond tax-advantaged limits',
        false);

    return steps;
  }

  static int _toMonthlyCents(int amountCents, String frequency) {
    switch (frequency) {
      case 'weekly':
        return (amountCents * 52 / 12).round();
      case 'biweekly':
        return (amountCents * 26 / 12).round();
      case 'monthly':
        return amountCents;
      case 'quarterly':
        return (amountCents / 3).round();
      case 'annual':
        return (amountCents / 12).round();
      default:
        return amountCents;
    }
  }

  static String _statusFromScore(int score) {
    if (score >= 80) return 'excellent';
    if (score >= 60) return 'good';
    if (score >= 40) return 'fair';
    return 'poor';
  }
}
