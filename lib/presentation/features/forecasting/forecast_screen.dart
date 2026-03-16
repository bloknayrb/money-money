import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'forecast_providers.dart';
import 'widgets/forecast_chart.dart';
import 'widgets/upcoming_transactions_list.dart';

class ForecastScreen extends ConsumerWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsync = ref.watch(cashFlowForecastProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cash Flow Forecast')),
      body: forecastAsync.when(
        data: (forecast) {
          if (forecast.days.isEmpty) {
            return const Center(
              child: Text('Add recurring transactions to see forecasts'),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ForecastChart(forecast: forecast),
              const SizedBox(height: 24),
              UpcomingTransactionsList(forecast: forecast),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
