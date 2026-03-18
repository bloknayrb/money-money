import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_providers.dart';
import 'widgets/health_score_card.dart';
import 'widgets/cash_flow_forecast_card.dart';
import 'widgets/net_worth_card.dart';
import 'widgets/spending_analytics_card.dart';
import 'widgets/budget_health_card.dart';
import 'widgets/investments_card.dart';
import 'widgets/mortgage_card.dart';
import 'widgets/retirement_card.dart';
import 'widgets/recent_transactions_card.dart';
import 'widgets/upcoming_bills_card.dart';
import 'widgets/goal_progress_card.dart';
import 'widgets/uncategorized_nudge_card.dart';
import 'widgets/subscription_tracker_card.dart';

/// Card size options for responsive layout.
enum DashboardCardSize { full, half }

/// Metadata for a dashboard card.
class DashboardCardDefinition {
  final String id;
  final String title;
  final IconData icon;
  final bool defaultVisible;
  final int defaultOrder;
  final Set<DashboardCardSize> supportedSizes;

  /// Optional condition provider — card is unavailable when this returns false.
  /// Null means always available.
  final AutoDisposeProvider<bool>? condition;

  final Widget Function() builder;

  const DashboardCardDefinition({
    required this.id,
    required this.title,
    required this.icon,
    required this.defaultVisible,
    required this.defaultOrder,
    required this.supportedSizes,
    this.condition,
    required this.builder,
  });
}

/// User's persisted config for a single card.
class DashboardCardConfig {
  final String id;
  final bool visible;
  final DashboardCardSize size;

  const DashboardCardConfig({
    required this.id,
    required this.visible,
    required this.size,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'visible': visible,
        'size': size.name,
      };

  factory DashboardCardConfig.fromJson(Map<String, dynamic> json) {
    return DashboardCardConfig(
      id: json['id'] as String,
      visible: json['visible'] as bool? ?? true,
      size: DashboardCardSize.values.firstWhere(
        (s) => s.name == json['size'],
        orElse: () => DashboardCardSize.full,
      ),
    );
  }

  DashboardCardConfig copyWith({bool? visible, DashboardCardSize? size}) {
    return DashboardCardConfig(
      id: id,
      visible: visible ?? this.visible,
      size: size ?? this.size,
    );
  }
}

/// All available dashboard cards in default order.
final dashboardCardDefinitions = <DashboardCardDefinition>[
  DashboardCardDefinition(
    id: 'health_score',
    title: 'Health Score',
    icon: Icons.favorite_outline,
    defaultVisible: true,
    defaultOrder: 0,
    supportedSizes: {DashboardCardSize.full, DashboardCardSize.half},
    builder: () => const HealthScoreCard(),
  ),
  DashboardCardDefinition(
    id: 'cash_flow_forecast',
    title: 'Cash Flow Forecast',
    icon: Icons.show_chart,
    defaultVisible: true,
    defaultOrder: 1,
    supportedSizes: {DashboardCardSize.full},
    builder: () => const CashFlowForecastCard(),
  ),
  DashboardCardDefinition(
    id: 'net_worth',
    title: 'Net Worth',
    icon: Icons.account_balance_wallet_outlined,
    defaultVisible: true,
    defaultOrder: 2,
    supportedSizes: {DashboardCardSize.full},
    builder: () => const NetWorthCard(),
  ),
  DashboardCardDefinition(
    id: 'spending_analytics',
    title: 'Spending Analytics',
    icon: Icons.bar_chart,
    defaultVisible: true,
    defaultOrder: 3,
    supportedSizes: {DashboardCardSize.full},
    builder: () => const SpendingAnalyticsCard(),
  ),
  DashboardCardDefinition(
    id: 'budget_health',
    title: 'Budget Health',
    icon: Icons.receipt_long_outlined,
    defaultVisible: true,
    defaultOrder: 4,
    supportedSizes: {DashboardCardSize.full},
    builder: () => const BudgetHealthCard(),
  ),
  DashboardCardDefinition(
    id: 'upcoming_bills',
    title: 'Upcoming Bills',
    icon: Icons.calendar_today_outlined,
    defaultVisible: true,
    defaultOrder: 5,
    supportedSizes: {DashboardCardSize.full, DashboardCardSize.half},
    condition: hasUpcomingBillsProvider,
    builder: () => const UpcomingBillsCard(),
  ),
  DashboardCardDefinition(
    id: 'goal_progress',
    title: 'Goal Progress',
    icon: Icons.flag_outlined,
    defaultVisible: true,
    defaultOrder: 6,
    supportedSizes: {DashboardCardSize.full, DashboardCardSize.half},
    condition: hasGoalsProvider,
    builder: () => const GoalProgressCard(),
  ),
  DashboardCardDefinition(
    id: 'uncategorized_nudge',
    title: 'Uncategorized',
    icon: Icons.label_off_outlined,
    defaultVisible: true,
    defaultOrder: 7,
    supportedSizes: {DashboardCardSize.full, DashboardCardSize.half},
    condition: hasUncategorizedProvider,
    builder: () => const UncategorizedNudgeCard(),
  ),
  DashboardCardDefinition(
    id: 'subscription_tracker',
    title: 'Subscriptions',
    icon: Icons.autorenew,
    defaultVisible: true,
    defaultOrder: 8,
    supportedSizes: {DashboardCardSize.full, DashboardCardSize.half},
    condition: hasSubscriptionsProvider,
    builder: () => const SubscriptionTrackerCard(),
  ),
  DashboardCardDefinition(
    id: 'investments',
    title: 'Investments',
    icon: Icons.trending_up,
    defaultVisible: true,
    defaultOrder: 9,
    supportedSizes: {DashboardCardSize.full, DashboardCardSize.half},
    condition: hasInvestmentAccountsProvider,
    builder: () => const InvestmentsCard(),
  ),
  DashboardCardDefinition(
    id: 'mortgage',
    title: 'Mortgage',
    icon: Icons.house_outlined,
    defaultVisible: true,
    defaultOrder: 10,
    supportedSizes: {DashboardCardSize.full, DashboardCardSize.half},
    condition: hasMortgageAccountsProvider,
    builder: () => const MortgageCard(),
  ),
  DashboardCardDefinition(
    id: 'retirement',
    title: 'Retirement',
    icon: Icons.beach_access_outlined,
    defaultVisible: true,
    defaultOrder: 11,
    supportedSizes: {DashboardCardSize.full, DashboardCardSize.half},
    condition: hasRetirementAccountsProvider,
    builder: () => const RetirementCard(),
  ),
  DashboardCardDefinition(
    id: 'recent_transactions',
    title: 'Recent Transactions',
    icon: Icons.receipt_outlined,
    defaultVisible: true,
    defaultOrder: 12,
    supportedSizes: {DashboardCardSize.full},
    builder: () => const RecentTransactionsCard(),
  ),
];

/// Lookup map for card definitions by ID.
final dashboardCardDefinitionsMap = {
  for (final def in dashboardCardDefinitions) def.id: def,
};

/// Default config list generated from definitions.
List<DashboardCardConfig> get defaultDashboardLayout => [
      for (final def in dashboardCardDefinitions)
        DashboardCardConfig(
          id: def.id,
          visible: def.defaultVisible,
          size: def.supportedSizes.contains(DashboardCardSize.half)
              ? DashboardCardSize.half
              : DashboardCardSize.full,
        ),
    ];
