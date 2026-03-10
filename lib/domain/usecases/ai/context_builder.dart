import '../../../core/extensions/money_extensions.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/budget_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/goal_repository.dart';
import '../../../data/repositories/transaction_repository.dart';

/// Assembles a financial context snapshot for LLM prompts.
///
/// Builds a prioritized text summary of the user's financial state.
/// Layers are added in priority order and lower-priority layers are dropped
/// if the 2000-token budget is already exhausted.
class ContextBuilder {
  ContextBuilder({
    required this.accountRepo,
    required this.transactionRepo,
    required this.budgetRepo,
    required this.goalRepo,
    required this.categoryRepo,
  });

  final AccountRepository accountRepo;
  final TransactionRepository transactionRepo;
  final BudgetRepository budgetRepo;
  final GoalRepository goalRepo;
  final CategoryRepository categoryRepo;

  static const _tokenBudget = 2000;

  Future<String> buildContext() async {
    final buffer = StringBuffer('--- FINANCIAL CONTEXT ---\n');
    int tokens = 10;

    // Priority 1: Account summary (always included)
    final accountSection = await _buildAccountSection();
    buffer.write(accountSection);
    tokens += accountSection.length ~/ 4;

    // Priority 2: Recent transactions (always included)
    final txnSection = await _buildTransactionSection();
    buffer.write(txnSection);
    tokens += txnSection.length ~/ 4;

    // Priority 3: Category spending for last 30 days (always included)
    final catSection = await _buildCategorySpendingSection();
    buffer.write(catSection);
    tokens += catSection.length ~/ 4;

    // Priority 4: Active budgets (if room)
    if (tokens < _tokenBudget) {
      final budgetSection = await _buildBudgetSection();
      buffer.write(budgetSection);
      tokens += budgetSection.length ~/ 4;
    }

    // Priority 5: Active goals (if room)
    if (tokens < _tokenBudget) {
      final goalSection = await _buildGoalSection();
      buffer.write(goalSection);
    }

    return buffer.toString();
  }

  Future<String> _buildAccountSection() async {
    final accounts = await accountRepo.getAllAccounts();
    if (accounts.isEmpty) return '';

    final assets = accounts.where((a) => a.isAsset).toList()
      ..sort((a, b) => b.balanceCents.compareTo(a.balanceCents));
    final liabilities = accounts.where((a) => !a.isAsset).toList()
      ..sort((a, b) => b.balanceCents.compareTo(a.balanceCents));

    final totalAssets = assets.fold<int>(0, (s, a) => s + a.balanceCents);
    final totalLiabilities =
        liabilities.fold<int>(0, (s, a) => s + a.balanceCents);
    final netWorth = totalAssets - totalLiabilities.abs();

    final buf = StringBuffer('\nACCOUNTS:\n');
    buf.writeln('Net Worth: ${netWorth.toCurrency()}');

    for (final a in accounts.take(10)) {
      final sign = a.isAsset ? '' : '-';
      buf.writeln(
          '  ${a.name} (${a.accountType}): $sign${a.balanceCents.abs().toCurrency()}');
    }
    if (accounts.length > 10) {
      buf.writeln('  ... and ${accounts.length - 10} more accounts');
    }
    return buf.toString();
  }

  Future<String> _buildTransactionSection() async {
    final txns = await transactionRepo.getRecentTransactions(limit: 20);
    if (txns.isEmpty) return '';

    final buf = StringBuffer('\nRECENT TRANSACTIONS:\n');
    for (final t in txns) {
      final date = DateTime.fromMillisecondsSinceEpoch(t.date);
      final dateStr = '${date.month}/${date.day}';
      final amount = t.amountCents.abs().toCurrency();
      final sign = t.amountCents >= 0 ? '+' : '-';
      buf.writeln('  $dateStr ${t.payee}: $sign$amount');
    }
    return buf.toString();
  }

  Future<String> _buildCategorySpendingSection() async {
    final now = DateTime.now();
    // 30 days ago
    final start = now.subtract(const Duration(days: 30));
    final txns = await transactionRepo.getTransactionsByDateRange(
      start.millisecondsSinceEpoch,
      now.millisecondsSinceEpoch,
    );

    final expenses = txns.where((t) => t.amountCents < 0).toList();
    if (expenses.isEmpty) return '';

    // Aggregate spending by category
    final spendingMap = <String, int>{};
    for (final t in expenses) {
      final key = t.categoryId ?? 'uncategorized';
      spendingMap[key] = (spendingMap[key] ?? 0) + t.amountCents.abs();
    }

    final categories = await categoryRepo.watchAllCategories().first;
    final categoryNames = {for (final c in categories) c.id: c.name};

    final sorted = spendingMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final buf = StringBuffer('\nSPENDING (last 30 days):\n');
    for (final entry in sorted.take(10)) {
      final name = entry.key == 'uncategorized'
          ? 'Uncategorized'
          : categoryNames[entry.key] ?? 'Unknown';
      buf.writeln('  $name: ${entry.value.toCurrency()}');
    }
    return buf.toString();
  }

  Future<String> _buildBudgetSection() async {
    final budgets = await budgetRepo.getAllBudgets();
    if (budgets.isEmpty) return '';

    final now = DateTime.now().millisecondsSinceEpoch;
    final active = budgets
        .where((b) => b.endDate == null || b.endDate! >= now)
        .toList();
    if (active.isEmpty) return '';

    final categories = await categoryRepo.watchAllCategories().first;
    final categoryNames = {for (final c in categories) c.id: c.name};

    final buf = StringBuffer('\nBUDGETS:\n');
    for (final b in active) {
      final name = categoryNames[b.categoryId] ?? b.categoryId;
      buf.writeln('  $name: ${b.amountCents.toCurrency()}/${b.periodType}');
    }
    return buf.toString();
  }

  Future<String> _buildGoalSection() async {
    final goals = await goalRepo.watchActiveGoals().first;
    if (goals.isEmpty) return '';

    final buf = StringBuffer('\nGOALS:\n');
    for (final g in goals) {
      final progress = g.targetAmountCents > 0
          ? (g.currentAmountCents / g.targetAmountCents * 100).round()
          : 0;
      buf.writeln(
          '  ${g.name}: ${g.currentAmountCents.toCurrency()} / ${g.targetAmountCents.toCurrency()} ($progress%)');
      if (g.goalType == 'retirement' && g.retirementYear != null) {
        buf.writeln(
            '    Retirement target: ${g.retirementYear}, ${(g.monthlyContributionCents ?? 0).toCurrency()}/mo contribution');
      }
    }
    return buf.toString();
  }

}
