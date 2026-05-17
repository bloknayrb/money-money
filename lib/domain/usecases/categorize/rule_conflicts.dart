import '../../../data/local/database/app_database.dart';

/// Kinds of conflicts that can arise when creating/editing an auto-categorize
/// rule. All conflicts are warnings — save is never blocked.
enum RuleConflictKind {
  /// Another rule has the same effective payee pattern but maps to a
  /// different category. Whichever has lower priority wins, which can
  /// surprise the user.
  samePatternDifferentCategory,

  /// This rule's match set covers another rule's match set, and this rule
  /// has equal-or-higher priority. The other rule would never run.
  shadowsOther,

  /// Another rule's match set covers this rule's match set, and the other
  /// rule has equal-or-higher priority. This rule would never run.
  shadowedByOther,
}

class RuleConflict {
  const RuleConflict({required this.kind, required this.other});
  final RuleConflictKind kind;
  final AutoCategorizeRule other;
}

/// Detect conflicts between a proposed rule and the set of existing rules.
///
/// Only payee-pattern conflicts are detected. Rules with both `payeeExact`
/// and `payeeContains` null (amount-range or account-type only) are skipped
/// — checking those would require modeling the full match space and isn't
/// worth the complexity for a warning-only UI affordance.
///
/// `editingRuleId` is the id of the rule being edited (so self-conflicts
/// are filtered out); null when creating a new rule.
List<RuleConflict> detectRuleConflicts({
  required String? editingRuleId,
  required String? payeeContains,
  required String? payeeExact,
  required String? categoryId,
  required int priority,
  required List<AutoCategorizeRule> existingRules,
}) {
  final rPc = (payeeContains == null || payeeContains.isEmpty)
      ? null
      : payeeContains.toUpperCase();
  final rPe = (payeeExact == null || payeeExact.isEmpty)
      ? null
      : payeeExact.toUpperCase();
  final rEffective = rPe ?? rPc;
  if (rEffective == null || categoryId == null) return const [];

  final conflicts = <RuleConflict>[];

  for (final q in existingRules) {
    if (q.id == editingRuleId) continue;
    final qPc = q.payeeContains?.toUpperCase();
    final qPe = q.payeeExact?.toUpperCase();
    final qEffective = qPe ?? qPc;
    if (qEffective == null) continue;

    if (qEffective == rEffective && q.categoryId != categoryId) {
      conflicts.add(
        RuleConflict(kind: RuleConflictKind.samePatternDifferentCategory, other: q),
      );
      continue;
    }

    if (priority <= q.priority && _aShadowsB(rPc, rPe, qPc, qPe)) {
      conflicts.add(RuleConflict(kind: RuleConflictKind.shadowsOther, other: q));
      continue;
    }

    if (priority >= q.priority && _aShadowsB(qPc, qPe, rPc, rPe)) {
      conflicts.add(
        RuleConflict(kind: RuleConflictKind.shadowedByOther, other: q),
      );
      continue;
    }
  }

  return conflicts;
}

/// Whether rule A's match set strictly contains rule B's match set.
///
/// Case combos:
///   A exact, B exact      → never strict superset (only equal at most)
///   A contains, B contains→ A⊃B iff B's pattern strictly contains A's pattern
///   A contains, B exact   → A⊃B iff B's exact string strictly contains A's contains pattern
///   A exact, B contains   → A⊃B never (B's set is unbounded)
bool _aShadowsB(String? aPc, String? aPe, String? bPc, String? bPe) {
  if (aPe != null) return false;
  if (aPc == null) return false;
  final bStr = bPe ?? bPc;
  if (bStr == null) return false;
  return bStr != aPc && bStr.contains(aPc);
}
