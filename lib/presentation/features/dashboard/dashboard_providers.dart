import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/local/database/models.dart';
import '../../../domain/usecases/analytics/spending_analytics_service.dart';

export '../../../domain/usecases/analytics/analytics_models.dart';

// =============================================================================
// UNREAD INSIGHTS COUNT (Phase B: Smart Alerts)
// =============================================================================

/// Count of unread, active insights for badge display.
final unreadInsightsCountProvider = StreamProvider.autoDispose<int>((ref) {
  final repo = ref.watch(insightRepositoryProvider);
  return repo.watchUnreadInsights().map((list) => list.length);
});

// =============================================================================
// SPENDING HISTORY (Feature #34)
// =============================================================================

/// Monthly spending totals for the last 6 months.
final monthlySpendingHistoryProvider =
    FutureProvider.autoDispose<List<MonthlySpending>>((ref) async {
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final totals = await transactionRepo.getMonthlyExpenseTotals(6);
  return totals
      .map((t) => MonthlySpending(month: t.month, expenseCents: t.expenseCents))
      .toList();
});

// =============================================================================
// SPENDING BY CATEGORY (Feature #34)
// =============================================================================

/// Top 8 spending categories for the current month.
final spendingByCategoryProvider =
    FutureProvider.autoDispose<List<CategorySpending>>((ref) async {
  final service = ref.watch(spendingAnalyticsServiceProvider);
  return service.getTopCategorySpending(8);
});

// =============================================================================
// NET WORTH HISTORY (Feature #35)
// =============================================================================

/// Net worth at each month-end for the last 6 months.
final netWorthHistoryProvider =
    FutureProvider.autoDispose<List<NetWorthSnapshot>>((ref) async {
  final service = ref.watch(spendingAnalyticsServiceProvider);
  return service.getNetWorthHistory(6);
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
