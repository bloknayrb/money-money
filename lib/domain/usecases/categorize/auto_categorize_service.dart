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

    // Collapse whitespace
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();

    return s;
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

  /// Auto-categorize all uncategorized transactions.
  ///
  /// Returns the number of transactions that were categorized.
  Future<int> categorizeUncategorized() async {
    final uncategorized = await _transactionRepo.getUncategorizedTransactions();
    var count = 0;

    for (final txn in uncategorized) {
      final categoryId = await categorize(
        txn.payee,
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
