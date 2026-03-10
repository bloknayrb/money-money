import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';

/// Simple onboarding screen shown on first launch after PIN setup.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // App icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Welcome text
              Text(
                'Welcome to ${AppConstants.appName}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your personal finance tracker. Add your first account to get started.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Steps overview
              _StepItem(
                number: '1',
                title: 'Add your accounts',
                description: 'Bank accounts, credit cards, investments',
                colorScheme: colorScheme,
                textTheme: theme.textTheme,
              ),
              const SizedBox(height: 12),
              _StepItem(
                number: '2',
                title: 'Track transactions',
                description: 'Record spending and income',
                colorScheme: colorScheme,
                textTheme: theme.textTheme,
              ),
              const SizedBox(height: 12),
              _StepItem(
                number: '3',
                title: 'See the big picture',
                description: 'Net worth, cash flow, and insights',
                colorScheme: colorScheme,
                textTheme: theme.textTheme,
              ),

              const Spacer(),

              // Action buttons
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    context.push(AppRoutes.addAccount);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Your First Account'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    context.go(AppRoutes.dashboard);
                  },
                  child: const Text('Skip for now'),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
