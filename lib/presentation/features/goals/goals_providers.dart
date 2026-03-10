import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/local/database/app_database.dart';
import '../../../domain/usecases/retirement/monte_carlo_service.dart';

/// Watch active (incomplete) goals ordered by target date.
final goalsProvider = StreamProvider.autoDispose<List<Goal>>((ref) {
  return ref.watch(goalRepositoryProvider).watchActiveGoals();
});

/// Watch all goals including completed ones.
final allGoalsProvider = StreamProvider.autoDispose<List<Goal>>((ref) {
  return ref.watch(goalRepositoryProvider).watchAllGoals();
});

/// Get a single goal by ID.
final goalByIdProvider = FutureProvider.autoDispose.family<Goal?, String>((ref, id) {
  return ref.watch(goalRepositoryProvider).getGoalById(id);
});

/// Watch a single goal reactively (for detail screen).
final goalStreamProvider = StreamProvider.autoDispose.family<Goal?, String>((ref, id) {
  return ref.watch(goalRepositoryProvider).watchGoalById(id);
});

/// Monte Carlo simulation results for a retirement goal.
/// Runs off the UI thread via Isolate.run().
/// Only recomputes when retirement-specific fields change (not name, color, etc.).
final monteCarloProvider =
    FutureProvider.autoDispose.family<MonteCarloResult?, String>((ref, goalId) async {
  final fields = await ref.watch(
    goalStreamProvider(goalId).selectAsync((goal) {
      if (goal == null) return null;
      return (
        goal.currentAmountCents,
        goal.monthlyContributionCents,
        goal.annualReturnBps,
        goal.annualVolatilityBps,
        goal.retirementYear,
      );
    }),
  );

  if (fields == null) return null;
  final (balance, contribution, returnBps, volBps, year) = fields;
  if (contribution == null || returnBps == null || volBps == null || year == null) {
    return null;
  }

  final input = MonteCarloInput(
    currentBalanceCents: balance,
    monthlyContributionCents: contribution,
    annualReturn: returnBps / 10000.0,
    annualVolatility: volBps / 10000.0,
    yearsToRetirement: year - DateTime.now().year,
  );

  return Isolate.run(() => runMonteCarloSimulation(input));
});
