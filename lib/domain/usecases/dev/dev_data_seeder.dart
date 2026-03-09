import 'dart:math';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/transaction_repository.dart';

/// Seeds realistic dummy data for development/testing.
/// Follows the same idempotent pattern as CategorySeeder and RuleSeeder.
class DevDataSeeder {
  DevDataSeeder(this._accountRepo, this._txnRepo);

  final AccountRepository _accountRepo;
  final TransactionRepository _txnRepo;
  static const _uuid = Uuid();

  /// Seed accounts and transactions if the database is empty.
  /// Returns true if data was seeded, false if accounts already exist.
  Future<bool> seedIfEmpty() async {
    final count = await _accountRepo.getAccountCount();
    if (count > 0) return false;

    final accounts = _buildAccounts();
    for (final account in accounts) {
      await _accountRepo.insertAccount(account);
    }

    final transactions = _buildTransactions(accounts);
    await _txnRepo.insertTransactions(transactions);

    return true;
  }

  List<AccountsCompanion> _buildAccounts() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final specs = [
      ('Primary Checking', 'checking', true, 'Chase', 485000),
      ('Emergency Savings', 'savings', true, 'Ally Bank', 1250000),
      ('Rewards Credit Card', 'credit_card', false, 'Chase', 215000),
      ('Roth IRA', 'roth_ira', true, 'Fidelity', 4500000),
      ('401k', '401k', true, 'Fidelity', 8750000),
      ('Auto Loan', 'auto_loan', false, 'Capital One', 1800000),
      ('Brokerage', 'brokerage', true, 'Robinhood', 750000),
    ];

    return [
      for (var i = 0; i < specs.length; i++)
        AccountsCompanion.insert(
          id: _uuid.v4(),
          name: specs[i].$1,
          accountType: specs[i].$2,
          isAsset: specs[i].$3,
          institutionName: Value(specs[i].$4),
          balanceCents: specs[i].$5,
          displayOrder: i,
          createdAt: now,
          updatedAt: now,
        ),
    ];
  }

  List<TransactionsCompanion> _buildTransactions(
    List<AccountsCompanion> accounts,
  ) {
    final rng = Random(42);
    final now = DateTime.now();
    final createdAt = now.millisecondsSinceEpoch;
    final checkingId = accounts[0].id.value;
    final creditId = accounts[2].id.value;
    final savingsId = accounts[1].id.value;

    final txns = <TransactionsCompanion>[];

    // Template: (payee, minCents, maxCents, frequency per month, fixedDay?)
    const checkingTemplates = <_TxnTemplate>[
      // Income
      _TxnTemplate('EMPLOYER DIRECT DEPOSIT', 550000, 550000, 1, fixedDay: 1),
      _TxnTemplate('FREELANCE PAYMENT', 75000, 150000, 1),
      // Groceries
      _TxnTemplate('KROGER', -15000, -4000, 2),
      _TxnTemplate('TRADER JOES', -12000, -5000, 1),
      _TxnTemplate('WHOLE FOODS', -14000, -6000, 1),
      // Gas
      _TxnTemplate('SHELL', -5500, -3000, 2),
      _TxnTemplate('CHEVRON', -5000, -3000, 1),
      // Coffee
      _TxnTemplate('STARBUCKS', -800, -500, 6),
      // Dining
      _TxnTemplate('CHIPOTLE', -1500, -1000, 1),
      _TxnTemplate('PANERA', -2500, -1200, 2),
      // Utilities
      _TxnTemplate('XFINITY', -8999, -8999, 1, fixedDay: 5),
      _TxnTemplate('DUKE ENERGY', -18000, -12500, 1),
      // Subscriptions
      _TxnTemplate('NETFLIX', -1599, -1599, 1),
      _TxnTemplate('SPOTIFY', -1099, -1099, 1),
      // Shopping
      _TxnTemplate('AMAZON', -8000, -1500, 2),
      _TxnTemplate('TARGET', -6000, -2000, 1),
      // Gym
      _TxnTemplate('PLANET FITNESS', -2500, -2500, 1),
      // Transfers out
      _TxnTemplate('TRANSFER TO SAVINGS', -50000, -50000, 1),
      _TxnTemplate('AUTO LOAN PAYMENT', -45000, -45000, 1),
      _TxnTemplate('CREDIT CARD PAYMENT', -215000, -100000, 1),
    ];

    const creditTemplates = <_TxnTemplate>[
      _TxnTemplate('DOORDASH', -4500, -1500, 3),
      _TxnTemplate('OLIVE GARDEN', -7500, -3000, 1),
      _TxnTemplate('TEXAS ROADHOUSE', -6500, -3500, 1),
      _TxnTemplate('BEST BUY', -30000, -5000, 1), // skip some months below
      _TxnTemplate('OLD NAVY', -8000, -2000, 1),
      _TxnTemplate('TJ MAXX', -7000, -2500, 1), // skip some months below
      _TxnTemplate('AMC THEATRES', -3000, -1500, 1),
      _TxnTemplate('CVS', -4000, -1000, 1),
      _TxnTemplate('PAYMENT THANK YOU', 100000, 215000, 1),
    ];

    const savingsTemplates = <_TxnTemplate>[
      _TxnTemplate('TRANSFER FROM CHECKING', 50000, 50000, 1),
      _TxnTemplate('INTEREST PAYMENT', 350, 500, 1),
    ];

    for (var monthsAgo = 4; monthsAgo >= 0; monthsAgo--) {
      final month = DateTime(now.year, now.month - monthsAgo, 1);
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

      _generateForAccount(
        txns, checkingTemplates, checkingId, month, daysInMonth, rng, createdAt,
      );
      _generateForAccount(
        txns, creditTemplates, creditId, month, daysInMonth, rng, createdAt,
        skipTemplates: {'BEST BUY': 2, 'TJ MAXX': 2},
        monthsAgo: monthsAgo,
      );
      _generateForAccount(
        txns, savingsTemplates, savingsId, month, daysInMonth, rng, createdAt,
      );
    }

    return txns;
  }

  void _generateForAccount(
    List<TransactionsCompanion> txns,
    List<_TxnTemplate> templates,
    String accountId,
    DateTime month,
    int daysInMonth,
    Random rng,
    int createdAt, {
    Map<String, int> skipTemplates = const {},
    int monthsAgo = 0,
  }) {
    final now = DateTime.now();
    for (final t in templates) {
      // Skip some templates every N months (e.g. Best Buy every other month)
      final skipEvery = skipTemplates[t.payee];
      if (skipEvery != null && monthsAgo % skipEvery != 0) continue;

      for (var i = 0; i < t.frequency; i++) {
        final day = t.fixedDay ?? (rng.nextInt(daysInMonth) + 1);
        final txnDate = DateTime(month.year, month.month, day);
        if (txnDate.isAfter(now)) continue;

        final amount = t.minCents == t.maxCents
            ? t.minCents
            : _randomInRange(rng, t.minCents, t.maxCents);

        txns.add(TransactionsCompanion.insert(
          id: _uuid.v4(),
          accountId: accountId,
          amountCents: amount,
          date: txnDate.millisecondsSinceEpoch,
          payee: t.payee,
          createdAt: createdAt,
          updatedAt: createdAt,
        ));
      }
    }
  }

  /// Random int in [min, max] inclusive, handling cases where min > max
  /// (which happens when minCents is negative and "larger" in magnitude).
  int _randomInRange(Random rng, int a, int b) {
    final lo = a < b ? a : b;
    final hi = a < b ? b : a;
    return lo + rng.nextInt(hi - lo + 1);
  }
}

class _TxnTemplate {
  const _TxnTemplate(
    this.payee,
    this.minCents,
    this.maxCents,
    this.frequency, {
    this.fixedDay,
  });

  final String payee;
  final int minCents;
  final int maxCents;
  final int frequency;
  final int? fixedDay;
}
