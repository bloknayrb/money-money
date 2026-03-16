import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/usecases/forecasting/cash_flow_forecast_service.dart';

final cashFlowForecastServiceProvider =
    Provider<CashFlowForecastService>((ref) {
  return CashFlowForecastService();
});

/// Projected cash flow for the next 90 days.
final cashFlowForecastProvider =
    FutureProvider.autoDispose<CashFlowForecast>((ref) async {
  final service = ref.watch(cashFlowForecastServiceProvider);
  final accountRepo = ref.watch(accountRepositoryProvider);
  final recurringRepo = ref.watch(recurringTransactionRepositoryProvider);
  final accounts = await accountRepo.getAllAccounts();
  final recurring = await recurringRepo.getActiveRecurring();
  return service.forecast(accounts: accounts, recurring: recurring);
});
