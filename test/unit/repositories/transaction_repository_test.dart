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
}
