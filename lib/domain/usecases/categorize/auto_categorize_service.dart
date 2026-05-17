import 'dart:math';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/auto_categorize_repository.dart';
import '../../../data/repositories/transaction_repository.dart';
import 'payee_normalization.dart' as payee_norm;

/// Where a categorize() decision came from.
enum CategorizationSource { none, cache, rule }

/// Result of a traced categorization. Mirrors the `categoryId` returned by
/// the existing [AutoCategorizeService.categorize] but adds provenance for
/// debugging and future "why was this categorized?" UI.
class CategorizationTrace {
  const CategorizationTrace({
    this.categoryId,
    required this.normalizedPayee,
    required this.source,
    this.cacheConfidence,
    this.matchedRule,
  });

  final String? categoryId;
  final String normalizedPayee;
  final CategorizationSource source;

  /// Populated whenever a cache row exists for the payee, even if its
  /// confidence was below the auto-apply threshold. Useful for "we have a
  /// guess but didn't auto-apply" UI hints.
  final double? cacheConfidence;

  /// Populated when [source] is `CategorizationSource.rule`.
  final AutoCategorizeRule? matchedRule;
}

/// Service for automatic transaction categorization.
///
/// Two-tier pipeline:
/// 1. Payee cache lookup (learned from user assignments)
/// 2. Rules engine (priority-ordered pattern matching)
class AutoCategorizeService {
  AutoCategorizeService(this._autoCatRepo, this._transactionRepo,
      {AccountRepository? accountRepo})
      : _accountRepo = accountRepo;

  final AutoCategorizeRepository _autoCatRepo;
  final TransactionRepository _transactionRepo;
  final AccountRepository? _accountRepo;

  static const _confidenceThreshold = 0.8;

  /// Account types whose payee semantics differ from everyday spending —
  /// dividends, transfers in/out, fees. Categorizing STARBUCKS as Coffee in
  /// a checking account must not bleed into a brokerage account where the
  /// same payee likely represents a fee or distribution.
  static const _investmentAccountTypes = {
    'brokerage',
    '401k',
    'ira',
    'roth_ira',
    'hsa',
    'crypto',
  };

  /// Cache partition key. Two buckets: 'standard' vs 'investment'.
  /// Investment-vs-not is the only axis where payee semantics actually flip;
  /// finer-grained partitioning (per accountType) would starve every bucket.
  static String cacheBucket(String? accountType) {
    if (accountType == null) return 'standard';
    return _investmentAccountTypes.contains(accountType)
        ? 'investment'
        : 'standard';
  }

  // ---------------------------------------------------------------------------
  // Payee normalization
  // ---------------------------------------------------------------------------

  /// Normalize a raw payee string for consistent matching.
  ///
  /// Delegates to the top-level `normalizePayee` in `payee_normalization.dart`
  /// so the same logic is reachable from contexts without an
  /// `AutoCategorizeService` instance (e.g. `RuleSuggestionService`).
  String normalizePayee(String raw) => payee_norm.normalizePayee(raw);

  // ---------------------------------------------------------------------------
  // Similarity matching
  // ---------------------------------------------------------------------------

  /// Jaccard similarity on word tokens (ignoring 1-char tokens).
  static double payeeSimilarity(String a, String b) {
    if (a == b) return 1.0;
    final tokensA = a.split(' ').where((t) => t.length > 1).toSet();
    final tokensB = b.split(' ').where((t) => t.length > 1).toSet();
    if (tokensA.isEmpty || tokensB.isEmpty) return 0.0;
    final intersection = tokensA.intersection(tokensB).length;
    final union = tokensA.union(tokensB).length;
    return intersection / union;
  }

  /// Find uncategorized transactions with similar payees (exact or fuzzy).
  List<Transaction> findSimilarUncategorized(
    String payee,
    List<Transaction> uncategorized,
  ) {
    final normalized = normalizePayee(payee);
    if (normalized.isEmpty) return [];
    return uncategorized.where((t) {
      final other = normalizePayee(t.payee);
      if (other == normalized) return true;
      return payeeSimilarity(normalized, other) >= 0.6;
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Categorization pipeline
  // ---------------------------------------------------------------------------

  /// Attempt to categorize a transaction by payee name.
  ///
  /// Returns a categoryId if a match is found, or null.
  Future<String?> categorize(
    String payee, {
    int? amountCents,
    String? accountId,
    String? accountType,
  }) async {
    final trace = await categorizeWithTrace(
      payee,
      amountCents: amountCents,
      accountId: accountId,
      accountType: accountType,
    );
    return trace.categoryId;
  }

  /// Categorize with a detailed trace of which tier (cache vs. rule) matched.
  ///
  /// Used by the Settings → Auto-Categorization Rules "Test a payee" panel
  /// for debugging and by future "why was this transaction categorized?"
  /// UX. Mirrors [categorize] but returns full provenance instead of just
  /// the categoryId.
  Future<CategorizationTrace> categorizeWithTrace(
    String payee, {
    int? amountCents,
    String? accountId,
    String? accountType,
  }) async {
    final normalized = normalizePayee(payee);
    if (normalized.isEmpty) {
      return const CategorizationTrace(
        normalizedPayee: '',
        source: CategorizationSource.none,
      );
    }

    final bucket = cacheBucket(accountType);
    final cacheEntry = await _autoCatRepo.getCacheEntry(normalized, bucket);
    if (cacheEntry != null && cacheEntry.confidence >= _confidenceThreshold) {
      return CategorizationTrace(
        categoryId: cacheEntry.categoryId,
        normalizedPayee: normalized,
        source: CategorizationSource.cache,
        cacheConfidence: cacheEntry.confidence,
      );
    }

    final rules = await _autoCatRepo.getEnabledRules();
    for (final rule in rules) {
      if (_ruleMatches(rule, normalized, amountCents, accountId,
          accountType: accountType)) {
        return CategorizationTrace(
          categoryId: rule.categoryId,
          normalizedPayee: normalized,
          source: CategorizationSource.rule,
          matchedRule: rule,
          // Include any sub-threshold cache hint so the UI can show
          // "we have a guess but didn't auto-apply".
          cacheConfidence: cacheEntry?.confidence,
        );
      }
    }

    return CategorizationTrace(
      normalizedPayee: normalized,
      source: CategorizationSource.none,
      cacheConfidence: cacheEntry?.confidence,
    );
  }

  /// Check if a rule matches the given transaction attributes.
  bool _ruleMatches(
    AutoCategorizeRule rule,
    String normalizedPayee,
    int? amountCents,
    String? accountId, {
    String? accountType,
  }) {
    // payeeExact — case-insensitive exact match
    if (rule.payeeExact != null) {
      if (normalizedPayee != rule.payeeExact!.toUpperCase()) return false;
    }

    // payeeContains — case-insensitive substring match
    if (rule.payeeContains != null) {
      if (!normalizedPayee.contains(rule.payeeContains!.toUpperCase())) {
        return false;
      }
    }

    // Amount range (only checked if amountCents provided)
    if (amountCents != null) {
      if (rule.amountMinCents != null && amountCents < rule.amountMinCents!) {
        return false;
      }
      if (rule.amountMaxCents != null && amountCents > rule.amountMaxCents!) {
        return false;
      }
    }

    // Account filter
    if (rule.accountId != null) {
      if (accountId != rule.accountId) return false;
    }

    // Account type filter
    if (rule.accountType != null) {
      if (accountType == null || rule.accountType != accountType) return false;
    }

    // At least one condition must be non-null for the rule to be meaningful
    if (rule.payeeExact == null &&
        rule.payeeContains == null &&
        rule.amountMinCents == null &&
        rule.amountMaxCents == null &&
        rule.accountId == null &&
        rule.accountType == null) {
      return false;
    }

    return true;
  }

  /// Load all enabled rules once. Call before a batch categorization loop.
  Future<List<AutoCategorizeRule>> loadEnabledRules() {
    return _autoCatRepo.getEnabledRules();
  }

  /// Flush a batch of rule-hit counts to the repository in one write.
  /// Used by bulk-categorization callers (sync, CSV import, the manual
  /// re-categorize button) so the hot loop can accumulate hits in-memory
  /// and pay a single write at the end.
  Future<void> flushHitCounts(Map<String, int> hits) {
    if (hits.isEmpty) return Future.value();
    return _autoCatRepo.incrementHitCounts(
      hits,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Categorize using pre-loaded rules (avoids per-transaction DB query for rules).
  /// Tier 1 cache lookup is still per-transaction (each payee may differ).
  Future<String?> categorizeWithPreloadedRules(
    String payee,
    List<AutoCategorizeRule> rules, {
    int? amountCents,
    String? accountId,
    String? accountType,
  }) async {
    final trace = await categorizeWithPreloadedRulesAndTrace(
      payee,
      rules,
      amountCents: amountCents,
      accountId: accountId,
      accountType: accountType,
    );
    return trace.categoryId;
  }

  /// Trace variant of [categorizeWithPreloadedRules]. See
  /// [categorizeWithTrace] for the rationale.
  Future<CategorizationTrace> categorizeWithPreloadedRulesAndTrace(
    String payee,
    List<AutoCategorizeRule> rules, {
    int? amountCents,
    String? accountId,
    String? accountType,
  }) async {
    final normalized = normalizePayee(payee);
    if (normalized.isEmpty) {
      return const CategorizationTrace(
        normalizedPayee: '',
        source: CategorizationSource.none,
      );
    }

    final bucket = cacheBucket(accountType);
    final cacheEntry = await _autoCatRepo.getCacheEntry(normalized, bucket);
    if (cacheEntry != null && cacheEntry.confidence >= _confidenceThreshold) {
      return CategorizationTrace(
        categoryId: cacheEntry.categoryId,
        normalizedPayee: normalized,
        source: CategorizationSource.cache,
        cacheConfidence: cacheEntry.confidence,
      );
    }

    for (final rule in rules) {
      if (_ruleMatches(rule, normalized, amountCents, accountId,
          accountType: accountType)) {
        return CategorizationTrace(
          categoryId: rule.categoryId,
          normalizedPayee: normalized,
          source: CategorizationSource.rule,
          matchedRule: rule,
          cacheConfidence: cacheEntry?.confidence,
        );
      }
    }

    return CategorizationTrace(
      normalizedPayee: normalized,
      source: CategorizationSource.none,
      cacheConfidence: cacheEntry?.confidence,
    );
  }

  // ---------------------------------------------------------------------------
  // Learning
  // ---------------------------------------------------------------------------

  /// Record a user's category assignment to update the payee cache.
  ///
  /// [accountType] (optional) determines the cache bucket so investment-account
  /// learning doesn't bleed into standard-account categorization, and vice
  /// versa. Null defaults to 'standard'.
  Future<void> recordCategoryAssignment({
    required String payee,
    required String categoryId,
    String? transactionId,
    String? oldCategoryId,
    String? accountType,
  }) async {
    final normalized = normalizePayee(payee);
    if (normalized.isEmpty) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final bucket = cacheBucket(accountType);
    final existing = await _autoCatRepo.getCacheEntry(normalized, bucket);

    if (existing == null) {
      // First time seeing this payee in this bucket
      await _autoCatRepo.upsertCacheEntry(PayeeCategoryCacheCompanion(
        payeeNormalized: Value(normalized),
        accountBucket: Value(bucket),
        categoryId: Value(categoryId),
        confidence: const Value(0.5),
        source: const Value('user'),
        useCount: const Value(1),
        updatedAt: Value(now),
      ));
    } else if (existing.categoryId == categoryId) {
      // Same category — reinforce confidence
      final newCount = existing.useCount + 1;
      final newConfidence = min(1.0, 0.5 + (newCount * 0.1));
      await _autoCatRepo.upsertCacheEntry(PayeeCategoryCacheCompanion(
        payeeNormalized: Value(normalized),
        accountBucket: Value(bucket),
        categoryId: Value(categoryId),
        confidence: Value(newConfidence),
        source: const Value('user'),
        useCount: Value(newCount),
        updatedAt: Value(now),
      ));
    } else {
      // Different category — penalize one step, do NOT wipe. A useCount of N
      // requires N corrections to flip. A single misclick demotes the entry
      // by 1; the previously-learned category is preserved unless its weight
      // falls to zero. This protects the minimum-threshold (useCount=3)
      // entry from being wiped by a single fat-finger.
      //
      // Side effect: the categoryId on the saved transaction (user's literal
      // choice) and the cached categoryId (learned winner) can diverge. That
      // is intentional — the cache only influences *future* matches.
      assert(existing.useCount >= 1,
          'PayeeCategoryCache.useCount must be >= 1 per schema default; '
          'got ${existing.useCount}');
      final penalized = existing.useCount - 1;
      if (penalized >= 1) {
        final newConfidence = min(1.0, 0.5 + (penalized * 0.1));
        await _autoCatRepo.upsertCacheEntry(PayeeCategoryCacheCompanion(
          payeeNormalized: Value(normalized),
          accountBucket: Value(bucket),
          categoryId: Value(existing.categoryId),
          confidence: Value(newConfidence),
          source: const Value('user'),
          useCount: Value(penalized),
          updatedAt: Value(now),
        ));
      } else {
        // useCount was 1; nothing left to keep — adopt the new category.
        await _autoCatRepo.upsertCacheEntry(PayeeCategoryCacheCompanion(
          payeeNormalized: Value(normalized),
          accountBucket: Value(bucket),
          categoryId: Value(categoryId),
          confidence: const Value(0.5),
          source: const Value('user'),
          useCount: const Value(1),
          updatedAt: Value(now),
        ));
      }
    }

    // Log correction if the category actually changed
    if (oldCategoryId != null &&
        oldCategoryId != categoryId &&
        transactionId != null) {
      await _autoCatRepo.insertCorrection(
        CategorizationCorrectionsCompanion.insert(
          id: const Uuid().v4(),
          transactionId: transactionId,
          oldCategoryId: Value(oldCategoryId),
          newCategoryId: categoryId,
          payee: payee,
          createdAt: now,
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Bulk categorization
  // ---------------------------------------------------------------------------

  /// Count uncategorized transactions whose normalized payee matches [payee].
  ///
  /// Optionally excludes a specific transaction by [excludeTransactionId].
  Future<int> countUncategorizedByPayee(
    String payee, {
    String? excludeTransactionId,
  }) async {
    final normalized = normalizePayee(payee);
    if (normalized.isEmpty) return 0;
    final uncategorized = await _transactionRepo.getUncategorizedTransactions();
    return uncategorized.where((txn) {
      if (txn.id == excludeTransactionId) return false;
      return normalizePayee(txn.payee) == normalized;
    }).length;
  }

  /// Apply [categoryId] to all uncategorized transactions matching [payee].
  ///
  /// Returns the number of transactions updated.
  Future<int> applyToMatchingPayee(String payee, String categoryId) async {
    final normalized = normalizePayee(payee);
    if (normalized.isEmpty) return 0;
    final uncategorized = await _transactionRepo.getUncategorizedTransactions();
    var count = 0;
    for (final txn in uncategorized) {
      if (normalizePayee(txn.payee) == normalized) {
        await _transactionRepo.updateCategory(txn.id, categoryId);
        count++;
      }
    }
    return count;
  }

  /// Auto-categorize all uncategorized transactions.
  ///
  /// Returns the number of transactions that were categorized. As a side
  /// effect, increments `hit_count` (and updates `last_hit_at`) on each
  /// rule that fired during the run via a single batched write at the end.
  Future<int> categorizeUncategorized() async {
    final uncategorized = await _transactionRepo.getUncategorizedTransactions();
    if (uncategorized.isEmpty) return 0;

    final rules = await loadEnabledRules();

    // Build accountId → accountType lookup only if rules use accountType filtering
    final accountTypeMap = <String, String>{};
    if (_accountRepo != null && rules.any((r) => r.accountType != null)) {
      final accounts = await _accountRepo.getAllAccounts();
      for (final a in accounts) {
        accountTypeMap[a.id] = a.accountType;
      }
    }

    final hits = <String, int>{}; // ruleId -> match count
    var count = 0;
    for (final txn in uncategorized) {
      final trace = await categorizeWithPreloadedRulesAndTrace(
        txn.payee,
        rules,
        amountCents: txn.amountCents,
        accountId: txn.accountId,
        accountType: accountTypeMap[txn.accountId],
      );
      if (trace.categoryId != null) {
        if (trace.matchedRule != null) {
          hits.update(trace.matchedRule!.id, (v) => v + 1,
              ifAbsent: () => 1);
        }
        await _transactionRepo.updateCategory(txn.id, trace.categoryId!);
        count++;
      }
    }

    await flushHitCounts(hits);
    return count;
  }
}
