import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/repositories/auto_categorize_repository.dart';
import 'payee_normalization.dart';

/// A pending rule suggestion derived from recent user corrections.
/// One entry per `(normalizedPayee, suggestedCategoryId)` pair with at
/// least 3 corrections in the last 90 days that no existing enabled
/// rule already covers and that the user hasn't dismissed.
class SuggestedRule {
  const SuggestedRule({
    required this.normalizedPayee,
    required this.suggestedCategoryId,
    required this.correctionCount,
    required this.sampleRawPayee,
  });

  /// The payee already passed through [normalizePayee]. Used to write
  /// the rule's `payeeExact` field if the user accepts.
  final String normalizedPayee;

  /// Category the user assigned at least [_minCorrections] times.
  final String suggestedCategoryId;

  /// Number of qualifying corrections in the look-back window.
  final int correctionCount;

  /// A non-normalized payee from one of the qualifying corrections, so
  /// the banner can show the user what their original text looked like
  /// (e.g. `'SQ *PELOTON'` rather than `'PELOTON'`).
  final String sampleRawPayee;
}

/// Aggregates recent user corrections into rule suggestions.
///
/// Surfaces high-confidence patterns the user has reinforced via repeated
/// manual category assignment but hasn't yet captured as a rule. The
/// banner on the rules screen invokes [getSuggestions]; the user can
/// then [acceptSuggestion] (creates a `payeeExact` rule) or
/// [dismissSuggestion] (records the dismissal so the pair never
/// resurfaces from this aggregator).
class RuleSuggestionService {
  RuleSuggestionService(this._autoCatRepo);

  final AutoCategorizeRepository _autoCatRepo;

  static const int minCorrections = 3;
  static const int windowDays = 90;

  /// New-rule priority for accepted suggestions. Lower than seeded
  /// defaults (0-411) so user-curated rules win, but high enough that
  /// `max(existing) + 10` from the manual dialog still places new rules
  /// below this when there are no other user rules.
  static const int suggestedRulePriority = 100;

  /// Compute the current suggestion list. Groups corrections by
  /// `(normalizePayee(payee), newCategoryId)` and surfaces only groups
  /// that:
  /// 1. Have at least [minCorrections] entries in the last [windowDays] days
  /// 2. Are not covered by an enabled rule (`payeeExact` or
  ///    `payeeContains` matching the normalized payee)
  /// 3. Have not been dismissed via [dismissSuggestion]
  ///
  /// Returns suggestions ordered by `correctionCount` descending so
  /// the highest-confidence groups appear first.
  Future<List<SuggestedRule>> getSuggestions() async {
    final corrections =
        await _autoCatRepo.getRecentCorrections(days: windowDays);
    if (corrections.isEmpty) return const [];

    // Group: (normalizedPayee, categoryId) → list of corrections.
    final groups = <String, List<CategorizationCorrection>>{};
    for (final c in corrections) {
      final normalized = normalizePayee(c.payee);
      if (normalized.isEmpty) continue;
      final key = '$normalized|${c.newCategoryId}';
      groups.putIfAbsent(key, () => []).add(c);
    }

    // Filter groups under the minimum count.
    final qualifying = groups.entries
        .where((entry) => entry.value.length >= minCorrections)
        .toList();
    if (qualifying.isEmpty) return const [];

    // Exclude pairs already covered by an enabled rule.
    final enabledRules = await _autoCatRepo.getEnabledRules();
    bool isCovered(String normalizedPayee, String categoryId) {
      for (final r in enabledRules) {
        if (r.categoryId != categoryId) continue;
        final pe = r.payeeExact;
        if (pe != null && pe.toUpperCase() == normalizedPayee) return true;
        final pc = r.payeeContains;
        if (pc != null && normalizedPayee.contains(pc.toUpperCase())) {
          return true;
        }
      }
      return false;
    }

    // Exclude dismissed pairs.
    final dismissed = await _autoCatRepo.getDismissedSuggestions();
    final dismissedSet = {
      for (final d in dismissed) '${d.payeeNormalized}|${d.categoryId}',
    };

    final suggestions = <SuggestedRule>[];
    for (final entry in qualifying) {
      final parts = entry.key.split('|');
      final normalizedPayee = parts[0];
      final categoryId = parts[1];
      if (dismissedSet.contains(entry.key)) continue;
      if (isCovered(normalizedPayee, categoryId)) continue;
      suggestions.add(SuggestedRule(
        normalizedPayee: normalizedPayee,
        suggestedCategoryId: categoryId,
        correctionCount: entry.value.length,
        sampleRawPayee: entry.value.first.payee,
      ));
    }
    suggestions.sort(
      (a, b) => b.correctionCount.compareTo(a.correctionCount),
    );
    return suggestions;
  }

  /// Create a `payeeExact` rule matching the suggested payee+category.
  /// The new rule lands at [suggestedRulePriority]. Caller is responsible
  /// for invalidating any cached rules list provider after this completes.
  Future<void> acceptSuggestion(SuggestedRule s) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _autoCatRepo.insertRule(AutoCategorizeRulesCompanion.insert(
      id: const Uuid().v4(),
      name: 'Suggested: ${s.normalizedPayee}',
      priority: suggestedRulePriority,
      payeeExact: Value(s.normalizedPayee),
      categoryId: s.suggestedCategoryId,
      createdAt: now,
      updatedAt: now,
    ));
  }

  /// Record that the user dismissed this suggestion. The pair won't
  /// resurface in [getSuggestions] even if more matching corrections
  /// accumulate.
  Future<void> dismissSuggestion(SuggestedRule s) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _autoCatRepo.insertDismissedSuggestion(
      DismissedRuleSuggestionsCompanion.insert(
        payeeNormalized: s.normalizedPayee,
        categoryId: s.suggestedCategoryId,
        dismissedAt: now,
      ),
    );
  }
}
