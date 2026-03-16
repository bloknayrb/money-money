import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/usecases/debt/debt_payoff_service.dart';

final debtPayoffServiceProvider = Provider<DebtPayoffService>((ref) {
  return DebtPayoffService();
});

/// Extra monthly payment the user wants to apply (above minimums).
final extraPaymentProvider = StateProvider<int>((ref) => 0);

/// Selected strategy for display.
final selectedStrategyProvider =
    StateProvider<DebtStrategy>((ref) => DebtStrategy.avalanche);

/// Debt info from liability accounts + loan params.
final debtInfoListProvider =
    FutureProvider.autoDispose<List<DebtInfo>>((ref) async {
  final accountRepo = ref.watch(accountRepositoryProvider);
  final loanParamsRepo = ref.watch(loanParamsRepositoryProvider);
  final accounts = await accountRepo.getAllAccounts();

  final liabilities = accounts.where((a) => !a.isAsset).toList();
  final debts = <DebtInfo>[];

  for (final account in liabilities) {
    final params = await loanParamsRepo.getLoanParams(account.id);
    debts.add(DebtInfo(
      accountId: account.id,
      name: account.name,
      balanceCents: account.balanceCents.abs(),
      interestRateBps: params?.interestRateBps ?? 0,
      minimumPaymentCents: params?.monthlyPaymentCents ?? 0,
    ));
  }

  return debts;
});

/// Payoff plan for the selected strategy.
final debtPayoffPlanProvider =
    FutureProvider.autoDispose<DebtPayoffPlan?>((ref) async {
  final debts = await ref.watch(debtInfoListProvider.future);
  if (debts.isEmpty) return null;

  final service = ref.watch(debtPayoffServiceProvider);
  final strategy = ref.watch(selectedStrategyProvider);
  final extra = ref.watch(extraPaymentProvider);

  return service.calculate(
    debts: debts,
    extraMonthlyPaymentCents: extra,
    strategy: strategy,
  );
});

/// Comparison: both strategies side by side.
final debtComparisonProvider =
    FutureProvider.autoDispose<({DebtPayoffPlan snowball, DebtPayoffPlan avalanche})?>((ref) async {
  final debts = await ref.watch(debtInfoListProvider.future);
  if (debts.isEmpty) return null;

  final service = ref.watch(debtPayoffServiceProvider);
  final extra = ref.watch(extraPaymentProvider);

  final snowball = service.calculate(
    debts: debts,
    extraMonthlyPaymentCents: extra,
    strategy: DebtStrategy.snowball,
  );
  final avalanche = service.calculate(
    debts: debts,
    extraMonthlyPaymentCents: extra,
    strategy: DebtStrategy.avalanche,
  );

  return (snowball: snowball, avalanche: avalanche);
});
