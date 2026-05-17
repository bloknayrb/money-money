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
      final backfilled = await _backfillMissingDefaultRules();
      final retargeted = await _retargetAutoMaintenanceRules();
      return backfilled || retargeted;
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

  /// Backfill any default rules missing for existing users — both the
  /// general merchant rules and the investment-scoped rules.
  ///
  /// Uses set-based dedup on `(payeeContains|accountType)` signatures so it's
  /// self-healing: any time defaultMerchantMappings or investmentMerchantMappings
  /// grows, the next startup inserts only the new entries. User-created rules
  /// with identical payeeContains are respected (skipped).
  Future<bool> _backfillMissingDefaultRules() async {
    final existingRules = await _autoCatRepo.getEnabledRules();

    String key(String payeeContains, String? accountType) =>
        '${payeeContains.toUpperCase()}|${accountType ?? ''}';

    final existingKeys = <String>{
      for (final r in existingRules)
        if (r.payeeContains != null) key(r.payeeContains!, r.accountType),
    };

    final missingGeneral = [
      for (final m in defaultMerchantMappings)
        if (!existingKeys.contains(key(m.$1, null))) m,
    ];
    final missingInvestment = [
      for (final m in investmentMerchantMappings)
        if (!existingKeys.contains(key(m.$1, m.$3))) m,
    ];

    if (missingGeneral.isEmpty && missingInvestment.isEmpty) return false;

    final categories = await _categoryRepo.getAllCategories();
    final catByName = <String, String>{};
    for (final c in categories.where((c) => c.parentId == null)) {
      catByName.putIfAbsent(c.name, () => c.id);
    }
    for (final c in categories.where((c) => c.parentId != null)) {
      catByName.putIfAbsent(c.name, () => c.id);
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    var priority = existingRules.length;
    final rules = <AutoCategorizeRulesCompanion>[];

    for (final (payeeContains, categoryName) in missingGeneral) {
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

    for (final (payeeContains, categoryName, accountType) in missingInvestment) {
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

  /// Auto-maintenance rules originally pointed at the Transportation parent
  /// category because the 'Auto Maintenance' subcategory didn't exist in the
  /// seed yet. Now that it does, retarget any seeded rule that the user
  /// hasn't touched (createdAt == updatedAt) to the new subcategory.
  ///
  /// Returns true if any rules were retargeted. Skipped if 'Auto Maintenance'
  /// hasn't been seeded yet (CategorySeeder backfill should run first).
  Future<bool> _retargetAutoMaintenanceRules() async {
    const autoMaintenancePayees = {
      'JIFFY LUBE', 'VALVOLINE', 'FIRESTONE', 'AUTOZONE', 'PEP BOYS',
      "O'REILLY", 'ADVANCE AUTO', 'NAPA AUTO', 'MIDAS', 'GOODYEAR',
      'DISCOUNT TIRE', 'MAACO', 'MEINEKE', 'SAFELITE',
    };

    final categories = await _categoryRepo.getAllCategories();
    String? transportationParentId;
    String? autoMaintenanceId;
    for (final c in categories) {
      if (c.parentId == null && c.name == 'Transportation') {
        transportationParentId = c.id;
      } else if (c.parentId != null && c.name == 'Auto Maintenance') {
        autoMaintenanceId = c.id;
      }
    }
    if (transportationParentId == null || autoMaintenanceId == null) {
      return false;
    }

    final rules = await _autoCatRepo.getEnabledRules();
    final now = DateTime.now().millisecondsSinceEpoch;
    var retargetCount = 0;
    for (final r in rules) {
      if (r.payeeContains == null) continue;
      if (!autoMaintenancePayees.contains(r.payeeContains!.toUpperCase())) {
        continue;
      }
      if (r.categoryId != transportationParentId) continue;
      if (r.updatedAt != r.createdAt) continue; // user-edited; leave alone

      await _autoCatRepo.updateRule(
        AutoCategorizeRulesCompanion(
          id: Value(r.id),
          categoryId: Value(autoMaintenanceId),
          updatedAt: Value(now),
        ),
      );
      retargetCount++;
    }

    return retargetCount > 0;
  }
}
