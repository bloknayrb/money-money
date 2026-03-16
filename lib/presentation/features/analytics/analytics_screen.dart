import 'package:flutter/material.dart';

import 'widgets/cash_flow_tab.dart';
import 'widgets/savings_rate_tab.dart';
import 'widgets/category_trends_tab.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Cash Flow'),
              Tab(text: 'Savings Rate'),
              Tab(text: 'Categories'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CashFlowTab(),
            SavingsRateTab(),
            CategoryTrendsTab(),
          ],
        ),
      ),
    );
  }
}
