import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/features/auth/lock_screen.dart';
import '../../presentation/features/auth/pin_setup_screen.dart';
import '../../presentation/features/dashboard/dashboard_screen.dart';
import '../../presentation/features/accounts/accounts_screen.dart';
import '../../presentation/features/accounts/add_edit_account_screen.dart';
import '../../presentation/features/accounts/amortization_screen.dart';
import '../../presentation/features/onboarding/onboarding_screen.dart';
import '../../presentation/features/transactions/transactions_screen.dart';
import '../../presentation/features/transactions/add_edit_transaction_screen.dart';
import '../../presentation/features/ai_assistant/ai_assistant_screen.dart';
import '../../presentation/features/ai_assistant/ai_chat_screen.dart';
import '../../presentation/features/settings/llm_settings_screen.dart';
import '../../presentation/features/settings/settings_screen.dart';
import '../../presentation/features/bank_connections/simplefin_setup_screen.dart';
import '../../presentation/features/bank_connections/account_linking_screen.dart';
import '../../presentation/features/bank_connections/bank_connections_screen.dart';
import '../../presentation/features/bank_connections/connection_detail_screen.dart';
import '../../presentation/features/budgets/budgets_screen.dart';
import '../../presentation/features/budgets/add_edit_budget_screen.dart';
import '../../presentation/features/budgets/ai_budget_suggestion_screen.dart';
import '../../presentation/features/goals/goals_screen.dart';
import '../../presentation/features/goals/add_edit_goal_screen.dart';
import '../../presentation/features/goals/retirement_goal_detail_screen.dart';
import '../../presentation/features/recurring/recurring_screen.dart';
import '../../presentation/features/recurring/add_edit_recurring_screen.dart';
import '../../presentation/features/import/csv_import_screen.dart';
import '../../presentation/features/import/import_history_screen.dart';
import '../../presentation/features/settings/auto_categorize_rules_screen.dart';
import '../../presentation/features/settings/category_management_screen.dart';
import '../../presentation/features/import/import_rules_screen.dart';
import '../../presentation/shared/widgets/app_shell.dart';
import '../../data/local/database/app_database.dart';
import '../di/providers.dart';

/// Route path constants.
class AppRoutes {
  AppRoutes._();

  static const String lock = '/lock';
  static const String pinSetup = '/pin-setup';
  static const String pinChange = '/pin-change';
  static const String dashboard = '/dashboard';
  static const String accounts = '/accounts';
  static const String transactions = '/transactions';
  static const String aiAssistant = '/ai';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';
  static const String bankConnections = '/bank-connections';
  static const String simplefinSetup = '/simplefin-setup';
  static const String accountLinking = '/account-linking';
  static const String connectionDetail = '/connection-detail';
  static const String budgets = '/budgets';
  static const String goals = '/goals';
  static const String recurring = '/recurring';
  static const String csvImport = '/import/csv';
  static const String importHistory = '/import/history';
  static const String llmSettings = '/llm-settings';
  static const String aiChat = '/ai/chat';
  static const String autoCategorizeRules = '/auto-categorize-rules';
  static const String importRules = '/auto-categorize-rules/import';
  static const String categoryManagement = '/categories';
  static const String amortization = '/accounts/amortization';
  static const String addAccount = '/accounts/add';
  static const String editAccount = '/accounts/edit';
  static const String addTransaction = '/transactions/add';
  static const String editTransaction = '/transactions/edit';
  static const String addGoal = '/goals/add';
  static const String editGoal = '/goals/edit';
  static const String retirementGoal = '/goals/retirement';
  static const String addRecurring = '/recurring/add';
  static const String editRecurring = '/recurring/edit';
  static const String addBudget = '/budgets/add';
  static const String editBudget = '/budgets/edit';
  static const String aiBudgetSuggestion = '/budgets/ai-suggestion';
}

/// Navigator keys for each tab branch.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _dashboardNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final _accountsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'accounts');
final _transactionsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'transactions');
final _aiNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'ai');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

/// Creates the application router with auth-aware redirect logic.
///
/// Uses a [Ref] to check auth state for redirect decisions.
GoRouter createAppRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.lock,
    redirect: (context, state) {
      final path = state.uri.path;

      // Check if PIN has been set up (cached synchronously at startup)
      final hasPin = ref.read(hasPinCachedProvider);

      // If no PIN set and not already on setup screen, redirect to setup
      if (!hasPin && path != AppRoutes.pinSetup) {
        return AppRoutes.pinSetup;
      }

      // If PIN is set and user is trying to access setup, redirect to lock
      if (hasPin && path == AppRoutes.pinSetup) {
        return AppRoutes.lock;
      }

      // If locked, redirect to lock screen (must come after hasPin checks
      // so first-launch users hit pin-setup instead)
      final isUnlocked = ref.read(isUnlockedProvider);
      if (!isUnlocked && path != AppRoutes.lock && path != AppRoutes.pinSetup && path != AppRoutes.pinChange) {
        return AppRoutes.lock;
      }

      return null; // No redirect
    },
    routes: [
      // Lock screen (full-screen overlay)
      GoRoute(
        path: AppRoutes.lock,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LockScreen(),
      ),

      // PIN setup (first-time)
      GoRoute(
        path: AppRoutes.pinSetup,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PinSetupScreen(),
      ),

      // PIN change (from settings)
      GoRoute(
        path: AppRoutes.pinChange,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PinSetupScreen(isChange: true),
      ),

      // Onboarding (first launch)
      GoRoute(
        path: AppRoutes.onboarding,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Bank connections
      GoRoute(
        path: AppRoutes.bankConnections,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BankConnectionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.simplefinSetup,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SimplefinSetupScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.accountLinking}/:connectionId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final connectionId = state.pathParameters['connectionId']!;
          return AccountLinkingScreen(connectionId: connectionId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.connectionDetail}/:connectionId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final connectionId = state.pathParameters['connectionId']!;
          return ConnectionDetailScreen(connectionId: connectionId);
        },
      ),

      // Add/Edit screens (full-screen, over shell)
      GoRoute(
        path: AppRoutes.addAccount,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddEditAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.editAccount,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final account = state.extra as Account?;
          return AddEditAccountScreen(account: account);
        },
      ),
      GoRoute(
        path: AppRoutes.addTransaction,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final accountId = state.extra as String?;
          return AddEditTransactionScreen(accountId: accountId);
        },
      ),
      GoRoute(
        path: AppRoutes.editTransaction,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final transaction = state.extra as Transaction?;
          return AddEditTransactionScreen(transaction: transaction);
        },
      ),
      GoRoute(
        path: AppRoutes.addGoal,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddEditGoalScreen(),
      ),
      GoRoute(
        path: AppRoutes.editGoal,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final goal = state.extra as Goal?;
          return AddEditGoalScreen(goal: goal);
        },
      ),
      GoRoute(
        path: AppRoutes.addRecurring,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddEditRecurringScreen(),
      ),
      GoRoute(
        path: AppRoutes.editRecurring,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final recurring = state.extra as RecurringTransaction?;
          return AddEditRecurringScreen(recurring: recurring);
        },
      ),
      GoRoute(
        path: AppRoutes.addBudget,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddEditBudgetScreen(),
      ),
      GoRoute(
        path: AppRoutes.editBudget,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final budget = state.extra as Budget?;
          return AddEditBudgetScreen(budget: budget);
        },
      ),
      GoRoute(
        path: AppRoutes.aiBudgetSuggestion,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AiBudgetSuggestionScreen(),
      ),

      // Budgets (full-screen)
      GoRoute(
        path: AppRoutes.budgets,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BudgetsScreen(),
      ),

      // Goals (full-screen)
      GoRoute(
        path: AppRoutes.goals,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GoalsScreen(),
      ),

      // Retirement goal detail
      GoRoute(
        path: '${AppRoutes.retirementGoal}/:goalId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final goalId = state.pathParameters['goalId']!;
          return RetirementGoalDetailScreen(goalId: goalId);
        },
      ),

      // Recurring transactions (full-screen)
      GoRoute(
        path: AppRoutes.recurring,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RecurringScreen(),
      ),

      // CSV import (full-screen)
      GoRoute(
        path: AppRoutes.csvImport,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CsvImportScreen(),
      ),

      // Import history (full-screen)
      GoRoute(
        path: AppRoutes.importHistory,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ImportHistoryScreen(),
      ),

      // Category management (full-screen)
      GoRoute(
        path: AppRoutes.categoryManagement,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CategoryManagementScreen(),
      ),

      // Amortization schedule (full-screen)
      GoRoute(
        path: '${AppRoutes.amortization}/:accountId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final accountId = state.pathParameters['accountId']!;
          final accountName = state.extra as String? ?? 'Loan';
          return AmortizationScreen(
            accountId: accountId,
            accountName: accountName,
          );
        },
      ),

      // Auto-categorization rules (full-screen)
      GoRoute(
        path: AppRoutes.autoCategorizeRules,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AutoCategorizeRulesScreen(),
      ),

      // Import rules via CSV (full-screen)
      GoRoute(
        path: AppRoutes.importRules,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ImportRulesScreen(),
      ),

      // LLM settings (full-screen)
      GoRoute(
        path: AppRoutes.llmSettings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LlmSettingsScreen(),
      ),

      // AI chat detail (full-screen, pushed from AI tab)
      GoRoute(
        path: '${AppRoutes.aiChat}/:conversationId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          return AiChatScreen(conversationId: conversationId);
        },
      ),

      // Main app with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard tab
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Accounts tab
          StatefulShellBranch(
            navigatorKey: _accountsNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.accounts,
                builder: (context, state) => const AccountsScreen(),
              ),
            ],
          ),

          // Transactions tab
          StatefulShellBranch(
            navigatorKey: _transactionsNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),

          // AI Assistant tab
          StatefulShellBranch(
            navigatorKey: _aiNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.aiAssistant,
                builder: (context, state) => const AiAssistantScreen(),
              ),
            ],
          ),

          // Settings tab
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
