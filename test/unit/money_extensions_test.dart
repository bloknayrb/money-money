import 'package:flutter_test/flutter_test.dart';
import 'package:moneymoney/core/extensions/money_extensions.dart';

void main() {
  group('MoneyCents.toCurrency', () {
    test('formats positive cents', () {
      expect(12345.toCurrency(), '\$123.45');
    });

    test('formats zero', () {
      expect(0.toCurrency(), '\$0.00');
    });

    test('formats negative cents', () {
      expect((-12345).toCurrency(), '-\$123.45');
    });

    test('formats single cent', () {
      expect(1.toCurrency(), '\$0.01');
    });

    test('formats large amounts with comma grouping', () {
      expect(12345678.toCurrency(), '\$123,456.78');
    });
  });

  group('MoneyCents.toCurrencyValue', () {
    test('formats without symbol', () {
      expect(12345.toCurrencyValue(), '123.45');
    });

    test('formats zero', () {
      expect(0.toCurrencyValue(), '0.00');
    });

    test('formats negative', () {
      expect((-50).toCurrencyValue(), '-0.50');
    });
  });

  group('MoneyCents.toCompactCurrency', () {
    test('returns full format for small amounts', () {
      expect(99999.toCompactCurrency(), '\$999.99');
    });

    test('formats thousands as K', () {
      expect(100000.toCompactCurrency(), '\$1.0K');
    });

    test('formats millions as M', () {
      expect(100000000.toCompactCurrency(), '\$1.0M');
    });

    test('formats negative thousands', () {
      // toCompactCurrency places symbol before the sign: $-2.5K
      expect((-250000).toCompactCurrency(), '\$-2.5K');
    });
  });

  group('MoneyCents income/expense helpers', () {
    test('positive is income', () {
      expect(100.isIncome, true);
      expect(100.isExpense, false);
    });

    test('negative is expense', () {
      expect((-100).isIncome, false);
      expect((-100).isExpense, true);
    });

    test('zero is neither', () {
      expect(0.isIncome, false);
      expect(0.isExpense, false);
    });
  });

  group('CurrencyParsing.toCents', () {
    test('parses plain decimal', () {
      expect('123.45'.toCents(), 12345);
    });

    test('parses with dollar sign', () {
      expect('\$123.45'.toCents(), 12345);
    });

    test('parses with commas', () {
      expect('1,234.56'.toCents(), 123456);
    });

    test('parses negative', () {
      expect('-50.00'.toCents(), -5000);
    });

    test('parses whole dollars', () {
      expect('100'.toCents(), 10000);
    });

    test('returns null for non-numeric', () {
      expect('abc'.toCents(), isNull);
    });

    test('returns null for empty string', () {
      expect(''.toCents(), isNull);
    });

    test('rounds half cents', () {
      // double.parse('1.005') * 100 = 100.49999... due to floating point,
      // .round() gives 100
      expect('1.005'.toCents(), 100);
    });

    test('parses with surrounding whitespace', () {
      expect('  123.45  '.toCents(), 12345);
    });

    test('returns null for multiple decimals', () {
      expect('123.45.6'.toCents(), isNull);
    });

    test('returns null for completely invalid formats', () {
      expect('\$'.toCents(), isNull);
      expect('-'.toCents(), isNull);
      expect('abc.def'.toCents(), isNull);
    });
  });

  group('UnixMillisToDate', () {
    test('converts milliseconds to DateTime', () {
      // fromMillisecondsSinceEpoch returns local time, use a value that
      // won't shift date across timezone boundaries
      final dt = 1704110400000.toDateTime(); // 2024-01-01 12:00:00 UTC
      expect(dt.year, 2024);
      expect(dt.month, 1);
      expect(dt.day, 1);
    });
  });

  group('DateFormatting.toRelative', () {
    test('returns Today for today', () {
      expect(DateTime.now().toRelative(), 'Today');
    });

    test('returns Yesterday for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.toRelative(), 'Yesterday');
    });
  });

  group('DateFormatting date boundaries', () {
    test('startOfDay is midnight', () {
      final dt = DateTime(2026, 3, 15, 14, 30, 45);
      final start = dt.startOfDay;
      expect(start, DateTime(2026, 3, 15));
    });

    test('endOfDay is 23:59:59.999', () {
      final dt = DateTime(2026, 3, 15, 14, 30);
      final end = dt.endOfDay;
      expect(end, DateTime(2026, 3, 15, 23, 59, 59, 999));
    });

    test('startOfMonth is first day', () {
      final dt = DateTime(2026, 3, 15);
      expect(dt.startOfMonth, DateTime(2026, 3, 1));
    });

    test('endOfMonth is last day', () {
      final dt = DateTime(2026, 2, 10);
      final end = dt.endOfMonth;
      expect(end.day, 28); // 2026 is not a leap year
      expect(end.hour, 23);
    });
  });
}
