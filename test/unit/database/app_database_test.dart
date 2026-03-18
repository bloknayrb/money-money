import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneymoney/data/local/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('AppDatabase', () {
    test('accounts can be created and retrieved', () async {
      await database.into(database.accounts).insert(
        AccountsCompanion.insert(
          id: 'test-id',
          name: 'Test Account',
          accountType: 'checking',
          balanceCents: 1000,
          isAsset: true,
          displayOrder: 0,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      final accounts = await database.select(database.accounts).get();
      expect(accounts.length, 1);
      expect(accounts.first.id, 'test-id');
      expect(accounts.first.name, 'Test Account');
      expect(accounts.first.balanceCents, 1000);
      expect(accounts.first.isAsset, true);
    });

    test('transactions can be created and retrieved', () async {
      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          id: 'txn-1',
          accountId: 'acc-1',
          amountCents: -500,
          date: DateTime.now().millisecondsSinceEpoch,
          payee: 'Grocery Store',
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      final transactions = await database.select(database.transactions).get();
      expect(transactions.length, 1);
      expect(transactions.first.id, 'txn-1');
      expect(transactions.first.amountCents, -500);
      expect(transactions.first.payee, 'Grocery Store');
    });
  });
}