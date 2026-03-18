import 'package:flutter_test/flutter_test.dart';
import 'package:moneymoney/domain/usecases/retirement/monte_carlo_service.dart';

void main() {
  group('MonteCarloService', () {
    test('percentile bands are correctly ordered (p10 < p25 < p50 < p75 < p90)', () {
      final input = MonteCarloInput(
        currentBalanceCents: 5000000, // $50,000
        monthlyContributionCents: 50000, // $500/month
        annualReturn: 0.045,
        annualVolatility: 0.15,
        yearsToRetirement: 20,
      );

      final result = runMonteCarloSimulation(input);

      // Check at each year that percentiles are ordered
      for (var i = 0; i < result.years.length; i++) {
        expect(result.p10[i], lessThanOrEqualTo(result.p25[i]),
            reason: 'p10 <= p25 at year ${result.years[i]}');
        expect(result.p25[i], lessThanOrEqualTo(result.p50[i]),
            reason: 'p25 <= p50 at year ${result.years[i]}');
        expect(result.p50[i], lessThanOrEqualTo(result.p75[i]),
            reason: 'p50 <= p75 at year ${result.years[i]}');
        expect(result.p75[i], lessThanOrEqualTo(result.p90[i]),
            reason: 'p75 <= p90 at year ${result.years[i]}');
      }
    });

    test('returns correct number of years', () {
      final input = MonteCarloInput(
        currentBalanceCents: 1000000,
        monthlyContributionCents: 10000,
        annualReturn: 0.045,
        annualVolatility: 0.15,
        yearsToRetirement: 30,
      );

      final result = runMonteCarloSimulation(input);

      // Should have year 0 through year 30 = 31 entries
      expect(result.years.length, 31);
      expect(result.p10.length, 31);
      expect(result.p50.length, 31);
      expect(result.p90.length, 31);
      expect(result.years.first, 0);
      expect(result.years.last, 30);
    });

    test('year 0 values equal starting balance', () {
      const startBalance = 10000000; // $100,000
      final input = MonteCarloInput(
        currentBalanceCents: startBalance,
        monthlyContributionCents: 50000,
        annualReturn: 0.045,
        annualVolatility: 0.15,
        yearsToRetirement: 10,
      );

      final result = runMonteCarloSimulation(input);

      // At year 0, all percentiles should equal the starting balance
      expect(result.p10[0], startBalance);
      expect(result.p25[0], startBalance);
      expect(result.p50[0], startBalance);
      expect(result.p75[0], startBalance);
      expect(result.p90[0], startBalance);
    });

    test('handles zero years to retirement', () {
      final input = MonteCarloInput(
        currentBalanceCents: 5000000,
        monthlyContributionCents: 50000,
        annualReturn: 0.045,
        annualVolatility: 0.15,
        yearsToRetirement: 0,
      );

      final result = runMonteCarloSimulation(input);

      expect(result.years.length, 1);
      expect(result.p50[0], 5000000);
    });

    test('handles negative years to retirement', () {
      final input = MonteCarloInput(
        currentBalanceCents: 5000000,
        monthlyContributionCents: 50000,
        annualReturn: 0.045,
        annualVolatility: 0.15,
        yearsToRetirement: -5,
      );

      final result = runMonteCarloSimulation(input);

      expect(result.years.length, 1);
      expect(result.p50[0], 5000000);
    });

    test('final median exceeds contributions-only (returns add value)', () {
      const startBalance = 0;
      const monthlyContribution = 100000; // $1,000/month
      const years = 20;
      final input = MonteCarloInput(
        currentBalanceCents: startBalance,
        monthlyContributionCents: monthlyContribution,
        annualReturn: 0.045,
        annualVolatility: 0.15,
        yearsToRetirement: years,
      );

      final result = runMonteCarloSimulation(input);

      // Total contributions = $1,000 * 12 * 20 = $240,000 = 24,000,000 cents
      const totalContributions = monthlyContribution * 12 * years;
      // With 4.5% real return, median should be well above contributions-only
      expect(result.p50.last, greaterThan(totalContributions));
    });

    test('higher volatility produces wider spread between p10 and p90', () {
      final lowVol = MonteCarloInput(
        currentBalanceCents: 5000000,
        monthlyContributionCents: 50000,
        annualReturn: 0.045,
        annualVolatility: 0.05, // low vol
        yearsToRetirement: 20,
      );

      const highVol = MonteCarloInput(
        currentBalanceCents: 5000000,
        monthlyContributionCents: 50000,
        annualReturn: 0.045,
        annualVolatility: 0.25, // high vol
        yearsToRetirement: 20,
      );

      final lowResult = runMonteCarloSimulation(lowVol);
      final highResult = runMonteCarloSimulation(highVol);

      final lowSpread = lowResult.p90.last - lowResult.p10.last;
      final highSpread = highResult.p90.last - highResult.p10.last;

      expect(highSpread, greaterThan(lowSpread),
          reason: 'Higher volatility should produce wider spread');
    });

    test('deterministic output with same seed', () {
      const input = MonteCarloInput(
        currentBalanceCents: 5000000,
        monthlyContributionCents: 50000,
        annualReturn: 0.045,
        annualVolatility: 0.15,
        yearsToRetirement: 10,
      );

      final result1 = runMonteCarloSimulation(input);
      final result2 = runMonteCarloSimulation(input);

      // Should produce identical results since we use Random(42)
      for (var i = 0; i < result1.years.length; i++) {
        expect(result1.p50[i], result2.p50[i],
            reason: 'p50 should be deterministic at year $i');
      }
    });

    test('zero starting balance with contributions grows', () {
      const input = MonteCarloInput(
        currentBalanceCents: 0,
        monthlyContributionCents: 100000, // $1,000/month
        annualReturn: 0.045,
        annualVolatility: 0.15,
        yearsToRetirement: 10,
      );

      final result = runMonteCarloSimulation(input);

      expect(result.p50[0], 0);
      expect(result.p50.last, greaterThan(0),
          reason: 'Should grow from contributions');
    });
  });
}
