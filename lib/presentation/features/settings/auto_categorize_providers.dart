import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/local/database/models.dart';
import '../../../domain/usecases/categorize/rule_suggestion_service.dart';

/// Watch all auto-categorization rules.
final autoCategorizeRulesProvider =
    StreamProvider.autoDispose<List<AutoCategorizeRule>>((ref) {
  return ref.watch(autoCategorizeRepositoryProvider).watchAllRules();
});

/// Current pending rule suggestions derived from recent corrections.
/// `autoDispose` so dismissing/accepting refreshes naturally when the
/// banner is rebuilt; consumers call `ref.invalidate(ruleSuggestionsProvider)`
/// after accept/dismiss to refresh immediately.
final ruleSuggestionsProvider =
    FutureProvider.autoDispose<List<SuggestedRule>>((ref) {
  return ref.watch(ruleSuggestionServiceProvider).getSuggestions();
});
