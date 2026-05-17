import 'package:flutter_test/flutter_test.dart';
import 'package:moneymoney/data/local/database/app_database.dart';
import 'package:moneymoney/domain/usecases/categorize/rule_conflicts.dart';

AutoCategorizeRule _rule({
  required String id,
  String? payeeContains,
  String? payeeExact,
  required String categoryId,
  required int priority,
}) {
  return AutoCategorizeRule(
    id: id,
    name: 'rule-$id',
    priority: priority,
    payeeContains: payeeContains,
    payeeExact: payeeExact,
    amountMinCents: null,
    amountMaxCents: null,
    accountId: null,
    categoryId: categoryId,
    accountType: null,
    isEnabled: true,
    createdAt: 0,
    updatedAt: 0,
  );
}

void main() {
  group('detectRuleConflicts', () {
    test('returns empty when no existing rules', () {
      final conflicts = detectRuleConflicts(
        editingRuleId: null,
        payeeContains: 'AMAZON',
        payeeExact: null,
        categoryId: 'cat-shopping',
        priority: 100,
        existingRules: const [],
      );
      expect(conflicts, isEmpty);
    });

    test('returns empty when proposed rule has no payee pattern', () {
      final conflicts = detectRuleConflicts(
        editingRuleId: null,
        payeeContains: null,
        payeeExact: null,
        categoryId: 'cat-shopping',
        priority: 100,
        existingRules: [
          _rule(
            id: 'q',
            payeeContains: 'AMAZON',
            categoryId: 'cat-other',
            priority: 50,
          ),
        ],
      );
      expect(conflicts, isEmpty);
    });

    test('same payeeContains pattern with same category — no conflict', () {
      final conflicts = detectRuleConflicts(
        editingRuleId: null,
        payeeContains: 'AMAZON',
        payeeExact: null,
        categoryId: 'cat-shopping',
        priority: 100,
        existingRules: [
          _rule(
            id: 'q',
            payeeContains: 'AMAZON',
            categoryId: 'cat-shopping',
            priority: 50,
          ),
        ],
      );
      expect(conflicts, isEmpty);
    });

    test('same payeeContains pattern with different category — warns', () {
      final conflicts = detectRuleConflicts(
        editingRuleId: null,
        payeeContains: 'amazon', // case-insensitive
        payeeExact: null,
        categoryId: 'cat-shopping',
        priority: 100,
        existingRules: [
          _rule(
            id: 'q',
            payeeContains: 'AMAZON',
            categoryId: 'cat-groceries',
            priority: 50,
          ),
        ],
      );
      expect(conflicts.length, equals(1));
      expect(conflicts.first.kind,
          equals(RuleConflictKind.samePatternDifferentCategory));
    });

    test('this rule shadows a more-specific existing rule with same priority',
        () {
      // New rule contains "AMAZON" priority 10. Existing "AMAZON FRESH" priority 50.
      // New rule's match set strictly contains existing's, and new has lower
      // priority number → it fires first → existing never runs.
      final conflicts = detectRuleConflicts(
        editingRuleId: null,
        payeeContains: 'AMAZON',
        payeeExact: null,
        categoryId: 'cat-shopping',
        priority: 10,
        existingRules: [
          _rule(
            id: 'q',
            payeeContains: 'AMAZON FRESH',
            categoryId: 'cat-groceries',
            priority: 50,
          ),
        ],
      );
      expect(conflicts.length, equals(1));
      expect(conflicts.first.kind, equals(RuleConflictKind.shadowsOther));
    });

    test('this rule is shadowed by a more-general existing rule', () {
      // New rule contains "AMAZON FRESH" priority 50. Existing "AMAZON" priority 10.
      // Existing matches everything new does (and more), and existing fires
      // first → new never runs.
      final conflicts = detectRuleConflicts(
        editingRuleId: null,
        payeeContains: 'AMAZON FRESH',
        payeeExact: null,
        categoryId: 'cat-groceries',
        priority: 50,
        existingRules: [
          _rule(
            id: 'q',
            payeeContains: 'AMAZON',
            categoryId: 'cat-shopping',
            priority: 10,
          ),
        ],
      );
      expect(conflicts.length, equals(1));
      expect(conflicts.first.kind, equals(RuleConflictKind.shadowedByOther));
    });

    test('edit-self does not conflict with self', () {
      final conflicts = detectRuleConflicts(
        editingRuleId: 'q',
        payeeContains: 'AMAZON',
        payeeExact: null,
        categoryId: 'cat-shopping',
        priority: 100,
        existingRules: [
          _rule(
            id: 'q',
            payeeContains: 'AMAZON',
            categoryId: 'cat-groceries',
            priority: 50,
          ),
        ],
      );
      expect(conflicts, isEmpty);
    });

    test('cross-field: new payeeContains "AMAZON" shadows existing exact "AMAZON FRESH"',
        () {
      final conflicts = detectRuleConflicts(
        editingRuleId: null,
        payeeContains: 'AMAZON',
        payeeExact: null,
        categoryId: 'cat-shopping',
        priority: 10,
        existingRules: [
          _rule(
            id: 'q',
            payeeExact: 'AMAZON FRESH',
            categoryId: 'cat-groceries',
            priority: 50,
          ),
        ],
      );
      expect(conflicts.length, equals(1));
      expect(conflicts.first.kind, equals(RuleConflictKind.shadowsOther));
    });

    test('whitespace-only payeeContains is treated as empty (no false matches)',
        () {
      final conflicts = detectRuleConflicts(
        editingRuleId: null,
        payeeContains: '   ',
        payeeExact: null,
        categoryId: 'cat-shopping',
        priority: 100,
        existingRules: [
          _rule(
            id: 'q',
            payeeContains: 'AMAZON',
            categoryId: 'cat-other',
            priority: 50,
          ),
        ],
      );
      expect(conflicts, isEmpty);
    });

    test('rules without payee patterns are skipped (amount/accountType only)',
        () {
      final conflicts = detectRuleConflicts(
        editingRuleId: null,
        payeeContains: 'AMAZON',
        payeeExact: null,
        categoryId: 'cat-shopping',
        priority: 10,
        existingRules: [
          _rule(
            id: 'q-no-payee',
            payeeContains: null,
            payeeExact: null,
            categoryId: 'cat-other',
            priority: 5,
          ),
        ],
      );
      expect(conflicts, isEmpty);
    });
  });
}
