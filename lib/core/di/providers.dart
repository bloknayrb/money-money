import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/local/database/app_database.dart';
import '../../data/local/secure_storage/secure_storage_service.dart';
import '../../data/remote/dio_client.dart';
import '../../data/remote/llm/claude_client.dart';
import '../../data/remote/llm/gemini_client.dart';
import '../../data/remote/llm/llm_client.dart';
import '../../data/remote/llm/ollama_client.dart';
import '../../data/remote/llm/openai_client.dart';
import '../../data/remote/simplefin/simplefin_client.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/bank_connection_repository.dart';
import '../../data/repositories/budget_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/conversation_repository.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/import_repository.dart';
import '../../data/repositories/recurring_transaction_repository.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../domain/usecases/ai/chat_service.dart';
import '../../domain/usecases/ai/context_builder.dart';
import '../../domain/usecases/auth/biometric_service.dart';
import '../../domain/usecases/auth/pin_service.dart';
import '../../domain/usecases/categories/category_seeder.dart';
import '../../domain/usecases/export/csv_export_service.dart';
import '../../domain/usecases/import/csv_import_service.dart';
import '../../domain/usecases/recurring/recurring_detection_service.dart';
import '../../domain/usecases/sync/background_sync_manager.dart';
import '../../domain/usecases/sync/simplefin_sync_service.dart';
import '../router/app_router.dart';

// =============================================================================
// INFRASTRUCTURE PROVIDERS
// =============================================================================

/// Provides the singleton database instance.
///
/// Initialized asynchronously at app start and overridden in ProviderScope.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'databaseProvider must be overridden with an initialized AppDatabase '
    'in the root ProviderScope.',
  );
});

/// Provides the secure storage service.
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// =============================================================================
// NETWORKING
// =============================================================================

/// Provides a configured Dio HTTP client.
final dioClientProvider = Provider<Dio>((ref) {
  return createDioClient();
});

/// Provides a Dio client with longer timeouts for SimpleFIN transaction syncs.
final simplefinDioClientProvider = Provider<Dio>((ref) {
  return createSimplefinDioClient();
});

/// Provides the SimpleFIN API client (uses longer timeout for transaction pulls).
final simplefinClientProvider = Provider<SimplefinClient>((ref) {
  return SimplefinClient(ref.watch(simplefinDioClientProvider));
});

/// Provides a Dio client for LLM API calls (redacting interceptor, 30s timeout).
final llmDioClientProvider = Provider<Dio>((ref) {
  return createLlmDioClient();
});

// =============================================================================
// REPOSITORY PROVIDERS
// =============================================================================

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(ref.watch(databaseProvider));
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(ref.watch(databaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(databaseProvider));
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.watch(databaseProvider));
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository(ref.watch(databaseProvider));
});

final recurringTransactionRepositoryProvider =
    Provider<RecurringTransactionRepository>((ref) {
  return RecurringTransactionRepository(ref.watch(databaseProvider));
});

// =============================================================================
// BANK CONNECTIONS
// =============================================================================

final bankConnectionRepositoryProvider =
    Provider<BankConnectionRepository>((ref) {
  return BankConnectionRepository(ref.watch(databaseProvider));
});

final simplefinSyncServiceProvider = Provider<SimplefinSyncService>((ref) {
  return SimplefinSyncService(
    simplefinClient: ref.watch(simplefinClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
    connectionRepo: ref.watch(bankConnectionRepositoryProvider),
    accountRepo: ref.watch(accountRepositoryProvider),
    transactionRepo: ref.watch(transactionRepositoryProvider),
    importRepo: ref.watch(importRepositoryProvider),
  );
});

final backgroundSyncManagerProvider = Provider<BackgroundSyncManager>((ref) {
  return BackgroundSyncManager();
});

/// Whether auto-sync is enabled in settings.
final autoSyncEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(secureStorageProvider).getAutoSyncEnabled();
});

/// All bank connections (for conditional UI like the auto-sync toggle).
final bankConnectionsStreamProvider =
    StreamProvider.autoDispose<List<BankConnection>>((ref) {
  return ref.watch(bankConnectionRepositoryProvider).watchAllConnections();
});

// =============================================================================
// EXPORT
// =============================================================================

final csvExportServiceProvider = Provider<CsvExportService>((ref) {
  return CsvExportService(
    accountRepo: ref.watch(accountRepositoryProvider),
    transactionRepo: ref.watch(transactionRepositoryProvider),
    categoryRepo: ref.watch(categoryRepositoryProvider),
  );
});

// =============================================================================
// RECURRING DETECTION
// =============================================================================

final recurringDetectionServiceProvider =
    Provider<RecurringDetectionService>((ref) {
  return RecurringDetectionService(
    ref.watch(transactionRepositoryProvider),
    ref.watch(recurringTransactionRepositoryProvider),
  );
});

// =============================================================================
// IMPORT
// =============================================================================

final importRepositoryProvider = Provider<ImportRepository>((ref) {
  return ImportRepository(ref.watch(databaseProvider));
});

final csvImportServiceProvider = Provider<CsvImportService>((ref) {
  return CsvImportService(
    ref.watch(transactionRepositoryProvider),
    ref.watch(importRepositoryProvider),
  );
});

// =============================================================================
// CATEGORY SEEDING
// =============================================================================

final categorySeederProvider = Provider<CategorySeeder>((ref) {
  return CategorySeeder(ref.watch(categoryRepositoryProvider));
});

// =============================================================================
// AUTH PROVIDERS
// =============================================================================

final pinServiceProvider = Provider<PinService>((ref) {
  return PinService(ref.watch(secureStorageProvider));
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService(ref.watch(secureStorageProvider));
});

/// Whether the user has set up a PIN.
final hasPinProvider = FutureProvider<bool>((ref) {
  return ref.watch(pinServiceProvider).hasPin();
});

/// Whether biometric auth is enabled in settings.
final biometricEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(biometricServiceProvider).isEnabled();
});

/// Whether biometric auth is available on this device.
final biometricAvailableProvider = FutureProvider<bool>((ref) {
  return ref.watch(biometricServiceProvider).isAvailable();
});

/// Current auto-lock timeout in seconds.
final autoLockTimeoutProvider = FutureProvider<int>((ref) {
  return ref.watch(secureStorageProvider).getAutoLockTimeoutSeconds();
});

// =============================================================================
// APP STATE PROVIDERS
// =============================================================================

/// Provider for the current theme mode.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Provider for the app router (needs Ref for auth redirect logic).
final appRouterProvider = Provider<GoRouter>((ref) {
  return createAppRouter(ref);
});

/// Whether the app is currently unlocked (past the lock screen).
final isUnlockedProvider = StateProvider<bool>((ref) => false);

/// Tracks the last time the app was paused (backgrounded).
final lastPausedAtProvider = StateProvider<DateTime?>((ref) => null);

// =============================================================================
// AI / LLM PROVIDERS
// =============================================================================

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return ConversationRepository(ref.watch(databaseProvider));
});

final contextBuilderProvider = Provider<ContextBuilder>((ref) {
  return ContextBuilder(
    accountRepo: ref.watch(accountRepositoryProvider),
    transactionRepo: ref.watch(transactionRepositoryProvider),
    categoryRepo: ref.watch(categoryRepositoryProvider),
    budgetRepo: ref.watch(budgetRepositoryProvider),
    goalRepo: ref.watch(goalRepositoryProvider),
  );
});

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService(
    conversationRepo: ref.watch(conversationRepositoryProvider),
    contextBuilder: ref.watch(contextBuilderProvider),
  );
});

/// The active LLM client, or null if no provider is configured.
///
/// FutureProvider because secure storage is async. Invalidate after settings change.
final activeLlmClientProvider = FutureProvider<LlmClient?>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  final provider = await storage.getActiveLlmProvider();
  if (provider == null) return null;

  final apiKey = await storage.getLlmApiKey(provider);
  final model = await storage.getActiveLlmModel();
  final dio = ref.watch(llmDioClientProvider);

  switch (provider) {
    case 'claude':
      if (apiKey == null) return null;
      return ClaudeClient(
        apiKey: apiKey,
        dio: dio,
        model: model ?? 'claude-haiku-4-5-20251001',
      );
    case 'openai':
      if (apiKey == null) return null;
      return OpenAiClient(
        apiKey: apiKey,
        dio: dio,
        model: model ?? 'gpt-4o-mini',
      );
    case 'gemini':
      if (apiKey == null) return null;
      return GeminiClient(
        apiKey: apiKey,
        model: model ?? 'gemini-2.0-flash',
      );
    case 'ollama':
      return OllamaClient(
        baseUrl: apiKey ?? 'http://localhost:11434',
        dio: dio,
        model: model ?? 'llama3.2',
      );
    default:
      return null;
  }
});

/// The active provider name — used for settings subtitle display.
final activeLlmProviderNameProvider = FutureProvider<String?>((ref) {
  return ref.watch(secureStorageProvider).getActiveLlmProvider();
});

// =============================================================================
// CATEGORY STREAM PROVIDERS
// =============================================================================

/// All categories (used by category pickers and lookups across features).
final allCategoriesProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAllCategories();
});

/// Expense categories only.
final expenseCategoriesProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchExpenseCategories();
});

/// Income categories only.
final incomeCategoriesProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchIncomeCategories();
});
