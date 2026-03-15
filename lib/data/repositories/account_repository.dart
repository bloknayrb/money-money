import 'package:drift/drift.dart';

import '../local/database/app_database.dart';

/// Repository for account CRUD operations.
class AccountRepository {
  AccountRepository(this._db);

  final AppDatabase _db;

  /// Watch all visible accounts ordered by display order.
  Stream<List<Account>> watchAllAccounts() {
    return (_db.select(_db.accounts)
          ..where((a) => a.isHidden.equals(false))
          ..orderBy([
            (a) => OrderingTerm.asc(a.displayOrder),
          ]))
        .watch();
  }

  /// Watch all accounts including hidden ones.
  Stream<List<Account>> watchAllAccountsIncludingHidden() {
    return (_db.select(_db.accounts)
          ..orderBy([
            (a) => OrderingTerm.asc(a.displayOrder),
          ]))
        .watch();
  }

  /// Get all accounts (one-shot).
  Future<List<Account>> getAllAccounts() {
    return (_db.select(_db.accounts)
          ..where((a) => a.isHidden.equals(false))
          ..orderBy([
            (a) => OrderingTerm.asc(a.displayOrder),
          ]))
        .get();
  }

  /// Get a single account by ID.
  Future<Account?> getAccountById(String id) {
    return (_db.select(_db.accounts)..where((a) => a.id.equals(id)))
        .getSingleOrNull();
  }

  /// Watch a single account by ID.
  Stream<Account?> watchAccountById(String id) {
    return (_db.select(_db.accounts)..where((a) => a.id.equals(id)))
        .watchSingleOrNull();
  }

  /// Get accounts grouped by type.
  Future<Map<String, List<Account>>> getAccountsByType() async {
    final accounts = await getAllAccounts();
    final grouped = <String, List<Account>>{};
    for (final account in accounts) {
      grouped.putIfAbsent(account.accountType, () => []).add(account);
    }
    return grouped;
  }

  /// Get total balance for asset accounts.
  Future<int> getTotalAssets() async {
    final result = await (_db.selectOnly(_db.accounts)
          ..where(_db.accounts.isAsset.equals(true) &
              _db.accounts.isHidden.equals(false))
          ..addColumns([_db.accounts.balanceCents.sum()]))
        .getSingle();
    return result.read(_db.accounts.balanceCents.sum()) ?? 0;
  }

  /// Get total balance for liability accounts.
  Future<int> getTotalLiabilities() async {
    final result = await (_db.selectOnly(_db.accounts)
          ..where(_db.accounts.isAsset.equals(false) &
              _db.accounts.isHidden.equals(false))
          ..addColumns([_db.accounts.balanceCents.sum()]))
        .getSingle();
    return result.read(_db.accounts.balanceCents.sum()) ?? 0;
  }

  /// Calculate net worth (assets - liabilities).
  Future<int> getNetWorth() async {
    final assets = await getTotalAssets();
    final liabilities = await getTotalLiabilities();
    return assets - liabilities;
  }

  /// Watch net worth as a stream.
  Stream<int> watchNetWorth() {
    return watchAllAccounts().map((accounts) {
      int assets = 0;
      int liabilities = 0;
      for (final account in accounts) {
        if (account.isAsset) {
          assets += account.balanceCents;
        } else {
          liabilities += account.balanceCents;
        }
      }
      return assets - liabilities;
    });
  }

  /// Insert a new account.
  Future<void> insertAccount(AccountsCompanion account) {
    return _db.into(_db.accounts).insert(account);
  }

  /// Update an existing account.
  Future<bool> updateAccount(AccountsCompanion account) {
    return (_db.update(_db.accounts)
          ..where((a) => a.id.equals(account.id.value)))
        .write(account)
        .then((rows) => rows > 0);
  }

  /// Update account balance.
  Future<void> updateBalance(String id, int balanceCents) {
    return (_db.update(_db.accounts)..where((a) => a.id.equals(id)))
        .write(AccountsCompanion(
      balanceCents: Value(balanceCents),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  /// Toggle account visibility.
  Future<void> toggleHidden(String id, bool isHidden) {
    return (_db.update(_db.accounts)..where((a) => a.id.equals(id)))
        .write(AccountsCompanion(
      isHidden: Value(isHidden),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  /// Delete an account and all associated data (transactions, recurring,
  /// holdings). Nulls out references from goals and transfer transactions.
  Future<void> deleteAccount(String id) async {
    await _db.transaction(() async {
      // Delete recurring transactions for this account
      await (_db.delete(_db.recurringTransactions)
            ..where((r) => r.accountId.equals(id)))
          .go();

      // Delete investment holdings for this account
      await (_db.delete(_db.investmentHoldings)
            ..where((h) => h.accountId.equals(id)))
          .go();

      // Null out linkedAccountId on goals referencing this account
      await (_db.update(_db.goals)
            ..where((g) => g.linkedAccountId.equals(id)))
          .write(const GoalsCompanion(linkedAccountId: Value(null)));

      // Null out transferAccountId on transactions referencing this account
      await (_db.update(_db.transactions)
            ..where((t) => t.transferAccountId.equals(id)))
          .write(const TransactionsCompanion(transferAccountId: Value(null)));

      // Delete all transactions belonging to this account
      await (_db.delete(_db.transactions)
            ..where((t) => t.accountId.equals(id)))
          .go();

      // Delete the account itself
      await (_db.delete(_db.accounts)..where((a) => a.id.equals(id))).go();
    });
  }

  /// Link an account to a bank connection.
  Future<void> linkToBank(
    String accountId,
    String bankConnectionId,
    String externalId,
  ) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (_db.update(_db.accounts)..where((a) => a.id.equals(accountId)))
        .write(AccountsCompanion(
      bankConnectionId: Value(bankConnectionId),
      externalId: Value(externalId),
      lastSyncedAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  /// Unlink an account from its bank connection.
  Future<void> unlinkFromBank(String accountId) {
    return (_db.update(_db.accounts)..where((a) => a.id.equals(accountId)))
        .write(AccountsCompanion(
      bankConnectionId: const Value(null),
      externalId: const Value(null),
      lastSyncedAt: const Value(null),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  /// Get all accounts linked to a specific bank connection.
  Future<List<Account>> getAccountsByConnection(String bankConnectionId) {
    return (_db.select(_db.accounts)
          ..where((a) => a.bankConnectionId.equals(bankConnectionId))
          ..orderBy([(a) => OrderingTerm.asc(a.displayOrder)]))
        .get();
  }

  /// Update the last synced timestamp for an account.
  Future<void> updateLastSyncedAt(String accountId) {
    return (_db.update(_db.accounts)..where((a) => a.id.equals(accountId)))
        .write(AccountsCompanion(
      lastSyncedAt: Value(DateTime.now().millisecondsSinceEpoch),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  /// Find an account by its external ID (regardless of which connection it belongs to).
  Future<Account?> getAccountByExternalId(String externalId) {
    return (_db.select(_db.accounts)
          ..where((a) => a.externalId.equals(externalId)))
        .getSingleOrNull();
  }

  /// Get count of accounts.
  Future<int> getAccountCount() async {
    final count = _db.accounts.id.count();
    final result = await (_db.selectOnly(_db.accounts)
          ..addColumns([count]))
        .getSingle();
    return result.read(count) ?? 0;
  }
}
