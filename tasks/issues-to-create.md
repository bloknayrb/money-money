# Issues to Create

Found during code review of the `existsByFuzzyMatch` changes.

---

## Issue 1: Hoist magic number 86400000 (ms/day) into a shared constant

**Priority:** Low

### Problem

The magic number `86400000` (milliseconds per day) is used in multiple places without a shared constant:

- `lib/data/repositories/transaction_repository.dart` — `existsByFuzzyMatch` fuzzy date window
- `lib/domain/usecases/sync/simplefin_sync_service.dart` — sync window calculations
- `test/unit/repositories/transaction_repository_test.dart` — test date arithmetic

### Suggested Fix

Define a constant like `const millisecondsPerDay = 86400000;` in `core/constants/` and use it across all call sites. The inline comment `// ±3 days` makes intent clear today, but a named constant would be more self-documenting and prevent copy-paste errors.

---

## Issue 2: Escape SQL wildcards in existsByFuzzyMatch LIKE prefix

**Priority:** Low (defensive hardening)

### Problem

`TransactionRepository.existsByFuzzyMatch` uses a Drift `like()` expression with user-provided prefix:

```dart
t.externalId.like('$excludeExternalIdPrefix%').not()
```

If `excludeExternalIdPrefix` contains `%` or `_`, these are interpreted as SQL LIKE wildcards, causing broader matches than intended.

**Current risk: Very low** — the only caller passes a UUID-based connection ID (hex + hyphens), which can never contain `%` or `_`.

### Suggested Fix

Escape `%` → `\%` and `_` → `\_` in the prefix before passing to `like()`, or use a substring comparison instead of LIKE:

```dart
// Option 1: Escape wildcards
final escaped = excludeExternalIdPrefix
    .replaceAll('%', r'\%')
    .replaceAll('_', r'\_');
t.externalId.like('$escaped%', escape: '\\').not()

// Option 2: Use length-based substring comparison (no wildcards at all)
```

---

## Issue 3: N+1 query in SimpleFIN sync: getByExternalId called per transaction

**Priority:** Medium — impacts sync performance for high-transaction accounts

### Problem

In `SimplefinSyncService._syncAccountTransactions`, each transaction in the sync batch triggers a separate `getByExternalId` database query:

```dart
for (final sfTxn in sfAccount.transactions) {
  final externalId = '$externalIdPrefix${sfTxn.id}';
  final existing = await _transactionRepo.getByExternalId(externalId);
  // ...
}
```

For accounts with many transactions (e.g., credit cards with 50-100+ monthly transactions), this results in 50-100+ individual SELECT queries per sync.

### Suggested Fix

Batch-fetch existing transactions by external ID prefix before the loop:

```dart
// Before the loop: fetch all existing transactions for this connection+account
final existingByExternalId = await _transactionRepo
    .getByExternalIdPrefix(externalIdPrefix, accountId: localAccount.id);

for (final sfTxn in sfAccount.transactions) {
  final existing = existingByExternalId['$externalIdPrefix${sfTxn.id}'];
  // ...
}
```

This replaces N queries with 1 query.
