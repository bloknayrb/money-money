import 'package:flutter_test/flutter_test.dart';

import 'package:moneymoney/presentation/features/dashboard/dashboard_card_registry.dart';

void main() {
  group('DashboardCardConfig', () {
    test('toJson and fromJson round-trip', () {
      const config = DashboardCardConfig(
        id: 'health_score',
        visible: true,
        size: DashboardCardSize.full,
      );
      final json = config.toJson();
      final restored = DashboardCardConfig.fromJson(json);

      expect(restored.id, 'health_score');
      expect(restored.visible, true);
      expect(restored.size, DashboardCardSize.full);
    });

    test('fromJson defaults missing visible to true', () {
      final config = DashboardCardConfig.fromJson({'id': 'x', 'size': 'full'});
      expect(config.visible, true);
    });

    test('fromJson defaults unknown size to full', () {
      final config = DashboardCardConfig.fromJson({
        'id': 'x',
        'visible': false,
        'size': 'unknown',
      });
      expect(config.size, DashboardCardSize.full);
    });

    test('copyWith overrides specified fields', () {
      const config = DashboardCardConfig(
        id: 'x',
        visible: true,
        size: DashboardCardSize.full,
      );
      final updated = config.copyWith(visible: false, size: DashboardCardSize.half);
      expect(updated.id, 'x');
      expect(updated.visible, false);
      expect(updated.size, DashboardCardSize.half);
    });
  });

  group('defaultDashboardLayout', () {
    test('has one entry per definition', () {
      expect(
        defaultDashboardLayout.length,
        dashboardCardDefinitions.length,
      );
    });

    test('IDs match definitions in order', () {
      final layoutIds = defaultDashboardLayout.map((c) => c.id).toList();
      final defIds = dashboardCardDefinitions.map((d) => d.id).toList();
      expect(layoutIds, defIds);
    });

    test('all entries are visible by default', () {
      for (final config in defaultDashboardLayout) {
        expect(config.visible, true, reason: '${config.id} should be visible');
      }
    });
  });

  group('dashboardCardDefinitionsMap', () {
    test('contains all definitions', () {
      expect(
        dashboardCardDefinitionsMap.length,
        dashboardCardDefinitions.length,
      );
    });

    test('lookup by ID returns correct definition', () {
      final def = dashboardCardDefinitionsMap['net_worth'];
      expect(def, isNotNull);
      expect(def!.title, 'Net Worth');
    });
  });
}
