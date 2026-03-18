import 'dart:convert';

import '../../presentation/features/dashboard/dashboard_card_registry.dart';
import '../local/database/app_database.dart';

/// Persists dashboard card layout (order, visibility, size) in AppSettings.
class DashboardLayoutRepository {
  DashboardLayoutRepository(this._db);

  final AppDatabase _db;

  static const _key = 'dashboard_layout';
  static const _schemaVersion = 1;

  /// Get the current layout config, merged with the registry so new cards
  /// are appended and removed cards are dropped.
  Future<List<DashboardCardConfig>> getLayout() async {
    final row = await (_db.select(_db.appSettings)
          ..where((s) => s.key.equals(_key)))
        .getSingleOrNull();

    if (row == null) return defaultDashboardLayout;

    return _mergeWithRegistry(_migrateCardIds(_parseJson(row.value)));
  }

  /// Save the layout config.
  Future<void> saveLayout(List<DashboardCardConfig> layout) async {
    final json = jsonEncode({
      'v': _schemaVersion,
      'cards': layout.map((c) => c.toJson()).toList(),
    });

    await _db.into(_db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: _key,
            value: json,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  /// Delete the saved layout (resets to defaults).
  Future<void> resetLayout() async {
    await (_db.delete(_db.appSettings)
          ..where((s) => s.key.equals(_key)))
        .go();
  }

  List<DashboardCardConfig> _parseJson(String raw) {
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final cards = data['cards'] as List<dynamic>? ?? [];
      return cards
          .map((c) =>
              DashboardCardConfig.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return defaultDashboardLayout;
    }
  }

  /// IDs that were consolidated into 'spending_analytics'.
  static const _legacySpendingIds = {
    'savings_rate',
    'cash_flow',
    'spending_over_time',
    'spending_by_category',
    'income_expense_trend',
  };

  /// Replace legacy card IDs with their consolidated successor.
  /// Keeps the position of the first legacy card found; drops the rest.
  List<DashboardCardConfig> _migrateCardIds(List<DashboardCardConfig> stored) {
    var replaced = false;
    final result = <DashboardCardConfig>[];
    for (final c in stored) {
      if (_legacySpendingIds.contains(c.id)) {
        if (!replaced) {
          result.add(DashboardCardConfig(
            id: 'spending_analytics',
            visible: c.visible,
            size: DashboardCardSize.full,
          ));
          replaced = true;
        }
        // Drop subsequent legacy cards
      } else {
        result.add(c);
      }
    }
    return result;
  }

  /// Merge stored config with the current registry:
  /// - Stored cards that still exist in registry keep their position/settings.
  /// - New registry cards (not in stored config) are appended with defaults.
  /// - Stored cards no longer in registry are dropped.
  List<DashboardCardConfig> _mergeWithRegistry(
    List<DashboardCardConfig> stored,
  ) {
    final registryIds =
        dashboardCardDefinitions.map((d) => d.id).toSet();
    final storedIds = stored.map((c) => c.id).toSet();

    // Keep stored cards that still exist in registry
    final merged = stored.where((c) => registryIds.contains(c.id)).toList();

    // Append new cards not in stored config
    for (final def in dashboardCardDefinitions) {
      if (!storedIds.contains(def.id)) {
        merged.add(DashboardCardConfig(
          id: def.id,
          visible: def.defaultVisible,
          size: def.supportedSizes.contains(DashboardCardSize.half)
              ? DashboardCardSize.half
              : DashboardCardSize.full,
        ));
      }
    }

    return merged;
  }
}
