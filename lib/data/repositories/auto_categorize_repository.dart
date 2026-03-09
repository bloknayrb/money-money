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

  /// Delete all rules referencing a given category.
  Future<void> deleteRulesForCategory(String categoryId) {
    return (_db.delete(_db.autoCategorizeRules)
          ..where((r) => r.categoryId.equals(categoryId)))
        .go();
  }

  // ---------------------------------------------------------------------------
  // CategorizationCorrections
  // ---------------------------------------------------------------------------

  /// Log a user correction (changed category on a transaction).
  Future<void> insertCorrection(CategorizationCorrectionsCompanion correction) {
    return _db.into(_db.categorizationCorrections).insert(correction);
  }
}
