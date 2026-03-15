import 'dart:convert';

/// Loan parameters for amortization calculations.
class LoanParams {
  /// Annual interest rate in basis points (e.g. 650 = 6.50%).
  final int interestRateBps;

  /// Original loan amount in cents.
  final int originalBalanceCents;

  /// Loan term in months.
  final int loanTermMonths;

  /// Origination date as Unix milliseconds.
  final int originationDate;

  const LoanParams({
    required this.interestRateBps,
    required this.originalBalanceCents,
    required this.loanTermMonths,
    required this.originationDate,
  });

  double get annualRatePercent => interestRateBps / 100.0;
  double get monthlyRate => interestRateBps / 10000.0 / 12.0;

  /// Calculate monthly payment in cents.
  int get monthlyPaymentCents {
    final r = monthlyRate;
    if (r == 0) return originalBalanceCents ~/ loanTermMonths;
    final principal = originalBalanceCents / 100.0;
    final payment = principal * r / (1 - _pow(1 + r, -loanTermMonths));
    return (payment * 100).round();
  }

  /// Generate the full amortization schedule.
  List<AmortizationEntry> get schedule {
    final r = monthlyRate;
    final paymentDollars = monthlyPaymentCents / 100.0;
    var balanceDollars = originalBalanceCents / 100.0;
    final originDate = DateTime.fromMillisecondsSinceEpoch(originationDate);

    final entries = <AmortizationEntry>[];
    for (var month = 1; month <= loanTermMonths && balanceDollars > 0.005; month++) {
      final interestDollars = balanceDollars * r;
      var principalDollars = paymentDollars - interestDollars;

      // Last payment adjustment
      if (principalDollars > balanceDollars) {
        principalDollars = balanceDollars;
      }

      balanceDollars -= principalDollars;
      if (balanceDollars < 0.005) balanceDollars = 0;

      final paymentDate = DateTime(
        originDate.year,
        originDate.month + month,
        originDate.day,
      );

      entries.add(AmortizationEntry(
        month: month,
        date: paymentDate,
        paymentCents: ((principalDollars + interestDollars) * 100).round(),
        principalCents: (principalDollars * 100).round(),
        interestCents: (interestDollars * 100).round(),
        remainingBalanceCents: (balanceDollars * 100).round(),
      ));
    }
    return entries;
  }

  Map<String, dynamic> toJson() => {
        'interestRateBps': interestRateBps,
        'originalBalanceCents': originalBalanceCents,
        'loanTermMonths': loanTermMonths,
        'originationDate': originationDate,
      };

  factory LoanParams.fromJson(Map<String, dynamic> json) => LoanParams(
        interestRateBps: json['interestRateBps'] as int,
        originalBalanceCents: json['originalBalanceCents'] as int,
        loanTermMonths: json['loanTermMonths'] as int,
        originationDate: json['originationDate'] as int,
      );

  String encode() => jsonEncode(toJson());

  static LoanParams? decode(String? value) {
    if (value == null) return null;
    try {
      return LoanParams.fromJson(jsonDecode(value) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}

/// A single row in the amortization schedule.
class AmortizationEntry {
  final int month;
  final DateTime date;
  final int paymentCents;
  final int principalCents;
  final int interestCents;
  final int remainingBalanceCents;

  const AmortizationEntry({
    required this.month,
    required this.date,
    required this.paymentCents,
    required this.principalCents,
    required this.interestCents,
    required this.remainingBalanceCents,
  });
}

/// Simple power function for doubles.
double _pow(double base, int exponent) {
  if (exponent == 0) return 1.0;
  if (exponent < 0) return 1.0 / _pow(base, -exponent);
  var result = 1.0;
  for (var i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
