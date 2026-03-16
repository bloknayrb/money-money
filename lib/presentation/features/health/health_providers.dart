import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../domain/usecases/analytics/financial_health_service.dart';

/// Financial health score with all pillars and priority ladder.
final financialHealthProvider =
    FutureProvider.autoDispose<FinancialHealthScore>((ref) async {
  final service = ref.watch(financialHealthServiceProvider);
  return service.calculateScore();
});
