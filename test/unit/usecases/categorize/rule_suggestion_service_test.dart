import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneymoney/data/local/database/app_database.dart';
import 'package:moneymoney/data/repositories/auto_categorize_repository.dart';
import 'package:moneymoney/domain/usecases/categorize/rule_suggestion_service.dart';

void main() {
  late AppDatabase database;
  late AutoCategorizeRepository repo;
  late RuleSuggestionService service;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repo = AutoCategorizeRepository(database);
    service = RuleSuggestionService(repo);
  });

  tearDown(() async {
    await database.close();
  });

  /// Helper: insert a correction with a known timestamp offset (days back).
  Future<void> insertCorrection({
    required String id,
    required String payee,
    required String categoryId,
    int daysAgo = 1,
  }) async {
    final createdAt = DateTime.now()
        .subtract(Duration(days: daysAgo))
        .millisecondsSinceEpoch;
    await repo.insertCorrection(CategorizationCorrectionsCompanion.insert(
      id: id,
      transactionId: 'txn-$id',
      newCategoryId: categoryId,
      payee: payee,
      createdAt: createdAt,
    ));
  }

  AutoCategorizeRulesCompanion makeRule({
    required String id,
    required String categoryId,
    String? payeeContains,
    String? payeeExact,
    bool isEnabled = true,
    int priority = 100,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return AutoCategorizeRulesCompanion.insert(
      id: id,
      name: 'rule-$id',
      priority: priority,
      categoryId: categoryId,
      createdAt: now,
      updatedAt: now,
      payeeContains: Value(payeeContains),
      payeeExact: Value(payeeExact),
      isEnabled: Value(isEnabled),
    );
  }

  group('getSuggestions', () {
    test('surfaces a (payee, category) pair with >= 3 corrections in window',
        () async {
      // 3 corrections of PELOTON → cat-fitness within 90 days.
      await insertCorrection(
          id: '1', payee: 'PELOTON', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '2', payee: 'PELOTON', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '3', payee: 'PELOTON', categoryId: 'cat-fitness');

      final suggestions = await service.getSuggestions();

      expect(suggestions.length, 1);
      expect(suggestions.first.normalizedPayee, 'PELOTON');
      expect(suggestions.first.suggestedCategoryId, 'cat-fitness');
      expect(suggestions.first.correctionCount, 3);
    });

    test('groups by normalized payee (collapses POS prefixes etc)', () async {
      // Three different raw forms that all normalize to STARBUCKS.
      await insertCorrection(
          id: '1', payee: 'SQ *STARBUCKS', categoryId: 'cat-coffee');
      await insertCorrection(
          id: '2', payee: 'TST*STARBUCKS #1234', categoryId: 'cat-coffee');
      await insertCorrection(
          id: '3', payee: 'STARBUCKS', categoryId: 'cat-coffee');

      final suggestions = await service.getSuggestions();

      expect(suggestions.length, 1);
      expect(suggestions.first.normalizedPayee, 'STARBUCKS');
      expect(suggestions.first.correctionCount, 3);
    });

    test('does not surface groups under the minimum threshold', () async {
      await insertCorrection(
          id: '1', payee: 'PELOTON', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '2', payee: 'PELOTON', categoryId: 'cat-fitness');

      final suggestions = await service.getSuggestions();

      expect(suggestions, isEmpty);
    });

    test('excludes corrections outside the 90-day window', () async {
      // Two recent corrections + two ancient ones — only 2 in window.
      await insertCorrection(
          id: '1', payee: 'X', categoryId: 'cat-a', daysAgo: 10);
      await insertCorrection(
          id: '2', payee: 'X', categoryId: 'cat-a', daysAgo: 20);
      await insertCorrection(
          id: '3', payee: 'X', categoryId: 'cat-a', daysAgo: 120);
      await insertCorrection(
          id: '4', payee: 'X', categoryId: 'cat-a', daysAgo: 200);

      final suggestions = await service.getSuggestions();

      expect(suggestions, isEmpty);
    });

    test('excludes pairs already covered by an enabled payeeExact rule',
        () async {
      await repo.insertRule(makeRule(
        id: 'rule-1',
        payeeExact: 'PELOTON',
        categoryId: 'cat-fitness',
      ));
      await insertCorrection(
          id: '1', payee: 'PELOTON', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '2', payee: 'PELOTON', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '3', payee: 'PELOTON', categoryId: 'cat-fitness');

      final suggestions = await service.getSuggestions();

      expect(suggestions, isEmpty);
    });

    test('excludes pairs covered by an enabled payeeContains rule', () async {
      await repo.insertRule(makeRule(
        id: 'rule-1',
        payeeContains: 'PELOTON',
        categoryId: 'cat-fitness',
      ));
      // Normalized payee is "PELOTON INTERACTIVE" — the rule's
      // payeeContains "PELOTON" substring-matches it, so the pair is covered.
      await insertCorrection(
          id: '1', payee: 'PELOTON INTERACTIVE', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '2', payee: 'PELOTON INTERACTIVE', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '3', payee: 'PELOTON INTERACTIVE', categoryId: 'cat-fitness');

      final suggestions = await service.getSuggestions();

      expect(suggestions, isEmpty);
    });

    test('does NOT dedupe against a disabled rule', () async {
      // Disabled rule should not protect the pair from suggestion.
      await repo.insertRule(makeRule(
        id: 'rule-1',
        payeeExact: 'PELOTON',
        categoryId: 'cat-fitness',
        isEnabled: false,
      ));
      await insertCorrection(
          id: '1', payee: 'PELOTON', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '2', payee: 'PELOTON', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '3', payee: 'PELOTON', categoryId: 'cat-fitness');

      final suggestions = await service.getSuggestions();

      expect(suggestions, hasLength(1));
    });

    test('does not surface a pair the user has dismissed', () async {
      await insertCorrection(
          id: '1', payee: 'PELOTON', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '2', payee: 'PELOTON', categoryId: 'cat-fitness');
      await insertCorrection(
          id: '3', payee: 'PELOTON', categoryId: 'cat-fitness');
      await service.dismissSuggestion(const SuggestedRule(
        normalizedPayee: 'PELOTON',
        suggestedCategoryId: 'cat-fitness',
        correctionCount: 3,
        sampleRawPayee: 'PELOTON',
      ));

      final suggestions = await service.getSuggestions();

      expect(suggestions, isEmpty);
    });

    test('sorts by correctionCount descending', () async {
      // 3 corrections of A, 5 corrections of B.
      for (var i = 0; i < 3; i++) {
        await insertCorrection(id: 'a$i', payee: 'A', categoryId: 'cat-a');
      }
      for (var i = 0; i < 5; i++) {
        await insertCorrection(id: 'b$i', payee: 'B', categoryId: 'cat-b');
      }

      final suggestions = await service.getSuggestions();

      expect(suggestions.length, 2);
      expect(suggestions.first.normalizedPayee, 'B');
      expect(suggestions.first.correctionCount, 5);
      expect(suggestions.last.normalizedPayee, 'A');
      expect(suggestions.last.correctionCount, 3);
    });

    test('corrections with empty-after-normalization payee are dropped',
        () async {
      // Payees that normalize to empty string should not crash or appear.
      await insertCorrection(id: '1', payee: '   ', categoryId: 'cat-a');
      await insertCorrection(id: '2', payee: '   ', categoryId: 'cat-a');
      await insertCorrection(id: '3', payee: '   ', categoryId: 'cat-a');

      final suggestions = await service.getSuggestions();

      expect(suggestions, isEmpty);
    });
  });

  group('acceptSuggestion', () {
    test('creates a payeeExact rule at priority 10 when no rules exist',
        () async {
      const suggestion = SuggestedRule(
        normalizedPayee: 'PELOTON',
        suggestedCategoryId: 'cat-fitness',
        correctionCount: 3,
        sampleRawPayee: 'PELOTON',
      );

      await service.acceptSuggestion(suggestion);

      final rules = await repo.getAllRules();
      expect(rules.length, 1);
      expect(rules.first.payeeExact, 'PELOTON');
      expect(rules.first.categoryId, 'cat-fitness');
      expect(rules.first.priority, 10);
      expect(rules.first.isEnabled, true);
    });

    test(
        'lands at max(existing priority) + 10 so it does not collide with '
        'seeded rules or drag-reordered priorities', () async {
      await repo.insertRules([
        makeRule(id: 'a', payeeContains: 'AMAZON', categoryId: 'cat-a',
            priority: 30),
        makeRule(id: 'b', payeeContains: 'STARBUCKS', categoryId: 'cat-b',
            priority: 150),
        makeRule(id: 'c', payeeContains: 'KROGER', categoryId: 'cat-c',
            priority: 70),
      ]);
      const suggestion = SuggestedRule(
        normalizedPayee: 'PELOTON',
        suggestedCategoryId: 'cat-fitness',
        correctionCount: 3,
        sampleRawPayee: 'PELOTON',
      );

      await service.acceptSuggestion(suggestion);

      final rules = await repo.getAllRules();
      final newRule = rules.firstWhere((r) => r.payeeExact == 'PELOTON');
      expect(newRule.priority, 160); // 150 (max) + 10
    });
  });

  group('dismissSuggestion', () {
    test('is idempotent — re-dismissing the same pair refreshes timestamp',
        () async {
      const suggestion = SuggestedRule(
        normalizedPayee: 'PELOTON',
        suggestedCategoryId: 'cat-fitness',
        correctionCount: 3,
        sampleRawPayee: 'PELOTON',
      );

      await service.dismissSuggestion(suggestion);
      final first = (await repo.getDismissedSuggestions()).single;

      // Brief delay to ensure timestamp differs.
      await Future.delayed(const Duration(milliseconds: 5));
      await service.dismissSuggestion(suggestion);
      final entries = await repo.getDismissedSuggestions();

      expect(entries.length, 1);
      expect(entries.single.dismissedAt, greaterThanOrEqualTo(first.dismissedAt));
    });
  });
}
