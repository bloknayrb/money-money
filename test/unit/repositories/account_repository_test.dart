import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrimonium/data/local/database/app_database.dart';
import 'package:patrimonium/data/repositories/account_repository.dart';

void main() {
  late AppDatabase database;
  late AccountRepository repo;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repo = AccountRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  AccountsCompanion makeAccount({
    required String id,
    String name = 'Test Account',
    String accountType = 'checking',
    int balanceCents = 10000,
    bool isAsset = true,
    int displayOrder = 0,
    String? bankConnectionId,
    String? externalId,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return AccountsCompanion.insert(
      id: id,
      name: name,
      accountType: accountType,
      balanceCents: balanceCents,
      isAsset: isAsset,
      displayOrder: displayOrder,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('insertAccount / getAccountById', () {
    test('inserts and retrieves an account', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1', name: 'Checking'));

      final account = await repo.getAccountById('acc-1');
      expect(account, isNotNull);
      expect(account!.name, 'Checking');
      expect(account.accountType, 'checking');
      expect(account.balanceCents, 10000);
      expect(account.isAsset, true);
    });

    test('returns null for non-existent account', () async {
      final account = await repo.getAccountById('does-not-exist');
      expect(account, isNull);
    });
  });

  group('watchAllAccounts', () {
    test('emits accounts ordered by displayOrder', () async {
      await repo.insertAccount(
          makeAccount(id: 'acc-b', name: 'B', displayOrder: 2));
      await repo.insertAccount(
          makeAccount(id: 'acc-a', name: 'A', displayOrder: 1));

      final accounts = await repo.watchAllAccounts().first;
      expect(accounts.length, 2);
      expect(accounts[0].name, 'A');
      expect(accounts[1].name, 'B');
    });

    test('excludes hidden accounts', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));
      await repo.insertAccount(makeAccount(id: 'acc-2'));
      await repo.toggleHidden('acc-2', true);

      final accounts = await repo.watchAllAccounts().first;
      expect(accounts.length, 1);
      expect(accounts[0].id, 'acc-1');
    });
  });

  group('updateBalance', () {
    test('updates balance correctly', () async {
      await repo.insertAccount(
          makeAccount(id: 'acc-1', balanceCents: 5000));

      await repo.updateBalance('acc-1', 12345);

      final account = await repo.getAccountById('acc-1');
      expect(account!.balanceCents, 12345);
    });
  });

  group('getAccountsByConnection', () {
    test('returns accounts linked to a specific connection', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));
      await repo.insertAccount(makeAccount(id: 'acc-2'));
      await repo.linkToBank('acc-1', 'conn-1', 'ext-1');

      final linked = await repo.getAccountsByConnection('conn-1');
      expect(linked.length, 1);
      expect(linked[0].id, 'acc-1');
    });

    test('returns empty list when no accounts linked', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));

      final linked = await repo.getAccountsByConnection('conn-1');
      expect(linked, isEmpty);
    });
  });

  group('linkToBank / unlinkFromBank', () {
    test('linkToBank sets connection fields', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));

      await repo.linkToBank('acc-1', 'conn-1', 'ext-abc');

      final account = await repo.getAccountById('acc-1');
      expect(account!.bankConnectionId, 'conn-1');
      expect(account.externalId, 'ext-abc');
      expect(account.lastSyncedAt, isNotNull);
    });

    test('unlinkFromBank clears connection fields', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));
      await repo.linkToBank('acc-1', 'conn-1', 'ext-abc');

      await repo.unlinkFromBank('acc-1');

      final account = await repo.getAccountById('acc-1');
      expect(account!.bankConnectionId, isNull);
      expect(account.externalId, isNull);
      expect(account.lastSyncedAt, isNull);
    });
  });

  group('getAccountCount', () {
    test('returns 0 when no accounts exist', () async {
      final count = await repo.getAccountCount();
      expect(count, 0);
    });

    test('returns correct count', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));
      await repo.insertAccount(makeAccount(id: 'acc-2'));
      await repo.insertAccount(makeAccount(id: 'acc-3'));

      final count = await repo.getAccountCount();
      expect(count, 3);
    });
  });

  group('deleteAccount', () {
    test('removes the account', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));

      await repo.deleteAccount('acc-1');

      final account = await repo.getAccountById('acc-1');
      expect(account, isNull);
    });

    test('removes associated transactions', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));
      final now = DateTime.now().millisecondsSinceEpoch;
      await database.into(database.transactions).insert(
        TransactionsCompanion.insert(
          id: 'txn-1',
          accountId: 'acc-1',
          amountCents: -500,
          date: now,
          payee: 'Store',
          createdAt: now,
          updatedAt: now,
        ),
      );

      await repo.deleteAccount('acc-1');

      final txns = await database.select(database.transactions).get();
      expect(txns, isEmpty);
    });

    test('decrements account count', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));
      await repo.insertAccount(makeAccount(id: 'acc-2'));

      await repo.deleteAccount('acc-1');

      final count = await repo.getAccountCount();
      expect(count, 1);
    });
  });

  group('getTotalAssets / getTotalLiabilities / getNetWorth', () {
    test('calculates totals correctly', () async {
      await repo.insertAccount(
          makeAccount(id: 'acc-1', balanceCents: 50000, isAsset: true));
      await repo.insertAccount(
          makeAccount(id: 'acc-2', balanceCents: 30000, isAsset: true));
      await repo.insertAccount(makeAccount(
          id: 'acc-3', balanceCents: 20000, isAsset: false));

      expect(await repo.getTotalAssets(), 80000);
      expect(await repo.getTotalLiabilities(), 20000);
      expect(await repo.getNetWorth(), 60000);
    });

    test('returns 0 when no accounts', () async {
      expect(await repo.getTotalAssets(), 0);
      expect(await repo.getTotalLiabilities(), 0);
      expect(await repo.getNetWorth(), 0);
    });

    test('excludes hidden accounts', () async {
      await repo.insertAccount(
          makeAccount(id: 'acc-1', balanceCents: 50000, isAsset: true));
      await repo.insertAccount(
          makeAccount(id: 'acc-2', balanceCents: 30000, isAsset: true));
      await repo.toggleHidden('acc-2', true);

      expect(await repo.getTotalAssets(), 50000);
    });
  });

  group('getAllAccounts', () {
    test('returns empty list when no accounts exist', () async {
      final accounts = await repo.getAllAccounts();
      expect(accounts, isEmpty);
    });

    test('excludes hidden accounts', () async {
      await repo.insertAccount(makeAccount(id: 'acc-1'));
      await repo.insertAccount(makeAccount(id: 'acc-2'));
      await repo.toggleHidden('acc-1', true);

      final accounts = await repo.getAllAccounts();
      expect(accounts.length, 1);
      expect(accounts[0].id, 'acc-2');
    });
  });

  group('getAccountsByType', () {
    test('groups accounts by type', () async {
      await repo.insertAccount(makeAccount(
          id: 'acc-1', accountType: 'checking'));
      await repo.insertAccount(makeAccount(
          id: 'acc-2', accountType: 'savings'));
      await repo.insertAccount(makeAccount(
          id: 'acc-3', accountType: 'checking'));

      final grouped = await repo.getAccountsByType();
      expect(grouped['checking']!.length, 2);
      expect(grouped['savings']!.length, 1);
    });
  });
}
