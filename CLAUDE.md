# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Money Money** is a personal finance management app with AI-powered insights, built with Flutter targeting Android and Linux desktop.

## Coding Guidelines

Behavioral guidelines to reduce common LLM coding mistakes. These bias toward caution over speed — for trivial tasks, use judgment.

### Think Before Coding

Don't assume. Don't hide confusion. Surface tradeoffs.

- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### Surgical Changes

Touch only what you must. Clean up only your own mess.

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: every changed line should trace directly to the user's request.

### Goal-Driven Execution

Define success criteria. Loop until verified.

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

### Anti-Patterns to Avoid

| Principle | Anti-Pattern | Fix |
|-----------|-------------|-----|
| Think Before Coding | Silently assumes file format, fields, scope | List assumptions explicitly, ask for clarification |
| Simplicity First | Strategy pattern for single calculation | One function until complexity is actually needed |
| Surgical Changes | Reformats quotes, adds type hints while fixing a bug | Only change lines that fix the reported issue |
| Goal-Driven | "I'll review and improve the code" | "Write test for bug X → make it pass → verify no regressions" |

"Overcomplicated" code isn't obviously wrong — it follows design patterns and best practices. The problem is **timing**: adding complexity before it's needed makes code harder to understand, introduces more bugs, takes longer to implement, and is harder to test. Good code solves today's problem simply, not tomorrow's problem prematurely.

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## Workflow Orchestration

### 1. Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately — don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes — don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests — then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management

1. **Plan First**: Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to `tasks/todo.md`
6. **Capture Lessons**: Update `tasks/lessons.md` after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

## Build & Development Commands

```bash
# Get dependencies
flutter pub get

# Run Drift code generation (required after changing app_database.dart tables)
dart run build_runner build --delete-conflicting-outputs

# Analyze
flutter analyze

# Run all tests
flutter test

# Run a single test file
flutter test test/unit/some_test.dart

# Build for Android
flutter build apk --debug
flutter build apk --release

# Build for Linux desktop
flutter build linux

# Run on connected device/emulator
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App config, default category seeds
│   ├── di/                 # Riverpod providers (dependency injection)
│   ├── error/              # AppError sealed class hierarchy
│   ├── extensions/         # Money formatting, date helpers
│   ├── router/             # GoRouter with auth-aware redirects
│   └── theme/              # Material 3 theme + FinanceColors extension
├── data/
│   ├── local/
│   │   ├── database/       # Drift database (21 tables + generated code), models.dart barrel
│   │   └── secure_storage/ # flutter_secure_storage wrapper
│   ├── remote/
│   │   ├── dio_client.dart           # Shared Dio instance config
│   │   ├── llm/                      # LLM API clients
│   │   │   ├── llm_client.dart       # Abstract LlmClient interface
│   │   │   ├── gemini_client.dart    # Google Generative AI (direct SDK)
│   │   │   ├── claude_client.dart    # Anthropic Claude (via Dio)
│   │   │   ├── openai_client.dart    # OpenAI (via Dio)
│   │   │   └── ollama_client.dart    # Local Ollama (via Dio)
│   │   └── simplefin/
│   │       ├── simplefin_client.dart # SimpleFIN HTTP client (claim, fetch)
│   │       └── simplefin_models.dart # SimpleFIN API DTOs
│   └── repositories/       # AccountRepository, TransactionRepository,
│                           # CategoryRepository, BudgetRepository,
│                           # BankConnectionRepository, GoalRepository,
│                           # ImportRepository, RecurringTransactionRepository,
│                           # AutoCategorizeRepository, ConversationRepository,
│                           # InsightRepository, LoanParamsRepository
├── domain/
│   └── usecases/
│       ├── ai/             # ChatService, ContextBuilder, InsightGenerationService, BudgetSuggestionService
│       ├── amortization/   # LoanParams (loan amortization calculations)
│       ├── analytics/      # SpendingAnalyticsService, analytics_models
│       ├── auth/           # PinService, BiometricService
│       ├── budgets/        # BudgetSpendingService (budget spending orchestration)
│       ├── categories/     # CategorySeeder
│       ├── categorize/     # AutoCategorizeService, RuleSeeder, RulesImportService, default_rules_data
│       ├── dev/            # DevDataSeeder (debug-only test data)
│       ├── export/         # CsvExportService
│       ├── import/         # CsvImportService
│       ├── recurring/      # RecurringDetectionService
│       ├── retirement/     # MonteCarloService, RetirementParamsExtractor, retirement_prompts
│       └── sync/           # SimplefinSyncService, SyncOrchestrator, BackgroundSyncManager, sync_models
├── presentation/
│   ├── features/
│   │   ├── accounts/       # CRUD screens + accounts_providers.dart
│   │   ├── ai_assistant/   # AiAssistantScreen, chat UI + widgets/
│   │   ├── auth/           # LockScreen, PinSetupScreen
│   │   ├── bank_connections/ # SimpleFIN setup, connection list, account linking + widgets/
│   │   ├── budgets/        # Budget CRUD + budgets_providers.dart
│   │   ├── dashboard/      # DashboardScreen (net worth, cash flow, etc.) + widgets/
│   │   ├── goals/          # Goal CRUD + goals_providers.dart + widgets/
│   │   ├── import/         # CSV import with column mapping, import history + widgets/
│   │   ├── onboarding/     # OnboardingScreen (first-launch welcome)
│   │   ├── recurring/      # Recurring transaction detection + management + widgets/
│   │   ├── settings/       # SettingsScreen, LlmSettingsScreen + widgets/
│   │   └── transactions/   # CRUD screens + transactions_providers.dart + widgets/
│   └── shared/
│       ├── widgets/        # AppShell, PinNumberPad, CategoryPickerSheet, DeleteConfirmationDialog
│       ├── utils/          # SnackbarHelpers, ProviderInvalidation
│       ├── loading/        # ShimmerLoading skeletons
│       └── empty_states/   # EmptyStateWidget
├── app.dart                # Root MaterialApp, auto-lock lifecycle observer
└── main.dart               # Database init, category seeding, rule seeding, ProviderScope
```

## Architecture

Clean Architecture with three layers:
- **`data/`** — database, secure storage, repository implementations
- **`domain/`** — use cases and business logic services
- **`presentation/`** — screens, Riverpod providers, widgets

### Provider Wiring Pattern

The app uses **manual Riverpod providers** (NOT riverpod_generator — it conflicts with `analyzer_plugin`). All feature-level providers use `.autoDispose` for memory efficiency. The dependency chain is:

1. `databaseProvider` — created in `main.dart` via `AppDatabase.open()`, overridden in `ProviderScope`
2. Repository providers (`accountRepositoryProvider`, etc.) in `core/di/providers.dart` — depend on `databaseProvider`
3. Domain service providers (`spendingAnalyticsServiceProvider`, `budgetSpendingServiceProvider`, `syncOrchestratorProvider`) in `core/di/providers.dart` — depend on repository providers
4. Feature-level providers in each feature's `*_providers.dart` file — depend on repository and service providers
5. Screens consume feature providers via `ref.watch()`

**Import convention:** Presentation layer imports `data/local/database/models.dart` (barrel file that re-exports Drift data classes). Domain/data layers import `data/local/database/app_database.dart` directly.

### Database (Drift)

21 tables defined in `data/local/database/app_database.dart` with generated code in `app_database.g.dart`.

**Core rules:**
- **All money values are integer cents** (`$123.45` = `12345`). Never use floating point for money.
- **Primary keys are TEXT UUIDs** (generated with `uuid` package)
- **Timestamps are INTEGER Unix milliseconds** (`DateTime.now().millisecondsSinceEpoch`)
- Drift `.insert()` companion constructors take raw types (e.g., `String id`), while update companions use `Value<T>` wrappers
- After changing any table schema, run `dart run build_runner build --delete-conflicting-outputs`
- Foreign keys are enabled; core tables have `version` and `syncStatus` fields

**Tables by category:**

| Category | Tables |
|----------|--------|
| **Financial** | `Accounts`, `Transactions`, `Categories`, `Budgets`, `Goals`, `InvestmentHoldings`, `RecurringTransactions` |
| **Connectivity** | `BankConnections`, `ImportHistory` |
| **Categorization** | `AutoCategorizeRules`, `PayeeCategoryCache`, `CategorizationCorrections` |
| **AI** | `Conversations`, `Messages`, `Insights`, `AiMemoryCore`, `AiMemorySemantic`, `InsightFeedback` |
| **Infrastructure** | `SyncState`, `AuditLog`, `AppSettings` |

### Routing

GoRouter with `StatefulShellRoute.indexedStack` for 5-tab bottom navigation. Auth-aware redirect in `core/router/app_router.dart` checks PIN state:
- No PIN set → redirect to `/pin-setup`
- PIN set + on setup page → redirect to `/lock`

Route constants are in `AppRoutes` class. Full-screen routes: `/lock`, `/pin-setup`, `/pin-change`, `/onboarding`. Tab routes: `/dashboard`, `/accounts`, `/transactions`, `/ai`, `/settings`.

Additional full-screen routes for Phase 3 features:
- `/bank-connections`, `/simplefin-setup`, `/account-linking/:connectionId`, `/connection-detail/:connectionId`
- `/import/csv`, `/import/history`
- `/budgets`, `/goals`, `/recurring`

The router is created via `createAppRouter(Ref ref)` (needs Ref for auth state checks).

### Security

- **PIN hashing**: PBKDF2-HMAC-SHA256, 256k iterations, 256-bit salt (`domain/usecases/auth/pin_service.dart`). Uses constant-time XOR comparison to prevent timing attacks.
- **Biometric auth**: Wraps `local_auth` plugin with availability checks and preference tracking (`domain/usecases/auth/biometric_service.dart`).
- **Credential storage**: `flutter_secure_storage` (Android Keystore / Linux libsecret). `SecureStorageService` wraps all key names — SimpleFIN tokens, LLM API keys, Supabase sessions.
- **Auto-lock**: `_AutoLockObserver` in `app.dart` monitors app lifecycle. Records pause time, checks elapsed duration on resume against configurable timeout (default 300s). Tracked via `isUnlockedProvider` and `lastPausedAtProvider`.

### Error Handling

Sealed class hierarchy in `core/error/app_error.dart`:
- `NetworkError` — timeouts, no connection, server errors
- `DatabaseError` — corruption, migration failures
- `AuthError` — invalid PIN, biometric failure, lockout, session expired
- `BankSyncError` — connection failed, re-auth required, rate limited, circuit open
- `LLMError` — API errors, timeouts, rate limits, invalid keys, Ollama not running
- `ImportError` — invalid format, parse failures (with row tracking)

`ErrorHandler.handle()` converts raw exceptions to user-friendly `AppError` instances.

### Theme

Material 3 with `dynamic_color` support. Custom `FinanceColors` theme extension provides semantic colors (income=green, expense=red, budget states). Access via `Theme.of(context).finance`.

### Money Extensions

`core/extensions/money_extensions.dart` provides:
- `int.toCurrency()` — `12345` → `"$123.45"`
- `int.toCurrencyValue()` — `12345` → `"123.45"` (no symbol)
- `String.toCents()` — `"123.45"` → `12345`
- `int.toDateTime()` — Unix ms to DateTime
- `DateTime.toRelative()` — "Today", "Yesterday", "Monday", or "Jan 15, 2026"

## Key Conventions

- **Targets**: Android + Linux desktop only. `dart:ffi` dependency means web builds fail.
- **Flutter 3.38+**: `DropdownButtonFormField` uses `initialValue` (not deprecated `value` parameter).
- **Category seeding**: `CategorySeeder` runs on first launch in `main.dart`, populating 16 expense + 7 income parent categories with subcategories. `RuleSeeder` then seeds 300 default merchant→category rules and auto-categorizes any existing uncategorized transactions.
- **Auto-categorization**: Two-tier pipeline — Tier 1: `PayeeCategoryCache` (learned from manual assignments, confidence threshold ≥ 0.8, requires 3+ consistent uses), Tier 2: `AutoCategorizeRules` (priority-ordered pattern matching on normalized payee). Payee normalization: uppercase, strip POS prefixes (`SQ *`, `TST*`, `PAYPAL *`, etc.), canonical replacements (`AMZN`→`AMAZON`), strip trailing noise. Never overwrites existing categories — only categorizes when `categoryId == null`.
- **Account types**: 18 types defined in `core/constants/account_types.dart` with `AccountTypeInfo` metadata and `accountTypeGroups` for UI grouping (re-exported from `accounts_providers.dart`). Types: checking, savings, credit_card, brokerage, 401k, IRA, roth_ira, HSA, mortgage, auto_loan, student_loan, personal_loan, line_of_credit, real_estate, vehicle, crypto, other_asset, other_liability.
- **Expenses stored as negative cents**: Income is positive, expenses are negative in `amountCents`.
- **autoDispose providers**: All feature-level StreamProviders and FutureProviders use `.autoDispose` for memory efficiency. Core infrastructure providers (database, repositories) do not.
- **Linux secure storage**: `flutter_secure_storage` on Linux requires `libsecret` / `gnome-keyring` (D-Bus secret service). A `PlatformException` from missing libsecret would crash sync without a user-friendly error.
- **No CI/CD**: No GitHub Actions or CI pipeline is configured yet.

## Key Dependencies

| Category | Packages |
|----------|----------|
| **State** | flutter_riverpod, riverpod_annotation |
| **Database** | drift, sqlite3_flutter_libs, path_provider |
| **Routing** | go_router |
| **HTTP** | dio |
| **AI/LLM** | google_generative_ai (Gemini — direct SDK, not via Dio) |
| **Charts** | fl_chart |
| **Security** | flutter_secure_storage, local_auth, crypto |
| **Theme** | dynamic_color |
| **Serialization** | freezed_annotation, json_annotation |
| **Utilities** | uuid, intl, equatable, url_launcher, file_picker, shimmer |
| **Backend** | supabase_flutter (prepared, not yet wired) |
| **Monitoring** | sentry_flutter (initialized with `--dart-define=SENTRY_DSN`) |
| **Background** | workmanager |
| **Connectivity** | connectivity_plus |
| **Markdown** | flutter_markdown (for AI chat) |
| **Testing** | mocktail |

Note: `riverpod_generator` and `riverpod_lint` are commented out in pubspec.yaml due to `analyzer_plugin` compatibility issues.

## Testing

205 tests across 11 files. `mocktail` is the mocking library (dev dependency — do NOT use Mockito).

| File | Tests | Coverage |
|------|-------|----------|
| `test/unit/money_extensions_test.dart` | 33 | Money formatting, compact currency, date extensions |
| `test/unit/usecases/auto_categorize_service_test.dart` | 34 | Payee normalization, two-tier matching, confidence, bulk |
| `test/unit/usecases/import/csv_import_service_test.dart` | 32 | CSV parsing, column mapping, preview, fuzzy dedup |
| `test/unit/usecases/sync/simplefin_sync_service_test.dart` | 26 | Sync flow, dedup, error handling, investment holdings |
| `test/unit/repositories/account_repository_test.dart` | 20 | Account CRUD, type filtering, balance queries |
| `test/unit/repositories/transaction_repository_test.dart` | 19 | Transaction CRUD, filtering, aggregate queries |
| `test/unit/providers/dashboard_providers_test.dart` | 13 | Dashboard computations, net worth, cash flow |
| `test/unit/usecases/auth/pin_service_test.dart` | 9 | PIN hashing/verification, PBKDF2, timing safety |
| `test/unit/usecases/retirement/monte_carlo_service_test.dart` | 9 | Monte Carlo simulation, percentile bands |
| `test/unit/usecases/retirement/retirement_params_extractor_test.dart` | 8 | Parameter extraction from LLM responses |
| `test/unit/database/app_database_test.dart` | 2 | Basic DB operations |

Screens, widgets, CSV export, and AI chat still lack test coverage.

## Testing Guidelines

### Test Folder Structure

```
test/
├── unit/
│   ├── money_extensions_test.dart
│   ├── database/
│   │   └── app_database_test.dart
│   ├── providers/
│   │   └── dashboard_providers_test.dart
│   ├── repositories/
│   │   ├── account_repository_test.dart
│   │   └── transaction_repository_test.dart
│   └── usecases/
│       ├── auto_categorize_service_test.dart
│       ├── auth/
│       │   └── pin_service_test.dart
│       ├── import/
│       │   └── csv_import_service_test.dart
│       ├── retirement/
│       │   ├── monte_carlo_service_test.dart
│       │   └── retirement_params_extractor_test.dart
│       └── sync/
│           └── simplefin_sync_service_test.dart
└── widget_test.dart
```

### Test Patterns

- **AAA pattern**: Arrange → Act → Assert in every test
- **Mocktail** for mocking (already a dev dependency — do NOT use Mockito/code-gen mocks)
- **ProviderContainer** with overrides for testing Riverpod providers:
  ```dart
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(mockDb),
    ],
  );
  ```
- **Widget test helper**: Wrap widgets in `MaterialApp` + `ProviderScope` with necessary overrides
- **Name tests descriptively**: `'getAccounts returns empty list when no accounts exist'`

### Running Tests

```bash
flutter test                           # All tests
flutter test test/unit/                # Unit tests only
flutter test --coverage                # With coverage report
genhtml coverage/lcov.info -o coverage/html  # HTML report
```

## Performance Guidelines

### Widget Optimization

- **Use `const` constructors** on all static widgets — `const Text(...)`, `const Icon(...)`, `const SizedBox(...)`, `const EdgeInsets.all(...)`
- **Use `ListView.builder`** (never `ListView(children: [...])`) for any list that may exceed a screenful
- **Add `ValueKey`** to list items that may be reordered or removed: `ValueKey(account.id)`
- **Extract static subtrees** into their own `const` widget classes to prevent unnecessary rebuilds

### Rebuild Minimization

- Scope `ref.watch()` as narrowly as possible — put it inside individual widgets, not at the screen level
- Use `ref.watch(provider.select((s) => s.specificField))` for fine-grained rebuilds
- Move expensive computations out of `build()` — cache in `initState()` or use memoization

### Heavy Computation

- Use `compute()` or `Isolate.spawn()` for operations > 16 ms (e.g., CSV parsing, large data transforms)
- Keep the UI thread free — never block with synchronous file I/O or large loops

### Image Optimization

- Always set `cacheWidth` / `cacheHeight` on network images to prevent decoding full-resolution bitmaps
- Use `fit: BoxFit.cover` or `BoxFit.contain` to match display size

## API Integration Patterns (Dio)

The app uses **Dio** for HTTP. When adding API integrations (SimpleFIN, Supabase REST, etc.):

### Interceptor Stack

```dart
dio.interceptors.addAll([
  AuthInterceptor(secureStorage),   // Attach Bearer token
  RetryInterceptor(maxRetries: 3),  // Retry on 5xx / timeout
  LogInterceptor(requestBody: true, responseBody: true), // Debug only
]);
```

### Error Handling

- Wrap all Dio calls in try/catch and map `DioException` types to domain failures
- Timeout config: `connectTimeout: 10s`, `receiveTimeout: 5s`
- On 401 → attempt token refresh → retry original request → if refresh fails, force re-auth

### Type-Safe Responses

- Use `json_serializable` or `freezed` for API DTOs — never leave `dynamic` in parsed responses
- Map DTOs → domain entities at the repository boundary

## Android Build & Deployment

### Release Build

```bash
# Clean release build with obfuscation
flutter clean && flutter pub get
flutter build appbundle --release --obfuscate --split-debug-info=./debug-info

# Split APKs by ABI (smaller per-device downloads)
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=./debug-info
```

### App Signing

1. Create upload keystore: `keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
2. Create `android/key.properties` (gitignored) with `storePassword`, `keyPassword`, `keyAlias`, `storeFile`
3. Reference in `android/app/build.gradle.kts` signing configs

### ProGuard Rules

Keep Flutter and app classes when `minifyEnabled = true`:

```proguard
# android/app/proguard-rules.pro
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.patrimonium.** { *; }
```

### Pre-Release Checklist

- [ ] `flutter analyze` passes with no issues
- [ ] `flutter test` passes
- [ ] Version bumped in `pubspec.yaml` (`version: X.Y.Z+N`)
- [ ] Release build succeeds (`flutter build appbundle --release`)
- [ ] Tested on physical Android device
- [ ] Tested on Linux desktop
- [ ] No `print()` statements in production code (use `kDebugMode` guard)
- [ ] Sentry DSN configured for crash reporting

## Security Checklist

In addition to the PIN/secure-storage architecture already in place:

- [ ] All secrets in `flutter_secure_storage` (never `SharedPreferences`)
- [ ] HTTPS only for all network requests
- [ ] API tokens refreshed automatically on 401
- [ ] No hardcoded API keys in source — use `SecureStorageService`
- [ ] `print()` calls guarded by `kDebugMode` to avoid leaking data in production logs
- [ ] Code obfuscation enabled for release builds (`--obfuscate`)
- [x] `android:allowBackup="false"` in AndroidManifest.xml (prevents unencrypted PIN backup)
- [x] `INTERNET` permission in main AndroidManifest (not just debug)
- [ ] `android:usesCleartextTraffic="false"` in AndroidManifest.xml
- [ ] Input validation on all user-facing forms (amounts, text fields)
- [ ] Drift uses parameterized queries (built-in — never use `customSelect` with string interpolation)

## Project Conventions

### Architecture Decisions (ADRs)

| Decision | Rationale | Date |
|----------|-----------|------|
| Manual Riverpod (no codegen) | `riverpod_generator` conflicts with `analyzer_plugin` | Phase 1 |
| Drift data classes as domain models | No mapping boilerplate; barrel file narrows import surface | 0.3.14 |
| BYOK for LLM (no bundled API key) | User provides own key; Gemini Flash recommended as free default | Phase 3 |
| Integer cents for money | Floating point causes rounding errors in financial calculations | Phase 1 |
| `.autoDispose` on all feature providers | Memory efficiency; core infra providers (DB, repos) do NOT autoDispose | Phase 1 |
| Per-connection error handling in sync | A failing bank shouldn't skip remaining banks | 0.3.14 |
| No domain model layer | Drift types have ==, hashCode, copyWith, toJson — a parallel layer adds only boilerplate | 0.3.14 |

### File Organization Conventions

- **One provider file per feature**: `*_providers.dart` lives alongside its screen files
- **Domain services take repositories via constructor**: Never access `ref` or `ProviderContainer` inside domain services
- **Barrel file for presentation imports**: `models.dart` re-exports Drift data classes; presentation never imports `app_database.dart` directly
- **Static data in separate files**: Large const lists (merchant rules, category seeds) get their own file
- **Widget extraction threshold**: Split screen files at ~400 lines; extract into `widgets/` subdirectory
- **Re-export pattern for moved types**: When extracting a type from a provider file, use `export '...' show TypeName` so consumers don't need import changes

### Naming Conventions (Beyond Dart Standard)

- **Providers**: `{noun}Provider` for data, `{noun}ServiceProvider` for domain services, `{noun}RepositoryProvider` for repos
- **Screens**: `{Noun}Screen` (not `Page`)
- **Repository methods**: `watch*` returns `Stream`, `get*` returns `Future`, `insert*/update*/delete*` for mutations
- **Service methods**: Verb-first (`getTopCategorySpending`, `syncAllConnected`, `getBudgetsWithSpending`)
- **Test files**: Mirror source path — `lib/domain/usecases/auth/pin_service.dart` → `test/unit/usecases/auth/pin_service_test.dart`

### Money & Date Conventions

- All money: integer cents (`12345` = `$123.45`). Extensions in `core/extensions/money_extensions.dart`
- Income: positive `amountCents`. Expenses: negative `amountCents`
- Formatting: `int.toCurrency()` → `"$123.45"`, `int.toCompactCurrency()` → `"$1.2K"`, `int.isIncome` / `int.isExpense`
- All timestamps: Unix milliseconds as `int`. Extensions: `int.toDateTime()`, `DateTime.toRelative()`
- Date ranges: `DateTime.startOfMonth` / `endOfMonth` / `startOfDay` / `endOfDay`
- Date formatting: `toMediumDate()`, `toLongDate()`, `toShortDate()`, `toMonthDay()`, `toMonthYear()`
- Category icons: `categoryIconMap` in `core/constants/category_icons.dart` maps string names (stored in DB) → `IconData`

### Provider Invalidation Convention

After any sync operation that changes financial data, call `invalidateFinancialData(ref)` from `presentation/shared/utils/provider_invalidation.dart`. This refreshes all cached dashboard/budget FutureProviders. Currently called from:
- `dashboard_screen.dart` (full sync)
- `connection_detail_screen.dart` (single connection sync)
- `bank_connections_screen.dart` (list sync + single sync)

### Versioning

- **Patch** (`0.3.x`): features within current phase, bug fixes
- **Minor** (`0.x.0`): completing a phase or meaningful user-visible milestone
- **Major** (`1.0.0`): app complete and polished
- `versionCode` (`+N`): increments by 1 each release, must always exceed 2002
- Release tag format: `vX.Y.Z-release` (for Obtainium)

### Emulator Testing

Script at `tools/emu.sh` — source it to load helpers. See project memory for full details.
- AVD: `Medium_Phone_API_36.1` (1080x2400, 420dpi)
- Dev PIN: `984438`
- Key commands: `emu_fresh_start`, `emu_resume`, `emu_screenshot`, `emu_tab_*`

## Code Style

### Import Order

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Third-party packages (alphabetical)
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Project imports (alphabetical)
import 'package:patrimonium/core/di/providers.dart';
import 'package:patrimonium/data/repositories/account_repository.dart';
```

### File Size

- **Widget files**: Keep under 200 lines — extract sub-widgets
- **Repository files**: Keep under 300 lines
- **Provider files**: Keep under 150 lines
- If a file exceeds these limits, split by logical concern

### Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/methods: `camelCase`
- Private members: `_leadingUnderscore`
- Constants: `camelCase` (not SCREAMING_CASE)

## Current Status

- **Phase 1 (Foundation)**: Complete — database (21 tables), PIN auth with PBKDF2, biometric auth, Material 3 theme, secure storage, error handling, routing with auth redirects, settings screen, auto-lock
- **Phase 2 (Accounts & Transactions)**: Complete — accounts CRUD (18 types), transactions CRUD with filtering/search, category hierarchy with seeding, dashboard (net worth, cash flow, budget health, recent transactions, AI insights cards), onboarding flow, CSV export, account detail with transaction history
- **Phase 3 (Bank Connectivity & Data Import)**: In progress
  - **Complete**: SimpleFIN client + sync service, bank connections UI (setup, linking, detail), CSV import with column mapping and preview, recurring transaction detection, budget management screens, goal tracking screens, background sync manager scaffolding, investment holdings sync via SimpleFIN, auto-categorization backend (two-tier pipeline, 300 default merchant rules, learning from manual assignments, bulk categorize existing transactions), AI/LLM assistant (4 providers: Gemini/Claude/OpenAI/Ollama, chat UI, dashboard insights), adaptive app icon, code review fixes (lock screen bypass, dark theme copy-paste, O(N²) list builds, sync token safety), architecture hardening (barrel file for DB types, extracted analytics/budget/sync services, centralized provider invalidation, split oversized files)
  - **Note**: Linux background sync is in-process only (Timer.periodic while app is open) vs Android WorkManager. Disabling/re-enabling background sync requires app restart.
  - **Remaining**: Auto-categorization rules management UI, Supabase sync, OFX import
