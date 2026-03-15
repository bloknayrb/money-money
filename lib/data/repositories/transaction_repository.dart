import 'package:drift/drift.dart';

import '../local/database/app_database.dart';

/// Repository for transaction CRUD and query operations.
class TransactionRepository {
  TransactionRepository(this._db);

  final AppDatabase _db;

  /// Watch all transactions ordered by date descending.
  Stream<List<Transaction>> watchAllTransactions({int? limit}) {
    final query = _db.select(_db.transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    if (limit != null) {
      query.limit(limit);
    }
    return query.watch();
  }

  /// Watch transactions for a specific account.
  Stream<List<Transaction>> watchTransactionsForAccount(String accountId) {
    return (_db.select(_db.transactions)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Get transactions by date range.
  Future<List<Transaction>> getTransactionsByDateRange(
    int startDate,
    int endDate, {
    String? accountId,
    String? categoryId,
  }) {
    final query = _db.select(_db.transactions)
      ..where((t) =>
          t.date.isBiggerOrEqualValue(startDate) &
          t.date.isSmallerOrEqualValue(endDate));

    if (accountId != null) {
      query.where((t) => t.accountId.equals(accountId));
    }
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }

    query.orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.get();
  }

  /// Get all transactions (one-shot, most recent first).
  Future<List<Transaction>> getAllTransactions() {
    return (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  /// Get a single transaction by ID.
  Future<Transaction?> getTransactionById(String id) {
    return (_db.select(_db.transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Search transactions by payee name.
  Future<List<Transaction>> searchByPayee(String query) {
    return (_db.select(_db.transactions)
          ..where((t) => t.payee.contains(query))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(50))
        .get();
  }

  /// Get recent transactions (last N).
  Future<List<Transaction>> getRecentTransactions({int limit = 10}) {
    return (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(limit))
        .get();
  }

  /// Watch recent transactions.
  Stream<List<Transaction>> watchRecentTransactions({int limit = 10}) {
    return (_db.select(_db.transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(limit))
        .watch();
  }

  /// Get uncategorized transactions.
  Future<List<Transaction>> getUncategorizedTransactions() {
    return (_db.select(_db.transactions)
          ..where((t) => t.categoryId.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  /// Get unreviewed transactions.
  Future<List<Transaction>> getUnreviewedTransactions() {
    return (_db.select(_db.transactions)
          ..where((t) => t.isReviewed.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  /// Get total income for a date range.
  Future<int> getTotalIncome(int startDate, int endDate) async {
    final result = await (_db.selectOnly(_db.transactions)
          ..where(_db.transactions.amountCents.isBiggerOrEqualValue(0) &
              _db.transactions.date.isBiggerOrEqualValue(startDate) &
              _db.transactions.date.isSmallerOrEqualValue(endDate))
          ..addColumns([_db.transactions.amountCents.sum()]))
        .getSingle();
    return result.read(_db.transactions.amountCents.sum()) ?? 0;
  }

  /// Get total expenses for a date range.
  Future<int> getTotalExpenses(int startDate, int endDate) async {
    final result = await (_db.selectOnly(_db.transactions)
          ..where(_db.transactions.amountCents.isSmallerThanValue(0) &
              _db.transactions.date.isBiggerOrEqualValue(startDate) &
              _db.transactions.date.isSmallerOrEqualValue(endDate))
          ..addColumns([_db.transactions.amountCents.sum()]))
        .getSingle();
    return result.read(_db.transactions.amountCents.sum()) ?? 0;
  }

  /// Insert a new transaction.
  Future<void> insertTransaction(TransactionsCompanion transaction) {
    return _db.into(_db.transactions).insert(transaction);
  }

  /// Insert multiple transactions (batch import).
  Future<void> insertTransactions(List<TransactionsCompanion> transactions) {
    return _db.batch((batch) {
      batch.insertAll(_db.transactions, transactions);
    });
  }

  /// Update an existing transaction.
  Future<bool> updateTransaction(TransactionsCompanion transaction) {
    return (_db.update(_db.transactions)
          ..where((t) => t.id.equals(transaction.id.value)))
        .write(transaction)
        .then((rows) => rows > 0);
  }

  /// Update category for a transaction.
  Future<void> updateCategory(String transactionId, String categoryId) {
    return (_db.update(_db.transactions)
          ..where((t) => t.id.equals(transactionId)))
        .write(TransactionsCompanion(
      categoryId: Value(categoryId),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  /// Mark transaction as reviewed.
  Future<void> markReviewed(String id, {bool reviewed = true}) {
    return (_db.update(_db.transactions)..where((t) => t.id.equals(id)))
        .write(TransactionsCompanion(
      isReviewed: Value(reviewed),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  /// Delete a transaction by ID.
  Future<int> deleteTransaction(String id) {
    return (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  /// Get a transaction by its external ID.
  Future<Transaction?> getByExternalId(String externalId) {
    return (_db.select(_db.transactions)
          ..where((t) => t.externalId.equals(externalId))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Update the pending status of a transaction.
  Future<void> updatePendingStatus(String id, bool isPending) {
    return (_db.update(_db.transactions)..where((t) => t.id.equals(id)))
        .write(TransactionsCompanion(
      isPending: Value(isPending),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  /// Check for duplicate by fuzzy match: same account, amount, and date within ±3 days.
  ///
  /// This catches duplicates across sources (CSV vs SimpleFIN) where external IDs
  /// are incompatible. Payee is excluded because the same merchant appears
  /// differently across sources.
  ///
  /// [excludeExternalIdPrefix] excludes transactions from the same sync source
  /// (e.g. pass `'$connectionId:'` to skip previously-synced SimpleFIN transactions
  /// while still matching CSV and manual entries).
  Future<bool> existsByFuzzyMatch(
    String accountId,
    int dateMs,
    int amountCents, {
    String? excludeExternalIdPrefix,
  }) async {
    final windowMs = 86400000 * 3; // ±3 days
    final result = await (_db.select(_db.transactions)
          ..where((t) {
            var condition = t.accountId.equals(accountId) &
                t.amountCents.equals(amountCents) &
                t.date.isBiggerOrEqualValue(dateMs - windowMs) &
                t.date.isSmallerOrEqualValue(dateMs + windowMs);
            if (excludeExternalIdPrefix != null) {
              condition = condition &
                  (t.externalId.isNull() |
                      t.externalId.like('$excludeExternalIdPrefix%').not());
            }
            return condition;
          })
          ..limit(1))
        .get();
    return result.isNotEmpty;
  }

  /// Check for duplicate by external ID.
  Future<bool> existsByExternalId(String externalId) async {
    final result = await (_db.select(_db.transactions)
          ..where((t) => t.externalId.equals(externalId))
          ..limit(1))
        .get();
    return result.isNotEmpty;
  }

  /// Returns all externalIds for the given account that start with [prefix].
  Future<Set<String>> getExternalIdsByPrefix(
      String prefix, String accountId) async {
    final escaped = prefix
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([_db.transactions.externalId])
      ..where(_db.transactions.accountId.equals(accountId) &
          _db.transactions.externalId.like('$escaped%', escapeChar: r'\'));
    final rows = await query.get();
    return rows
        .map((row) => row.read(_db.transactions.externalId))
        .whereType<String>()
        .toSet();
  }

  /// Returns pending transactions for the given account with externalId
  /// starting with [prefix], keyed by externalId.
  Future<Map<String, Transaction>> getPendingByPrefix(
      String prefix, String accountId) async {
    final escaped = prefix
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
    final query = _db.select(_db.transactions)
      ..where((t) =>
          t.accountId.equals(accountId) &
          t.externalId.like('$escaped%', escapeChar: r'\') &
          t.isPending.equals(true));
    final rows = await query.get();
    return {
      for (final t in rows)
        if (t.externalId != null) t.externalId!: t
    };
  }

  /// Get count of uncategorized transactions.
  Future<int> getUncategorizedCount() async {
    final count = _db.transactions.id.count();
    final result = await (_db.selectOnly(_db.transactions)
          ..where(_db.transactions.categoryId.isNull())
          ..addColumns([count]))
        .getSingle();
    return result.read(count) ?? 0;
  }

  /// Get sum of amountCents grouped by accountId for transactions after [dateMs].
  /// Used for backwards net worth calculation from current balances.
  Future<Map<String, int>> getTransactionSumsAfterDate(int dateMs) async {
    final sum = _db.transactions.amountCents.sum();
    final query = _db.selectOnly(_db.transactions)
      ..where(_db.transactions.date.isBiggerThanValue(dateMs))
      ..addColumns([_db.transactions.accountId, sum])
      ..groupBy([_db.transactions.accountId]);
    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(_db.transactions.accountId)!: row.read(sum) ?? 0,
    };
  }

  /// Get monthly expense totals for the last [months] months.
  /// Returns list of (monthStart, totalExpenseCents) ordered chronologically.
  Future<List<({DateTime month, int expenseCents})>> getMonthlyExpenseTotals(
      int months) async {
    final now = DateTime.now();

    // Build month ranges and fetch all totals concurrently
    final monthStarts = List.generate(months, (i) {
      return DateTime(now.year, now.month - (months - 1 - i), 1);
    });

    final allExpenses = await Future.wait(
      monthStarts.map((month) {
        final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
        return getTotalExpenses(
          month.millisecondsSinceEpoch,
          end.millisecondsSinceEpoch,
        );
      }),
    );

    return [
      for (var i = 0; i < monthStarts.length; i++)
        (month: monthStarts[i], expenseCents: allExpenses[i].abs()),
    ];
  }

  /// Get total expenses grouped by categoryId for a list of categories in a date range.
  /// Only includes negative amounts (expenses). Returns {categoryId: totalSpentCents} (as negative values).
  Future<Map<String, int>> getTotalExpensesByCategoryIds(
    int startDate,
    int endDate,
    List<String> categoryIds,
  ) async {
    if (categoryIds.isEmpty) return {};
    final sum = _db.transactions.amountCents.sum();
    final query = _db.selectOnly(_db.transactions)
      ..where(
        _db.transactions.categoryId.isIn(categoryIds) &
            _db.transactions.amountCents.isSmallerThanValue(0) &
            _db.transactions.date.isBiggerOrEqualValue(startDate) &
            _db.transactions.date.isSmallerOrEqualValue(endDate),
      )
      ..addColumns([_db.transactions.categoryId, sum])
      ..groupBy([_db.transactions.categoryId]);
    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(_db.transactions.categoryId)!: row.read(sum) ?? 0,
    };
  }

  /// Get transaction count for a specific account.
  Future<int> getTransactionCountForAccount(String accountId) async {
    final count = _db.transactions.id.count();
    final result = await (_db.selectOnly(_db.transactions)
          ..where(_db.transactions.accountId.equals(accountId))
          ..addColumns([count]))
        .getSingle();
    return result.read(count) ?? 0;
  }

  /// Get transaction count.
  Future<int> getTransactionCount() async {
    final count = _db.transactions.id.count();
    final result = await (_db.selectOnly(_db.transactions)
          ..addColumns([count]))
        .getSingle();
    return result.read(count) ?? 0;
  }
}
