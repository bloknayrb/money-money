import 'package:drift/drift.dart';

import '../local/database/app_database.dart';

/// Repository for auto-categorization data: rules, payee cache, and corrections.
class AutoCategorizeRepository {
  AutoCategorizeRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------------
  // PayeeCategoryCache
  // ---------------------------------------------------------------------------

  /// Look up a cached payee → category mapping by normalized payee name.
  Future<PayeeCategoryCacheData?> getCacheEntry(String payeeNormalized) {
    return (_db.select(_db.payeeCategoryCache)
          ..where((c) => c.payeeNormalized.equals(payeeNormalized)))
        .getSingleOrNull();
  }

  /// Insert or update a payee → category cache entry (upsert on PK).
  Future<void> upsertCacheEntry(PayeeCategoryCacheCompanion entry) {
    return _db.into(_db.payeeCategoryCache).insertOnConflictUpdate(entry);
  }

  /// Delete all cache entries referencing a given category.
  Future<void> deleteCacheEntriesForCategory(String categoryId) {
    return (_db.delete(_db.payeeCategoryCache)
          ..where((c) => c.categoryId.equals(categoryId)))
        .go();
  }

  // ---------------------------------------------------------------------------
  // AutoCategorizeRules
  // ---------------------------------------------------------------------------

  /// Get all enabled rules, ordered by priority (lowest number first).
  Future<List<AutoCategorizeRule>> getEnabledRules() {
    return (_db.select(_db.autoCategorizeRules)
          ..where((r) => r.isEnabled.equals(true))
          ..orderBy([(r) => OrderingTerm.asc(r.priority)]))
        .get();
  }

  /// Watch all rules (for management UI), ordered by priority.
  Stream<List<AutoCategorizeRule>> watchAllRules() {
    return (_db.select(_db.autoCategorizeRules)
          ..orderBy([(r) => OrderingTerm.asc(r.priority)]))
        .watch();
  }

  /// Get all rules (enabled and disabled), ordered by priority.
  Future<List<AutoCategorizeRule>> getAllRules() {
    return (_db.select(_db.autoCategorizeRules)
          ..orderBy([(r) => OrderingTerm.asc(r.priority)]))
        .get();
  }

  /// Insert a single rule.
  Future<void> insertRule(AutoCategorizeRulesCompanion rule) {
    return _db.into(_db.autoCategorizeRules).insert(rule);
  }

  /// Update an existing rule.
  Future<void> updateRule(AutoCategorizeRulesCompanion rule) {
    return (_db.update(_db.autoCategorizeRules)
          ..where((r) => r.id.equals(rule.id.value)))
        .write(rule);
  }

  /// Delete a rule by ID.
  Future<void> deleteRule(String id) {
    return (_db.delete(_db.autoCategorizeRules)
          ..where((r) => r.id.equals(id)))
        .go();
  }

  /// Delete all rules referencing a given category.
  Future<void> deleteRulesForCategory(String categoryId) {
    return (_db.delete(_db.autoCategorizeRules)
          ..where((r) => r.categoryId.equals(categoryId)))
        .go();
  }

  /// Insert multiple rules in a single batch.
  Future<void> insertRules(List<AutoCategorizeRulesCompanion> rules) {
    return _db.batch((batch) {
      batch.insertAll(_db.autoCategorizeRules, rules);
    });
  }

  /// Check if any rules exist.
  Future<bool> hasRules() async {
    final count = _db.autoCategorizeRules.id.count();
    final result = await (_db.selectOnly(_db.autoCategorizeRules)
          ..addColumns([count]))
        .getSingle();
    return (result.read(count) ?? 0) > 0;
  }

  // ---------------------------------------------------------------------------
  // CategorizationCorrections
  // ---------------------------------------------------------------------------

  /// Log a user correction (changed category on a transaction).
  Future<void> insertCorrection(CategorizationCorrectionsCompanion correction) {
    return _db.into(_db.categorizationCorrections).insert(correction);
  }
}
