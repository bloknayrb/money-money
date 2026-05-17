import 'package:drift/drift.dart';

import '../../domain/usecases/categorize/payee_normalization.dart'
    as payee_norm;
import '../local/database/app_database.dart';

/// Repository for auto-categorization data: rules, payee cache, and corrections.
class AutoCategorizeRepository {
  AutoCategorizeRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------------
  // PayeeCategoryCache
  // ---------------------------------------------------------------------------

  /// Look up a cached payee → category mapping.
  ///
  /// The cache is partitioned by `accountBucket` so the same payee can have
  /// different learned categories in 'standard' (checking/credit/savings)
  /// vs 'investment' (brokerage/401k/IRA/HSA/crypto) contexts.
  Future<PayeeCategoryCacheData?> getCacheEntry(
    String payeeNormalized,
    String accountBucket,
  ) {
    return (_db.select(_db.payeeCategoryCache)
          ..where((c) =>
              c.payeeNormalized.equals(payeeNormalized) &
              c.accountBucket.equals(accountBucket)))
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

  /// Reassign priorities for a list of rules in a single batched transaction.
  /// [updates] is an ordered list of (id, priority) pairs. Used by
  /// drag-reorder UI to rewrite the full ordering atomically — a mid-loop
  /// failure can't leave the table half-reordered.
  Future<void> reassignPriorities(
    List<(String id, int priority)> updates,
    int updatedAt,
  ) {
    return _db.batch((batch) {
      for (final (id, priority) in updates) {
        batch.update(
          _db.autoCategorizeRules,
          AutoCategorizeRulesCompanion(
            priority: Value(priority),
            updatedAt: Value(updatedAt),
          ),
          where: (r) => r.id.equals(id),
        );
      }
    });
  }

  /// Retarget multiple rules' categoryId in a single batched transaction.
  /// Used by RuleSeeder's one-shot retargets so a mid-loop failure can't
  /// leave the table partially updated.
  Future<void> updateRulesCategoryBatch(
    Map<String, String> ruleIdToCategoryId,
    int updatedAt,
  ) {
    return _db.batch((batch) {
      for (final entry in ruleIdToCategoryId.entries) {
        batch.update(
          _db.autoCategorizeRules,
          AutoCategorizeRulesCompanion(
            categoryId: Value(entry.value),
            updatedAt: Value(updatedAt),
          ),
          where: (r) => r.id.equals(entry.key),
        );
      }
    });
  }

  /// Increment hit counts for multiple rules in a single batched transaction.
  /// [hitsByRuleId] maps rule id → increment delta. [lastHitAt] is the wall
  /// clock for the most recent matching event; we apply the same value to
  /// every updated row because the batch represents one "categorize" event.
  Future<void> incrementHitCounts(
    Map<String, int> hitsByRuleId,
    int lastHitAt,
  ) {
    return _db.batch((batch) {
      for (final entry in hitsByRuleId.entries) {
        batch.customStatement(
          'UPDATE auto_categorize_rules SET hit_count = hit_count + ?, last_hit_at = ? WHERE id = ?',
          [entry.value, lastHitAt, entry.key],
        );
      }
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

  /// Count corrections matching `(normalizePayee(payee), categoryId)`
  /// within the last [days] days.
  ///
  /// Caller passes an already-normalized payee. Internally we apply the
  /// same normalization to each correction row's raw payee, since the
  /// stored `payee` is raw and normalization uses regex logic SQLite
  /// can't express. Acceptable scale: ~1k rows per 90-day window after
  /// the SQL filter on `createdAt + newCategoryId`.
  Future<int> countRecentCorrectionsForPayee({
    required String payeeNormalized,
    required String categoryId,
    int days = 90,
  }) async {
    final cutoff = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch;
    final rows = await (_db.select(_db.categorizationCorrections)
          ..where((c) =>
              c.createdAt.isBiggerThanValue(cutoff) &
              c.newCategoryId.equals(categoryId)))
        .get();
    var count = 0;
    for (final r in rows) {
      if (payee_norm.normalizePayee(r.payee) == payeeNormalized) count++;
    }
    return count;
  }
}
