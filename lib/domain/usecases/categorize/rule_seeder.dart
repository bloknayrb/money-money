import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/repositories/auto_categorize_repository.dart';
import '../../../data/repositories/category_repository.dart';
import 'default_rules_data.dart';

/// Seeds default auto-categorization rules for well-known merchants.
///
/// Runs once after category seeding. Looks up category IDs by name since
/// they are random UUIDs generated at runtime.
class RuleSeeder {
  RuleSeeder(this._categoryRepo, this._autoCatRepo);

  final CategoryRepository _categoryRepo;
  final AutoCategorizeRepository _autoCatRepo;

  static const _uuid = Uuid();

  /// Seed default rules if none exist, and backfill any new rules
  /// (e.g. investment rules) for existing users.
  ///
  /// Returns true if rules were seeded.
  Future<bool> seedIfEmpty() async {
    if (await _autoCatRepo.hasRules()) {
      return _backfillInvestmentRules();
    }

    final categories = await _categoryRepo.getAllCategories();

    // Build name → ID lookup. Parents are added first so they win on
    // duplicate names (e.g. "Insurance" exists as both a parent category
    // and a subcategory under Housing/Healthcare). Unique subcategory names
    // like "Utilities", "Gas", "Pharmacy" are unaffected.
    final catByName = <String, String>{};
    final parents = categories.where((c) => c.parentId == null);
    final children = categories.where((c) => c.parentId != null);
    for (final c in parents) {
      catByName.putIfAbsent(c.name, () => c.id);
    }
    for (final c in children) {
      catByName.putIfAbsent(c.name, () => c.id);
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final rules = <AutoCategorizeRulesCompanion>[];
    var priority = 0;

    for (final (payeeContains, categoryName) in defaultMerchantMappings) {
      final categoryId = catByName[categoryName];
      if (categoryId == null) continue;

      rules.add(AutoCategorizeRulesCompanion.insert(
        id: _uuid.v4(),
        name: '$payeeContains → $categoryName',
        priority: priority++,
        categoryId: categoryId,
        payeeContains: Value(payeeContains),
        isEnabled: const Value(true),
        createdAt: now,
        updatedAt: now,
      ));
    }

    // Seed investment-specific rules (account type scoped)
    for (final (payeeContains, categoryName, accountType)
        in investmentMerchantMappings) {
      final categoryId = catByName[categoryName];
      if (categoryId == null) continue;

      rules.add(AutoCategorizeRulesCompanion.insert(
        id: _uuid.v4(),
        name: '$payeeContains → $categoryName ($accountType)',
        priority: priority++,
        categoryId: categoryId,
        payeeContains: Value(payeeContains),
        accountType: Value(accountType),
        isEnabled: const Value(true),
        createdAt: now,
        updatedAt: now,
      ));
    }

    if (rules.isNotEmpty) {
      await _autoCatRepo.insertRules(rules);
    }

    return true;
  }

  /// Backfill investment-specific rules for existing users who already
  /// have merchant rules but are missing the newer investment rules.
  Future<bool> _backfillInvestmentRules() async {
    // Check if investment rules already exist by looking for any rule
    // with a non-null accountType
    final existingRules = await _autoCatRepo.getEnabledRules();
    final hasInvestmentRules = existingRules.any((r) => r.accountType != null);
    if (hasInvestmentRules) return false;

    final categories = await _categoryRepo.getAllCategories();
    final catByName = <String, String>{};
    for (final c in categories) {
      catByName.putIfAbsent(c.name, () => c.id);
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    // Start priority after existing rules
    var priority = existingRules.length;
    final rules = <AutoCategorizeRulesCompanion>[];

    for (final (payeeContains, categoryName, accountType)
        in investmentMerchantMappings) {
      final categoryId = catByName[categoryName];
      if (categoryId == null) continue;

      rules.add(AutoCategorizeRulesCompanion.insert(
        id: _uuid.v4(),
        name: '$payeeContains → $categoryName ($accountType)',
        priority: priority++,
        categoryId: categoryId,
        payeeContains: Value(payeeContains),
        accountType: Value(accountType),
        isEnabled: const Value(true),
        createdAt: now,
        updatedAt: now,
      ));
    }

    if (rules.isEmpty) return false;
    await _autoCatRepo.insertRules(rules);
    return true;
  }
}
