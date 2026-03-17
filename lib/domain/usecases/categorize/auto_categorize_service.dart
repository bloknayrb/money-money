import 'dart:math';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/repositories/auto_categorize_repository.dart';
import '../../../data/repositories/transaction_repository.dart';

/// Service for automatic transaction categorization.
///
/// Two-tier pipeline:
/// 1. Payee cache lookup (learned from user assignments)
/// 2. Rules engine (priority-ordered pattern matching)
class AutoCategorizeService {
  AutoCategorizeService(this._autoCatRepo, this._transactionRepo);

  final AutoCategorizeRepository _autoCatRepo;
  final TransactionRepository _transactionRepo;

  static const _confidenceThreshold = 0.8;

  /// Known POS terminal prefixes to strip from payee names.
  static final _posPrefixes = [
    'SQ *',
    'TST* ',
    'TST*',
    'PAYPAL *',
    'SP * ',
    'SP *',
    'CKE*',
    'DD *',
    'GOOGLE *',
    'APL*',
  ];

  /// Patterns that should be replaced entirely with a canonical name.
  static final _canonicalReplacements = [
    (RegExp(r'^AMZN MKTP US\b.*', caseSensitive: false), 'AMAZON'),
    (RegExp(r'^AMAZON\.COM\b.*', caseSensitive: false), 'AMAZON'),
    (RegExp(r'^AMZN\b.*', caseSensitive: false), 'AMAZON'),
  ];

  /// Trailing noise patterns to strip.
  static final _trailingNoise = RegExp(
    r'\s*#\d+$'        // trailing reference numbers
    r'|\s+[A-Z]{2}\s+\d{5}(-\d{4})?$'  // state + zip
    r'|\s+\d{3}-\d{3}-\d{4}$'          // phone numbers
  );

  /// Trailing store/location identifiers.
  static final _trailingStoreId = RegExp(
    r'\s+(S\d+|ST\d+|T\d+|STORE\s*\d+|LOC\s*\d+|UNIT\s*\d+)$',
  );

  /// Trailing transaction/reference IDs (6+ chars, must contain both letters
  /// and digits to avoid stripping real words like SUPERCENTER).
  static final _trailingRefId = RegExp(r'\s+(?=[A-Z0-9]*[0-9])(?=[A-Z0-9]*[A-Z])[A-Z0-9]{6,}$');

  /// Trailing date-like patterns (MM/DD).
  static final _trailingDate = RegExp(r'\s+\d{2}/\d{2}$');

  // ---------------------------------------------------------------------------
  // Payee normalization
  // ---------------------------------------------------------------------------

  /// Normalize a raw payee string for consistent matching.
  String normalizePayee(String raw) {
    var s = raw.trim().toUpperCase();

    // Replace canonical patterns first (e.g., AMZN MKTP US* → AMAZON)
    for (final (pattern, replacement) in _canonicalReplacements) {
      if (pattern.hasMatch(s)) return replacement;
    }

    // Strip POS prefixes
    for (final prefix in _posPrefixes) {
      if (s.startsWith(prefix.toUpperCase())) {
        s = s.substring(prefix.length);
        break;
      }
    }

    // Strip trailing noise
    s = s.replaceAll(_trailingNoise, '');

    // Strip trailing date-like patterns first (exposes store/ref IDs)
    s = s.replaceAll(_trailingDate, '');

    // Strip trailing store/location identifiers
    s = s.replaceAll(_trailingStoreId, '');

    // Strip trailing transaction/reference IDs
    s = s.replaceAll(_trailingRefId, '');

    // Collapse whitespace
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();

    return s;
  }

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
  }) async {
    final normalized = normalizePayee(payee);
    if (normalized.isEmpty) return null;

    // Tier 1: Payee cache lookup
    final cacheEntry = await _autoCatRepo.getCacheEntry(normalized);
    if (cacheEntry != null && cacheEntry.confidence >= _confidenceThreshold) {
      return cacheEntry.categoryId;
    }

    // Tier 2: Rules engine
    final rules = await _autoCatRepo.getEnabledRules();
    for (final rule in rules) {
      if (_ruleMatches(rule, normalized, amountCents, accountId)) {
        return rule.categoryId;
      }
    }

    return null;
  }

  /// Check if a rule matches the given transaction attributes.
  bool _ruleMatches(
    AutoCategorizeRule rule,
    String normalizedPayee,
    int? amountCents,
    String? accountId,
  ) {
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

    // At least one condition must be non-null for the rule to be meaningful
    if (rule.payeeExact == null &&
        rule.payeeContains == null &&
        rule.amountMinCents == null &&
        rule.amountMaxCents == null &&
        rule.accountId == null) {
      return false;
    }

    return true;
  }

  /// Load all enabled rules once. Call before a batch categorization loop.
  Future<List<AutoCategorizeRule>> loadEnabledRules() {
    return _autoCatRepo.getEnabledRules();
  }

  /// Categorize using pre-loaded rules (avoids per-transaction DB query for rules).
  /// Tier 1 cache lookup is still per-transaction (each payee may differ).
  Future<String?> categorizeWithPreloadedRules(
    String payee,
    List<AutoCategorizeRule> rules, {
    int? amountCents,
    String? accountId,
  }) async {
    final normalized = normalizePayee(payee);
    if (normalized.isEmpty) return null;

    // Tier 1: Payee cache lookup (still per-transaction)
    final cacheEntry = await _autoCatRepo.getCacheEntry(normalized);
    if (cacheEntry != null && cacheEntry.confidence >= _confidenceThreshold) {
      return cacheEntry.categoryId;
    }

    // Tier 2: Match against pre-loaded rules
    for (final rule in rules) {
      if (_ruleMatches(rule, normalized, amountCents, accountId)) {
        return rule.categoryId;
      }
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Learning
  // ---------------------------------------------------------------------------

  /// Record a user's category assignment to update the payee cache.
  Future<void> recordCategoryAssignment({
    required String payee,
    required String categoryId,
    String? transactionId,
    String? oldCategoryId,
  }) async {
    final normalized = normalizePayee(payee);
    if (normalized.isEmpty) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = await _autoCatRepo.getCacheEntry(normalized);

    if (existing == null) {
      // First time seeing this payee
      await _autoCatRepo.upsertCacheEntry(PayeeCategoryCacheCompanion(
        payeeNormalized: Value(normalized),
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
        categoryId: Value(categoryId),
        confidence: Value(newConfidence),
        source: const Value('user'),
        useCount: Value(newCount),
        updatedAt: Value(now),
      ));
    } else {
      // Different category — user is correcting; reset
      await _autoCatRepo.upsertCacheEntry(PayeeCategoryCacheCompanion(
        payeeNormalized: Value(normalized),
        categoryId: Value(categoryId),
        confidence: const Value(0.5),
        source: const Value('user'),
        useCount: const Value(1),
        updatedAt: Value(now),
      ));
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
  /// Returns the number of transactions that were categorized.
  Future<int> categorizeUncategorized() async {
    final uncategorized = await _transactionRepo.getUncategorizedTransactions();
    final rules = await loadEnabledRules();
    var count = 0;

    for (final txn in uncategorized) {
      final categoryId = await categorizeWithPreloadedRules(
        txn.payee,
        rules,
        amountCents: txn.amountCents,
        accountId: txn.accountId,
      );
      if (categoryId != null) {
        await _transactionRepo.updateCategory(txn.id, categoryId);
        count++;
      }
    }

    return count;
  }
}
