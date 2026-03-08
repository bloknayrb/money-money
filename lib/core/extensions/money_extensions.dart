import 'package:intl/intl.dart';

/// Extensions on [int] for formatting cents to currency strings.
///
/// All money values in the app are stored as integer cents.
/// Example: $123.45 is stored as 12345.
extension MoneyCents on int {
  /// Format cents as a currency string. 12345 → "$123.45"
  String toCurrency({String symbol = '\$', String locale = 'en_US'}) {
    final dollars = this / 100;
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(dollars);
  }

  /// Format cents as a compact currency string. 123456 → "$1.2K"
  String toCompactCurrency({String symbol = '\$'}) {
    final dollars = this / 100;
    if (dollars.abs() >= 1000000) {
      return '$symbol${(dollars / 1000000).toStringAsFixed(1)}M';
    } else if (dollars.abs() >= 1000) {
      return '$symbol${(dollars / 1000).toStringAsFixed(1)}K';
    }
    return toCurrency(symbol: symbol);
  }

  /// Format cents without the currency symbol. 12345 → "123.45"
  String toCurrencyValue() {
    final dollars = this / 100;
    return dollars.toStringAsFixed(2);
  }

  /// Whether this amount represents income (positive).
  bool get isIncome => this > 0;

  /// Whether this amount represents an expense (negative).
  bool get isExpense => this < 0;
}

/// Parse a currency string to cents.
extension CurrencyParsing on String {
  /// Parse a currency string to integer cents.
  /// "$123.45" → 12345, "123.45" → 12345, "1,234.56" → 123456
  int? toCents() {
    try {
      // Reject any string containing unexpected characters
      if (RegExp(r'[^\d\.\,\-\$\s]').hasMatch(this)) return null;

      final cleaned = replaceAll(RegExp(r'[^\d.\-]'), '');
      if (cleaned.isEmpty || cleaned == '-' || cleaned == '.') return null;

      final dollars = double.parse(cleaned);
      return (dollars * 100).round();
    } catch (_) {
      return null;
    }
  }
}

/// Date formatting extensions.
extension DateFormatting on DateTime {
  /// Format as "Jan 15, 2026"
  String toMediumDate() => DateFormat.yMMMd().format(this);

  /// Format as "January 15, 2026"
  String toLongDate() => DateFormat.yMMMMd().format(this);

  /// Format as "1/15/26"
  String toShortDate() => DateFormat.yMd().format(this);

  /// Format as "Jan 15"
  String toMonthDay() => DateFormat.MMMd().format(this);

  /// Format as "January 2026"
  String toMonthYear() => DateFormat.yMMMM().format(this);

  /// Format as relative time: "Today", "Yesterday", "Jan 15"
  String toRelative() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(year, month, day);

    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (date.isAfter(today.subtract(const Duration(days: 7)))) {
      return DateFormat.EEEE().format(this); // "Monday"
    }
    return toMediumDate();
  }

  /// Unix milliseconds since epoch.
  int get unixMillis => millisecondsSinceEpoch;

  /// Start of day (midnight).
  DateTime get startOfDay => DateTime(year, month, day);

  /// End of day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// First day of the current month.
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Last day of the current month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);
}

/// Convert Unix milliseconds to DateTime.
extension UnixMillisToDate on int {
  DateTime toDateTime() => DateTime.fromMillisecondsSinceEpoch(this);
}
