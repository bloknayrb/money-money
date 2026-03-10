import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

import '../../data/local/database/app_database.dart';
import '../../data/local/secure_storage/secure_storage_service.dart';
import '../../data/repositories/account_repository.dart';
import '../../data/repositories/auto_categorize_repository.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/budget_repository.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/import_repository.dart';
import '../../data/repositories/recurring_transaction_repository.dart';
import '../../domain/usecases/auth/biometric_service.dart';
import '../../domain/usecases/auth/pin_service.dart';
import '../../domain/usecases/categories/category_seeder.dart';
import '../../domain/usecases/export/csv_export_service.dart';
import '../../domain/usecases/import/csv_import_service.dart';
import '../../domain/usecases/categorize/auto_categorize_service.dart';
import '../../domain/usecases/categorize/rules_import_service.dart';
import '../../domain/usecases/recurring/recurring_detection_service.dart';
import '../../domain/usecases/ai/budget_suggestion_service.dart';
import '../../domain/usecases/ai/chat_service.dart';
import '../../domain/usecases/ai/context_builder.dart';
import '../../domain/usecases/ai/insight_generation_service.dart';
import '../../data/remote/dio_client.dart';
import '../../data/remote/llm/claude_client.dart';
import '../../data/remote/llm/gemini_client.dart';
import '../../data/remote/llm/llm_client.dart';
import '../../data/remote/llm/ollama_client.dart';
import '../../data/remote/llm/openai_client.dart';
import '../../data/remote/simplefin/simplefin_client.dart';
import '../../data/repositories/conversation_repository.dart';
import '../../data/repositories/insight_repository.dart';
import '../../data/repositories/bank_connection_repository.dart';
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

/// Provides a Dio client for LLM API calls (redacted logs, 30s timeout).
final llmDioClientProvider = Provider<Dio>((ref) {
  return createLlmDioClient();
});

/// Provides the SimpleFIN API client (uses longer timeout for transaction pulls).
final simplefinClientProvider = Provider<SimplefinClient>((ref) {
  return SimplefinClient(ref.watch(simplefinDioClientProvider));
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
// AUTO-CATEGORIZATION
// =============================================================================

final autoCategorizeRepositoryProvider =
    Provider<AutoCategorizeRepository>((ref) {
  return AutoCategorizeRepository(ref.watch(databaseProvider));
});

final autoCategorizeServiceProvider = Provider<AutoCategorizeService>((ref) {
  return AutoCategorizeService(
    ref.watch(autoCategorizeRepositoryProvider),
    ref.watch(transactionRepositoryProvider),
  );
});

final rulesImportServiceProvider = Provider<RulesImportService>((ref) {
  return RulesImportService(
    ref.watch(autoCategorizeRepositoryProvider),
    ref.watch(categoryRepositoryProvider),
  );
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
    autoCategorizeService: ref.watch(autoCategorizeServiceProvider),
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
    ref.watch(autoCategorizeServiceProvider),
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

/// Provider for the current theme mode, persisted to secure storage.
final appThemeModeProvider =
    StateProvider<AppThemeMode>((ref) => AppThemeMode.system);

/// Loads the persisted theme mode on app start.
final themeModeInitProvider = FutureProvider<AppThemeMode>((ref) async {
  final stored = await ref.watch(secureStorageProvider).getThemeMode();
  final mode = AppThemeMode.values
          .where((e) => e.name == stored)
          .firstOrNull ??
      AppThemeMode.system;
  ref.read(appThemeModeProvider.notifier).state = mode;
  return mode;
});

/// Provider for the app router (needs Ref for auth redirect logic).
final appRouterProvider = Provider<GoRouter>((ref) {
  return createAppRouter(ref);
});

/// Whether the app is currently unlocked (past the lock screen).
final isUnlockedProvider = StateProvider<bool>((ref) => false);

/// Tracks the last time the app was paused (backgrounded).
final lastPausedAtProvider = StateProvider<DateTime?>((ref) => null);

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

// =============================================================================
// AI / LLM PROVIDERS
// =============================================================================

final insightRepositoryProvider = Provider<InsightRepository>((ref) {
  return InsightRepository(ref.watch(databaseProvider));
});

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  return ConversationRepository(ref.watch(databaseProvider));
});

final contextBuilderProvider = Provider<ContextBuilder>((ref) {
  return ContextBuilder(
    accountRepo: ref.watch(accountRepositoryProvider),
    transactionRepo: ref.watch(transactionRepositoryProvider),
    budgetRepo: ref.watch(budgetRepositoryProvider),
    goalRepo: ref.watch(goalRepositoryProvider),
    categoryRepo: ref.watch(categoryRepositoryProvider),
  );
});

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService(
    conversationRepo: ref.watch(conversationRepositoryProvider),
    contextBuilder: ref.watch(contextBuilderProvider),
  );
});

final insightGenerationServiceProvider =
    Provider<InsightGenerationService>((ref) {
  return InsightGenerationService(
    contextBuilder: ref.watch(contextBuilderProvider),
    insightRepo: ref.watch(insightRepositoryProvider),
  );
});

final budgetSuggestionServiceProvider =
    Provider<BudgetSuggestionService>((ref) {
  return BudgetSuggestionService(
    contextBuilder: ref.watch(contextBuilderProvider),
  );
});

/// The active LLM client, or null when no provider is configured.
///
/// Async because it reads from secure storage. Invalidate via
/// [ref.invalidate(activeLlmClientProvider)] after settings changes.
final activeLlmClientProvider = FutureProvider<LlmClient?>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  final provider = await storage.getActiveLlmProvider();
  if (provider == null) return null;
  final apiKey = await storage.getLlmApiKey(provider);
  final model = await storage.getActiveLlmModel();
  if (apiKey == null && provider != 'ollama') return null;
  return _buildLlmClient(provider: provider, apiKey: apiKey, model: model, ref: ref);
});

/// The name of the currently active LLM provider, or null if unconfigured.
final activeLlmProviderNameProvider = FutureProvider<String?>((ref) async {
  return ref.watch(secureStorageProvider).getActiveLlmProvider();
});

/// Active insights for dashboard display.
final activeInsightsProvider =
    StreamProvider.autoDispose<List<Insight>>((ref) {
  return ref.watch(insightRepositoryProvider).watchActiveInsights();
});

LlmClient? _buildLlmClient({
  required String provider,
  required String? apiKey,
  required String? model,
  required Ref ref,
}) {
  final dio = ref.read(llmDioClientProvider);
  switch (provider) {
    case 'gemini':
      return GeminiClient(
        apiKey: apiKey!,
        model: model ?? 'gemini-2.5-flash',
      );
    case 'claude':
      return ClaudeClient(
        apiKey: apiKey!,
        dio: dio,
        model: model ?? 'claude-haiku-4-5-20251001',
      );
    case 'openai':
      return OpenAiClient(
        apiKey: apiKey!,
        dio: dio,
        model: model ?? 'gpt-5-mini',
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
}
