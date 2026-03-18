import 'package:flutter_test/flutter_test.dart';

import 'package:moneymoney/data/local/database/app_database.dart';
import 'package:moneymoney/domain/usecases/forecasting/cash_flow_forecast_service.dart';

void main() {
  late CashFlowForecastService service;

  setUp(() {
    service = CashFlowForecastService();
  });

  Account _makeAccount(String id, String name, int balanceCents,
      {bool isAsset = true}) {
    return Account(
      id: id,
      name: name,
      accountType: isAsset ? 'checking' : 'credit_card',
      balanceCents: balanceCents,
      currencyCode: 'USD',
      isAsset: isAsset,
      isHidden: false,
      invertSign: false,
      displayOrder: 0,
      createdAt: 0,
      updatedAt: 0,
      version: 1,
      syncStatus: 0,
    );
  }

  RecurringTransaction _makeRecurring({
    required String id,
    required String payee,
    required int amountCents,
    required String accountId,
    required String frequency,
    required DateTime nextDate,
  }) {
    return RecurringTransaction(
      id: id,
      payee: payee,
      amountCents: amountCents,
      categoryId: null,
      accountId: accountId,
      frequency: frequency,
      nextExpectedDate: nextDate.millisecondsSinceEpoch,
      lastOccurrenceDate: 0,
      isSubscription: false,
      isActive: true,
      notes: null,
      createdAt: 0,
      updatedAt: 0,
    );
  }

  test('returns empty forecast with no accounts', () {
    final result = service.forecast(
        accounts: [], recurring: [], daysAhead: 30);
    // Day 0 (today) is always included
    expect(result.days.length, 31);
    expect(result.days.first.projectedBalanceCents, 0);
    expect(result.alerts, isEmpty);
  });

  test('projects balance with no recurring transactions', () {
    final result = service.forecast(
      accounts: [_makeAccount('a1', 'Checking', 500000)],
      recurring: [],
      daysAhead: 30,
    );

    // Balance should stay constant
    for (final day in result.days) {
      expect(day.projectedBalanceCents, 500000);
      expect(day.transactions, isEmpty);
    }
  });

  test('applies monthly recurring transaction', () {
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);

    final result = service.forecast(
      accounts: [_makeAccount('a1', 'Checking', 200000)],
      recurring: [
        _makeRecurring(
          id: 'r1',
          payee: 'Rent',
          amountCents: -150000,
          accountId: 'a1',
          frequency: 'monthly',
          nextDate: tomorrow,
        ),
      ],
      daysAhead: 60,
    );

    // Day 0: $2000
    expect(result.days[0].projectedBalanceCents, 200000);
    // Day 1 (tomorrow): $2000 - $1500 = $500
    expect(result.days[1].projectedBalanceCents, 50000);
    expect(result.days[1].transactions.length, 1);
    expect(result.days[1].transactions.first.payee, 'Rent');
  });

  test('applies weekly recurring correctly', () {
    final today = DateTime.now();
    final startDate = DateTime(today.year, today.month, today.day);

    final result = service.forecast(
      accounts: [_makeAccount('a1', 'Checking', 100000)],
      recurring: [
        _makeRecurring(
          id: 'r1',
          payee: 'Weekly Sub',
          amountCents: -1000,
          accountId: 'a1',
          frequency: 'weekly',
          nextDate: startDate,
        ),
      ],
      daysAhead: 28,
    );

    // Should have 4 weekly transactions (days 0, 7, 14, 21) + day 28 = 5
    final daysWithTxns =
        result.days.where((d) => d.transactions.isNotEmpty).length;
    expect(daysWithTxns, 5); // day 0, 7, 14, 21, 28
    // Final balance: 100000 - (5 * 1000) = 95000
    expect(result.days.last.projectedBalanceCents, 95000);
  });

  test('generates balance alert when total goes negative', () {
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);

    final result = service.forecast(
      accounts: [_makeAccount('a1', 'Checking', 100000)],
      recurring: [
        _makeRecurring(
          id: 'r1',
          payee: 'Big Payment',
          amountCents: -150000,
          accountId: 'a1',
          frequency: 'monthly',
          nextDate: tomorrow,
        ),
      ],
      daysAhead: 30,
    );

    expect(result.alerts, isNotEmpty);
    expect(result.alerts.first.triggerPayee, 'Big Payment');
    expect(result.alerts.first.projectedBalanceCents, -50000);
  });

  test('handles empty recurring list gracefully', () {
    final result = service.forecast(
      accounts: [_makeAccount('a1', 'Checking', 100000)],
      recurring: [],
      daysAhead: 90,
    );

    expect(result.days.length, 91);
    expect(result.alerts, isEmpty);
  });

  test('handles income recurring transactions', () {
    final today = DateTime.now();
    final nextDate = DateTime(today.year, today.month, today.day + 5);

    final result = service.forecast(
      accounts: [_makeAccount('a1', 'Checking', 100000)],
      recurring: [
        _makeRecurring(
          id: 'r1',
          payee: 'Paycheck',
          amountCents: 300000,
          accountId: 'a1',
          frequency: 'biweekly',
          nextDate: nextDate,
        ),
      ],
      daysAhead: 30,
    );

    // Day 5: 100000 + 300000 = 400000
    expect(result.days[5].projectedBalanceCents, 400000);
    expect(result.days[5].transactions.first.payee, 'Paycheck');
  });
}
