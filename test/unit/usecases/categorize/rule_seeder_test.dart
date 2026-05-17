import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymoney/data/local/database/app_database.dart';
import 'package:moneymoney/data/repositories/auto_categorize_repository.dart';
import 'package:moneymoney/data/repositories/category_repository.dart';
import 'package:moneymoney/domain/usecases/categorize/rule_seeder.dart';

class MockAutoCategorizeRepository extends Mock
    implements AutoCategorizeRepository {}

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late MockAutoCategorizeRepository autoCatRepo;
  late MockCategoryRepository categoryRepo;
  late RuleSeeder seeder;

  setUp(() {
    autoCatRepo = MockAutoCategorizeRepository();
    categoryRepo = MockCategoryRepository();
    seeder = RuleSeeder(categoryRepo, autoCatRepo);
  });

  setUpAll(() {
    registerFallbackValue(const AutoCategorizeRulesCompanion());
  });

  Category cat({
    required String id,
    required String name,
    String? parentId,
  }) {
    return Category(
      id: id,
      name: name,
      parentId: parentId,
      type: 'expense',
      icon: 'category',
      color: 0xFF000000,
      displayOrder: 0,
      isSystem: false,
      createdAt: 0,
      updatedAt: 0,
      version: 1,
      syncStatus: 0,
    );
  }

  AutoCategorizeRule rule({
    required String id,
    required String payeeContains,
    required String categoryId,
    required int createdAt,
    required int updatedAt,
    int priority = 0,
  }) {
    return AutoCategorizeRule(
      id: id,
      name: '$payeeContains → cat',
      priority: priority,
      payeeContains: payeeContains,
      payeeExact: null,
      amountMinCents: null,
      amountMaxCents: null,
      accountId: null,
      categoryId: categoryId,
      accountType: null,
      isEnabled: true,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  group('_retargetAutoMaintenanceRules (via seedIfEmpty)', () {
    test('retargets seeded JIFFY LUBE rule to Auto Maintenance', () async {
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'trans', name: 'Transportation'),
            cat(id: 'automaint', name: 'Auto Maintenance', parentId: 'trans'),
          ]);
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            rule(
              id: 'rule-jiffy',
              payeeContains: 'JIFFY LUBE',
              categoryId: 'trans',
              createdAt: 1000,
              updatedAt: 1000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});
      when(() => autoCatRepo.updateRulesCategoryBatch(any(), any())).thenAnswer((_) async {});

      final result = await seeder.seedIfEmpty();

      expect(result, isTrue);
      final captured = verify(() =>
              autoCatRepo.updateRulesCategoryBatch(captureAny(), any()))
          .captured
          .single as Map<String, String>;
      expect(captured.length, equals(1));
      expect(captured['rule-jiffy'], equals('automaint'));
    });

    test('skips rules with updatedAt != createdAt (user-edited)', () async {
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'trans', name: 'Transportation'),
            cat(id: 'automaint', name: 'Auto Maintenance', parentId: 'trans'),
          ]);
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            rule(
              id: 'rule-edited',
              payeeContains: 'AUTOZONE',
              categoryId: 'trans',
              createdAt: 1000,
              updatedAt: 2000, // user edited
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      await seeder.seedIfEmpty();

      verifyNever(() => autoCatRepo.updateRulesCategoryBatch(any(), any()));
    });

    test('skips rules already pointing at a different category', () async {
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'trans', name: 'Transportation'),
            cat(id: 'automaint', name: 'Auto Maintenance', parentId: 'trans'),
            cat(id: 'misc', name: 'Miscellaneous'),
          ]);
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            rule(
              id: 'rule-already-moved',
              payeeContains: 'SAFELITE',
              categoryId: 'misc', // not the Transportation parent
              createdAt: 1000,
              updatedAt: 1000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      await seeder.seedIfEmpty();

      verifyNever(() => autoCatRepo.updateRulesCategoryBatch(any(), any()));
    });

    test('skips non-auto-maintenance merchants', () async {
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'trans', name: 'Transportation'),
            cat(id: 'automaint', name: 'Auto Maintenance', parentId: 'trans'),
          ]);
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            rule(
              id: 'rule-shell',
              payeeContains: 'SHELL', // gas, not maintenance
              categoryId: 'trans',
              createdAt: 1000,
              updatedAt: 1000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      await seeder.seedIfEmpty();

      verifyNever(() => autoCatRepo.updateRulesCategoryBatch(any(), any()));
    });

    test('no-op when Auto Maintenance subcategory does not exist', () async {
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'trans', name: 'Transportation'),
            // no Auto Maintenance child
          ]);
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            rule(
              id: 'rule-jiffy',
              payeeContains: 'JIFFY LUBE',
              categoryId: 'trans',
              createdAt: 1000,
              updatedAt: 1000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      await seeder.seedIfEmpty();

      verifyNever(() => autoCatRepo.updateRulesCategoryBatch(any(), any()));
    });

    test('skips rules with null payeeContains', () async {
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'trans', name: 'Transportation'),
            cat(id: 'automaint', name: 'Auto Maintenance', parentId: 'trans'),
          ]);
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            const AutoCategorizeRule(
              id: 'rule-noPattern',
              name: 'amount-only rule',
              priority: 0,
              payeeContains: null,
              payeeExact: null,
              amountMinCents: 100,
              amountMaxCents: 1000,
              accountId: null,
              categoryId: 'trans',
              accountType: null,
              isEnabled: true,
              createdAt: 1000,
              updatedAt: 1000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      await seeder.seedIfEmpty();

      verifyNever(() => autoCatRepo.updateRulesCategoryBatch(any(), any()));
    });

    test('retargets multiple rules and reports backfill via return value',
        () async {
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'trans', name: 'Transportation'),
            cat(id: 'automaint', name: 'Auto Maintenance', parentId: 'trans'),
          ]);
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            rule(
              id: 'rule-jiffy',
              payeeContains: 'JIFFY LUBE',
              categoryId: 'trans',
              createdAt: 1000,
              updatedAt: 1000,
            ),
            rule(
              id: 'rule-autozone',
              payeeContains: 'AUTOZONE',
              categoryId: 'trans',
              createdAt: 1000,
              updatedAt: 1000,
            ),
            rule(
              id: 'rule-oreilly',
              payeeContains: "O'REILLY",
              categoryId: 'trans',
              createdAt: 1000,
              updatedAt: 1000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});
      when(() => autoCatRepo.updateRulesCategoryBatch(any(), any())).thenAnswer((_) async {});

      final result = await seeder.seedIfEmpty();

      expect(result, isTrue);
      // Batched: one call with all three retargets in the map.
      final captured = verify(() =>
              autoCatRepo.updateRulesCategoryBatch(captureAny(), any()))
          .captured
          .single as Map<String, String>;
      expect(captured.length, equals(3));
      expect(captured.keys, containsAll(['rule-jiffy', 'rule-autozone', 'rule-oreilly']));
      expect(captured.values, everyElement(equals('automaint')));
    });
  });

  group('_backfillMissingDefaultRules (via seedIfEmpty)', () {
    test('inserts a missing general rule for an existing user', () async {
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'gas', name: 'Gas'),
          ]);
      // Existing user only has KROGER; missing TESLA SUPERCHARGER and others.
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            rule(
              id: 'existing',
              payeeContains: 'KROGER',
              categoryId: 'gas',
              createdAt: 1000,
              updatedAt: 1000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      final result = await seeder.seedIfEmpty();

      expect(result, isTrue);
      final captured = verify(() => autoCatRepo.insertRules(captureAny()))
          .captured
          .single as List<AutoCategorizeRulesCompanion>;
      // Should contain TESLA SUPERCHARGER → Gas (new 2025-era rule).
      final hasTesla = captured.any((c) =>
          c.payeeContains.value == 'TESLA SUPERCHARGER' &&
          c.categoryId.value == 'gas');
      expect(hasTesla, isTrue);
      // Should NOT re-insert KROGER (already exists).
      final hasKroger =
          captured.any((c) => c.payeeContains.value == 'KROGER');
      expect(hasKroger, isFalse);
    });

    test('skips general rules whose payeeContains already exists', () async {
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'gas', name: 'Gas'),
          ]);
      // User has all the EV charging rules already.
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            rule(
              id: 'user-tesla',
              payeeContains: 'TESLA SUPERCHARGER',
              categoryId: 'gas',
              createdAt: 1000,
              updatedAt: 2000, // user-edited; dedup still applies
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      await seeder.seedIfEmpty();

      // Anything inserted should not include TESLA SUPERCHARGER.
      final inserted = verify(() => autoCatRepo.insertRules(captureAny()))
          .captured
          .single as List<AutoCategorizeRulesCompanion>;
      final hasTeslaSupercharger = inserted
          .any((c) => c.payeeContains.value == 'TESLA SUPERCHARGER');
      expect(hasTeslaSupercharger, isFalse);
    });

    test('does NOT duplicate a default rule that the user has disabled',
        () async {
      // Regression test for the bug where dedup used getEnabledRules,
      // missing user-disabled rules and re-inserting duplicates on every
      // upgrade.
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'gas', name: 'Gas'),
          ]);
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            const AutoCategorizeRule(
              id: 'disabled-tesla',
              name: 'TESLA SUPERCHARGER → Gas',
              priority: 100,
              payeeContains: 'TESLA SUPERCHARGER',
              payeeExact: null,
              amountMinCents: null,
              amountMaxCents: null,
              accountId: null,
              categoryId: 'gas',
              accountType: null,
              isEnabled: false, // user disabled
              createdAt: 1000,
              updatedAt: 2000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      await seeder.seedIfEmpty();

      final inserted = verify(() => autoCatRepo.insertRules(captureAny()))
          .captured
          .single as List<AutoCategorizeRulesCompanion>;
      // Critical: should NOT re-insert TESLA SUPERCHARGER even though
      // the existing rule is disabled.
      final hasTeslaDuplicate = inserted
          .any((c) => c.payeeContains.value == 'TESLA SUPERCHARGER');
      expect(hasTeslaDuplicate, isFalse,
          reason: 'disabled rule should still dedupe');
    });

    test('does NOT duplicate a default rule the user has customized', () async {
      // Companion to the disabled-rule test: an enabled rule with the same
      // payeeContains but a user-customized name/category should also dedupe.
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'gas', name: 'Gas'),
            cat(id: 'misc', name: 'Miscellaneous'),
          ]);
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            const AutoCategorizeRule(
              id: 'custom-tesla',
              name: 'My custom Tesla rule',
              priority: 5,
              payeeContains: 'TESLA SUPERCHARGER',
              payeeExact: null,
              amountMinCents: null,
              amountMaxCents: null,
              accountId: null,
              categoryId: 'misc', // user mapped it elsewhere
              accountType: null,
              isEnabled: true,
              createdAt: 1000,
              updatedAt: 2000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      await seeder.seedIfEmpty();

      final inserted = verify(() => autoCatRepo.insertRules(captureAny()))
          .captured
          .single as List<AutoCategorizeRulesCompanion>;
      final hasTeslaDuplicate = inserted
          .any((c) => c.payeeContains.value == 'TESLA SUPERCHARGER');
      expect(hasTeslaDuplicate, isFalse,
          reason: 'user-customized rule should dedupe; their choice wins');
    });

    test('inserts investment rule with same payeeContains as general rule',
        () async {
      // An investment rule with the same payeeContains but a different
      // accountType has a distinct dedup key, so should be inserted.
      when(() => autoCatRepo.hasRules()).thenAnswer((_) async => true);
      when(() => categoryRepo.getAllCategories()).thenAnswer((_) async => [
            cat(id: 'interest', name: 'Interest'),
            cat(id: 'gas', name: 'Gas'),
          ]);
      // User has a general 'INTEREST' rule but no investment-scoped one.
      when(() => autoCatRepo.getAllRules()).thenAnswer((_) async => [
            rule(
              id: 'general',
              payeeContains: 'INTEREST',
              categoryId: 'interest',
              createdAt: 1000,
              updatedAt: 1000,
            ),
          ]);
      when(() => autoCatRepo.insertRules(any())).thenAnswer((_) async {});

      await seeder.seedIfEmpty();

      final inserted = verify(() => autoCatRepo.insertRules(captureAny()))
          .captured
          .single as List<AutoCategorizeRulesCompanion>;
      // Investment 'INTEREST' rule for brokerage should still be inserted.
      final hasInvestmentInterest = inserted.any((c) =>
          c.payeeContains.value == 'INTEREST' &&
          c.accountType.value == 'brokerage');
      expect(hasInvestmentInterest, isTrue);
    });
  });
}
