import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/usecases/analytics/analytics_models.dart';

/// Monthly cash flow (income vs expenses) for the last 6 months.
final monthlyCashFlowProvider =
    FutureProvider.autoDispose<List<MonthlyCashFlow>>((ref) async {
  final service = ref.watch(spendingAnalyticsServiceProvider);
  return service.getMonthlyCashFlow(6);
});

/// Current month's savings rate as a fraction (e.g., 0.18 = 18%).
final savingsRateProvider = FutureProvider.autoDispose<double>((ref) async {
  final service = ref.watch(spendingAnalyticsServiceProvider);
  return service.getCurrentSavingsRate();
});

/// Top 8 category spending trends over the last 6 months.
final categoryTrendsProvider =
    FutureProvider.autoDispose<List<CategoryTrend>>((ref) async {
  final service = ref.watch(spendingAnalyticsServiceProvider);
  return service.getCategoryTrends(6, 8);
});
