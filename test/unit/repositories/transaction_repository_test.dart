import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrimonium/data/local/database/app_database.dart';
import 'package:patrimonium/data/repositories/transaction_repository.dart';

void main() {
  late AppDatabase database;
  late TransactionRepository repo;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repo = TransactionRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('getTransactionSumsAfterDate', () {
    final now = DateTime.now().millisecondsSinceEpoch;
    final cutoffDate = now - 86400000 * 5; // 5 days ago
    final beforeCutoff = cutoffDate - 86400000; // 6 days ago
    final afterCutoff = cutoffDate + 86400000; // 4 days ago
    final recentDate = now - 86400000; // 1 day ago

    Future<void> insertTxn(
        String id, String accountId, int amountCents, int date) async {
      await database.into(database.transactions).insert(
            TransactionsCompanion.insert(
              id: id,
              accountId: accountId,
              amountCents: amountCents,
              date: date,
              payee: 'Test',
              createdAt: now,
              updatedAt: now,
            ),
          );
    }

    test('returns correct sums per account for transactions after cutoff',
        () async {
      // Arrange: two accounts with transactions before and after cutoff
      await insertTxn('t1', 'acc-1', -5000, afterCutoff);
      await insertTxn('t2', 'acc-1', -3000, recentDate);
      await insertTxn('t3', 'acc-2', 10000, afterCutoff);
      await insertTxn('t4', 'acc-1', -2000, beforeCutoff); // before cutoff

      // Act
      final sums = await repo.getTransactionSumsAfterDate(cutoffDate);

      // Assert
      expect(sums['acc-1'], -8000); // -5000 + -3000
      expect(sums['acc-2'], 10000);
      expect(sums.containsKey('acc-1'), true);
      expect(sums.containsKey('acc-2'), true);
      expect(sums.length, 2);
    });

    test('excludes transactions at exactly the cutoff date', () async {
      // Arrange: transaction exactly at cutoff should NOT be included
      await insertTxn('t1', 'acc-1', -5000, cutoffDate);
      await insertTxn('t2', 'acc-1', -3000, afterCutoff);

      // Act
      final sums = await repo.getTransactionSumsAfterDate(cutoffDate);

      // Assert: only the one after cutoff is included
      expect(sums['acc-1'], -3000);
    });

    test('returns empty map when no transactions after cutoff', () async {
      // Arrange: only transactions before cutoff
      await insertTxn('t1', 'acc-1', -5000, beforeCutoff);

      // Act
      final sums = await repo.getTransactionSumsAfterDate(cutoffDate);

      // Assert
      expect(sums, isEmpty);
    });

    test('handles mix of positive and negative amounts', () async {
      // Arrange: income and expenses in the same account
      await insertTxn('t1', 'acc-1', -5000, afterCutoff);
      await insertTxn('t2', 'acc-1', 12000, recentDate);

      // Act
      final sums = await repo.getTransactionSumsAfterDate(cutoffDate);

      // Assert
      expect(sums['acc-1'], 7000); // -5000 + 12000
    });
  });

  group('getTotalExpensesByCategoryIds', () {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rangeStart = now - 86400000 * 30; // 30 days ago
    final rangeEnd = now;
    final inRange = now - 86400000 * 15; // 15 days ago
    final beforeRange = rangeStart - 86400000; // 31 days ago
    final afterRange = rangeEnd + 86400000; // 1 day in future

    Future<void> insertTxn(
        String id, int amountCents, int date, String? categoryId) async {
      await database.into(database.transactions).insert(
            TransactionsCompanion.insert(
              id: id,
              accountId: 'acc-1',
              amountCents: amountCents,
              date: date,
              payee: 'Test',
              createdAt: now,
              updatedAt: now,
              categoryId: Value(categoryId),
            ),
          );
    }

    test('returns grouped expense totals by categoryId', () async {
      // Arrange
      await insertTxn('t1', -5000, inRange, 'cat-a');
      await insertTxn('t2', -3000, inRange, 'cat-a');
      await insertTxn('t3', -2000, inRange, 'cat-b');

      // Act
      final result = await repo.getTotalExpensesByCategoryIds(
          rangeStart, rangeEnd, ['cat-a', 'cat-b']);

      // Assert
      expect(result['cat-a'], -8000);
      expect(result['cat-b'], -2000);
    });

    test('excludes positive amounts (income)', () async {
      // Arrange
      await insertTxn('t1', -5000, inRange, 'cat-a');
      await insertTxn('t2', 10000, inRange, 'cat-a'); // income

      // Act
      final result = await repo.getTotalExpensesByCategoryIds(
          rangeStart, rangeEnd, ['cat-a']);

      // Assert
      expect(result['cat-a'], -5000);
    });

    test('returns empty map for empty categoryIds list', () async {
      // Arrange
      await insertTxn('t1', -5000, inRange, 'cat-a');

      // Act
      final result = await repo.getTotalExpensesByCategoryIds(
          rangeStart, rangeEnd, []);

      // Assert
      expect(result, isEmpty);
    });

    test('respects date range boundaries', () async {
      // Arrange
      await insertTxn('t1', -1000, beforeRange, 'cat-a'); // before range
      await insertTxn('t2', -2000, inRange, 'cat-a'); // in range
      await insertTxn('t3', -3000, afterRange, 'cat-a'); // after range
      await insertTxn('t4', -4000, rangeStart, 'cat-a'); // at start boundary
      await insertTxn('t5', -5000, rangeEnd, 'cat-a'); // at end boundary

      // Act
      final result = await repo.getTotalExpensesByCategoryIds(
          rangeStart, rangeEnd, ['cat-a']);

      // Assert: includes boundaries and in-range, excludes before/after
      expect(result['cat-a'], -11000); // -2000 + -4000 + -5000
    });

    test('omits categories with no matching expenses', () async {
      // Arrange
      await insertTxn('t1', -5000, inRange, 'cat-a');

      // Act
      final result = await repo.getTotalExpensesByCategoryIds(
          rangeStart, rangeEnd, ['cat-a', 'cat-b']);

      // Assert
      expect(result['cat-a'], -5000);
      expect(result.containsKey('cat-b'), false);
    });
  });
}
