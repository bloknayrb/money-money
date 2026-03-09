import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/local/database/app_database.dart';

/// Watch all auto-categorization rules.
final autoCategorizeRulesProvider =
    StreamProvider.autoDispose<List<AutoCategorizeRule>>((ref) {
  return ref.watch(autoCategorizeRepositoryProvider).watchAllRules();
});
