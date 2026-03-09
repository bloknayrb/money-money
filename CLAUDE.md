# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Patrimonium** is a personal finance management app with AI-powered insights, built with Flutter targeting Android and Linux desktop.

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
│   │   ├── database/       # Drift database (21 tables + generated code)
│   │   └── secure_storage/ # flutter_secure_storage wrapper
│   ├── remote/
│   │   ├── dio_client.dart           # Shared Dio instance config
│   │   └── simplefin/
│   │       ├── simplefin_client.dart # SimpleFIN HTTP client (claim, fetch)
│   │       └── simplefin_models.dart # SimpleFIN API DTOs
│   └── repositories/       # AccountRepository, TransactionRepository,
│                           # CategoryRepository, BudgetRepository,
│                           # BankConnectionRepository, GoalRepository,
│                           # ImportRepository, RecurringTransactionRepository,
│                           # AutoCategorizeRepository
├── domain/
│   └── usecases/
│       ├── auth/           # PinService, BiometricService
│       ├── categories/     # CategorySeeder
│       ├── categorize/     # AutoCategorizeService, RuleSeeder
│       ├── export/         # CsvExportService
│       ├── import/         # CsvImportService
│       ├── recurring/      # RecurringDetectionService
│       └── sync/           # SimplefinSyncService, BackgroundSyncManager
├── presentation/
│   ├── features/
│   │   ├── accounts/       # CRUD screens + accounts_providers.dart
│   │   ├── auth/           # LockScreen, PinSetupScreen
│   │   ├── bank_connections/ # SimpleFIN setup, connection list, account linking
│   │   ├── budgets/        # Budget CRUD + budgets_providers.dart
│   │   ├── dashboard/      # DashboardScreen (net worth, cash flow, etc.)
│   │   ├── goals/          # Goal CRUD + goals_providers.dart
│   │   ├── import/         # CSV import with column mapping, import history
│   │   ├── recurring/      # Recurring transaction detection + management
│   │   ├── transactions/   # CRUD screens + transactions_providers.dart
│   │   ├── ai_assistant/   # AiAssistantScreen (stub — no LLM backend yet)
│   │   ├── settings/       # SettingsScreen
│   │   └── onboarding/     # OnboardingScreen (first-launch welcome)
│   └── shared/
│       ├── widgets/        # AppShell, PinNumberPad, CategoryPickerSheet, DeleteConfirmationDialog
│       ├── utils/          # SnackbarHelpers
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
3. Feature-level providers in each feature's `*_providers.dart` file — depend on repository providers
4. Screens consume feature providers via `ref.watch()`

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
- **No CI/CD**: No GitHub Actions or CI pipeline is configured yet.

## Key Dependencies

| Category | Packages |
|----------|----------|
| **State** | flutter_riverpod, riverpod_annotation |
| **Database** | drift, sqlite3_flutter_libs |
| **Routing** | go_router |
| **HTTP** | dio |
| **Charts** | fl_chart |
| **Security** | flutter_secure_storage, local_auth, crypto |
| **Theme** | dynamic_color |
| **Serialization** | freezed_annotation, json_annotation |
| **Backend** | supabase_flutter (prepared, not yet wired) |
| **Monitoring** | sentry_flutter (imported, init TODO) |
| **Background** | workmanager |
| **Connectivity** | connectivity_plus |
| **Markdown** | flutter_markdown (for AI chat) |
| **Testing** | mocktail |

Note: `riverpod_generator` and `riverpod_lint` are commented out in pubspec.yaml due to `analyzer_plugin` compatibility issues.

## Testing

Test coverage is growing. Current tests: `test/unit/extensions/money_extensions_test.dart` (money formatting), `test/unit/usecases/auth/pin_service_test.dart` (PIN hashing/verification), `test/unit/usecases/auto_categorize_service_test.dart` (payee normalization, two-tier matching, confidence scoring, bulk categorization — 29 tests), `test/unit/database/app_database_test.dart` (basic DB operations). Repositories, providers, screens, and CSV export still lack test coverage. `mocktail` is available as a dev dependency for writing tests.

## Testing Guidelines

### Test Folder Structure

```
test/
├── unit/
│   ├── repositories/
│   │   └── account_repository_test.dart
│   ├── usecases/
│   │   ├── pin_service_test.dart
│   │   └── auto_categorize_service_test.dart
│   └── extensions/
│       └── money_extensions_test.dart
├── widget/
│   ├── screens/
│   │   └── dashboard_screen_test.dart
│   └── widgets/
│       └── pin_number_pad_test.dart
├── mocks/
│   └── mock_repositories.dart
├── fixtures/
│   └── test_data.dart
└── helpers/
    └── pump_app.dart
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
  - **Complete**: SimpleFIN client + sync service, bank connections UI (setup, linking, detail), CSV import with column mapping and preview, recurring transaction detection, budget management screens, goal tracking screens, background sync manager scaffolding, investment holdings sync via SimpleFIN, auto-categorization backend (two-tier pipeline, 300 default merchant rules, learning from manual assignments, bulk categorize existing transactions), AI/LLM assistant (4 providers: Gemini/Claude/OpenAI/Ollama, chat UI, dashboard insights), adaptive app icon, code review fixes (lock screen bypass, dark theme copy-paste, O(N²) list builds, sync token safety)
  - **Remaining**: Auto-categorization rules management UI, Supabase sync, OFX import
