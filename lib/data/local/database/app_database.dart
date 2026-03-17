import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// =============================================================================
// CORE TABLES
// =============================================================================

/// Bank accounts, investment accounts, manual assets and liabilities.
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get institutionName => text().nullable()();
  TextColumn get accountType => text()();
  TextColumn get accountSubtype => text().nullable()();
  IntColumn get balanceCents => integer()();
  TextColumn get currencyCode => text().withDefault(const Constant('USD'))();
  BoolColumn get isAsset => boolean()();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
  IntColumn get displayOrder => integer()();
  IntColumn get color => integer().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get bankConnectionId => text().nullable()();
  TextColumn get externalId => text().nullable()();
  IntColumn get lastSyncedAt => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  BoolColumn get invertSign => boolean().withDefault(const Constant(false))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// All financial transactions. Amount in integer cents.
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  IntColumn get amountCents => integer()();
  IntColumn get date => integer()();
  TextColumn get payee => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  BoolColumn get isReviewed => boolean().withDefault(const Constant(false))();
  BoolColumn get isPending => boolean().withDefault(const Constant(false))();
  TextColumn get transferAccountId => text().nullable()();
  TextColumn get transferTransactionId => text().nullable()();
  TextColumn get externalId => text().nullable()();
  TextColumn get tags => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Hierarchical category tree for income and expense types.
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get type => text()(); // 'income' or 'expense'
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  IntColumn get displayOrder => integer()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Monthly/annual budget targets per category.
class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text()();
  IntColumn get amountCents => integer()();
  TextColumn get periodType => text()(); // 'monthly' or 'annual'
  IntColumn get startDate => integer()();
  IntColumn get endDate => integer().nullable()();
  BoolColumn get rollover => boolean().withDefault(const Constant(false))();
  IntColumn get rolloverAmountCents => integer().withDefault(const Constant(0))();
  RealColumn get alertThreshold => real().withDefault(const Constant(0.9))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Auto-categorization rules engine.
class AutoCategorizeRules extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get priority => integer()();
  TextColumn get payeeContains => text().nullable()();
  TextColumn get payeeExact => text().nullable()();
  IntColumn get amountMinCents => integer().nullable()();
  IntColumn get amountMaxCents => integer().nullable()();
  TextColumn get accountId => text().nullable()();
  TextColumn get categoryId => text()();
  TextColumn get accountType => text().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Financial goals: savings, debt payoff, net worth milestones.
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get goalType => text()();
  IntColumn get targetAmountCents => integer()();
  IntColumn get currentAmountCents => integer().withDefault(const Constant(0))();
  IntColumn get targetDate => integer().nullable()();
  TextColumn get linkedAccountId => text().nullable()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get completedAt => integer().nullable()();
  // Retirement projection fields (nullable — only set for retirement goals)
  IntColumn get monthlyContributionCents => integer().nullable()();
  IntColumn get annualReturnBps => integer().nullable()();         // 450 = 4.5% real
  IntColumn get annualVolatilityBps => integer().nullable()();     // 1500 = 15%
  IntColumn get retirementYear => integer().nullable()();
  IntColumn get desiredMonthlyIncomeCents => integer().nullable()(); // for 25x rule
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Investment holdings per account.
class InvestmentHoldings extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get symbol => text()();
  TextColumn get name => text()();
  RealColumn get quantity => real()();
  IntColumn get costBasisCents => integer()();
  IntColumn get currentPriceCents => integer()();
  IntColumn get currentValueCents => integer()();
  TextColumn get assetClass => text()();
  IntColumn get lastPriceUpdate => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Bank API connection metadata. Tokens in flutter_secure_storage.
class BankConnections extends Table {
  TextColumn get id => text()();
  TextColumn get provider => text()();
  TextColumn get institutionName => text()();
  TextColumn get status => text()();
  IntColumn get lastSyncedAt => integer().nullable()();
  TextColumn get errorMessage => text().nullable()();
  IntColumn get consecutiveFailures =>
      integer().withDefault(const Constant(0))();
  IntColumn get lastFailureTime => integer().nullable()();
  BoolColumn get isSyncing =>
      boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Detected recurring transaction patterns.
class RecurringTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get payee => text()();
  IntColumn get amountCents => integer()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get accountId => text()();
  TextColumn get frequency => text()();
  IntColumn get nextExpectedDate => integer()();
  IntColumn get lastOccurrenceDate => integer()();
  BoolColumn get isSubscription => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// =============================================================================
// CATEGORIZATION TABLES
// =============================================================================

/// Tier 1: payee → category lookup cache.
class PayeeCategoryCache extends Table {
  TextColumn get payeeNormalized => text()();
  TextColumn get categoryId => text()();
  RealColumn get confidence => real()();
  TextColumn get source => text()();
  IntColumn get useCount => integer().withDefault(const Constant(1))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {payeeNormalized};
}

/// User correction history for categorization learning.
class CategorizationCorrections extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text()();
  TextColumn get oldCategoryId => text().nullable()();
  TextColumn get newCategoryId => text()();
  TextColumn get payee => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// =============================================================================
// AI TABLES
// =============================================================================

/// AI chat sessions.
class Conversations extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().nullable()();
  TextColumn get provider => text()();
  TextColumn get model => text()();
  TextColumn get purpose => text().withDefault(const Constant('general'))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Individual chat messages.
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get role => text()();
  TextColumn get content => text()();
  IntColumn get tokenCount => integer().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// AI-generated and rule-based insights.
class Insights extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get insightType => text()();
  TextColumn get severity => text()();
  TextColumn get actionType => text().nullable()();
  TextColumn get actionData => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
  IntColumn get expiresAt => integer().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Permanent AI core memory (user preferences, key facts).
class AiMemoryCore extends Table {
  TextColumn get id => text()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cross-conversation semantic memory.
class AiMemorySemantic extends Table {
  TextColumn get id => text()();
  TextColumn get topic => text()();
  TextColumn get summary => text()();
  TextColumn get conversationId => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// User feedback on AI insights.
class InsightFeedback extends Table {
  TextColumn get id => text()();
  TextColumn get insightId => text()();
  TextColumn get rating => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// =============================================================================
// INFRASTRUCTURE TABLES
// =============================================================================

/// Cloud sync state tracking.
class SyncState extends Table {
  TextColumn get id => text()();
  TextColumn get entityTable => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  IntColumn get createdAt => integer()();
  IntColumn get syncedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Security and operation audit trail.
class AuditLog extends Table {
  TextColumn get id => text()();
  TextColumn get eventType => text()();
  TextColumn get details => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Data import history log.
class ImportHistory extends Table {
  TextColumn get id => text()();
  TextColumn get source => text()();
  TextColumn get fileName => text()();
  IntColumn get rowCount => integer()();
  IntColumn get importedCount => integer()();
  IntColumn get skippedCount => integer()();
  TextColumn get status => text()();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get bankConnectionId => text().nullable()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// User preferences and app settings.
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {key};
}

// =============================================================================
// DATABASE
// =============================================================================

@DriftDatabase(tables: [
  Accounts,
  Transactions,
  Categories,
  Budgets,
  AutoCategorizeRules,
  Goals,
  InvestmentHoldings,
  BankConnections,
  RecurringTransactions,
  PayeeCategoryCache,
  CategorizationCorrections,
  Conversations,
  Messages,
  Insights,
  AiMemoryCore,
  AiMemorySemantic,
  InsightFeedback,
  SyncState,
  AuditLog,
  ImportHistory,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Migration strategy: increment schemaVersion above, then add
          // sequential `if (from < N)` blocks below. Each block handles
          // the migration from version N-1 to N.
          //
          // Migrations are cumulative — a user upgrading from v1 to v3
          // will run both the v2 and v3 blocks in order.

          // v1 → v2: Add bankConnectionId to ImportHistory
          if (from < 2) {
            await m.addColumn(importHistory, importHistory.bankConnectionId);
          }

          // v2 → v3: Add indexes and circuit breaker columns
          if (from < 3) {
            // New columns on bank_connections
            await customStatement(
              'ALTER TABLE bank_connections ADD COLUMN consecutive_failures INTEGER NOT NULL DEFAULT 0',
            );
            await customStatement(
              'ALTER TABLE bank_connections ADD COLUMN last_failure_time INTEGER',
            );
            await customStatement(
              'ALTER TABLE bank_connections ADD COLUMN is_syncing INTEGER NOT NULL DEFAULT 0',
            );

            // Indexes
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_transactions_account_date ON transactions (account_id, date)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions (category_id)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_transactions_external_id ON transactions (external_id)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_transactions_is_reviewed ON transactions (is_reviewed)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_categories_parent ON categories (parent_id)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_categories_type ON categories (type)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_budgets_category ON budgets (category_id)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_budgets_end_date ON budgets (end_date)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_goals_linked_account ON goals (linked_account_id)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_goals_is_completed ON goals (is_completed)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_recurring_account ON recurring_transactions (account_id)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_recurring_is_active ON recurring_transactions (is_active)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_accounts_bank_connection ON accounts (bank_connection_id)',
            );
          }

          // v3 → v4: Retirement projection columns on Goals, purpose on Conversations
          if (from < 4) {
            await customStatement(
              'ALTER TABLE goals ADD COLUMN monthly_contribution_cents INTEGER',
            );
            await customStatement(
              'ALTER TABLE goals ADD COLUMN annual_return_bps INTEGER',
            );
            await customStatement(
              'ALTER TABLE goals ADD COLUMN annual_volatility_bps INTEGER',
            );
            await customStatement(
              'ALTER TABLE goals ADD COLUMN retirement_year INTEGER',
            );
            await customStatement(
              'ALTER TABLE goals ADD COLUMN desired_monthly_income_cents INTEGER',
            );
            await customStatement(
              "ALTER TABLE conversations ADD COLUMN purpose TEXT NOT NULL DEFAULT 'general'",
            );
          }

          // v4 → v5: Add invertSign column to Accounts
          if (from < 5) {
            await customStatement(
              'ALTER TABLE accounts ADD COLUMN invert_sign INTEGER NOT NULL DEFAULT 0',
            );
          }

          // v5 → v6: Add accountType column to AutoCategorizeRules
          if (from < 6) {
            await customStatement(
              'ALTER TABLE auto_categorize_rules ADD COLUMN account_type TEXT',
            );
          }
        },
        beforeOpen: (details) async {
          // Enable foreign key enforcement for all connections.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Open a connection to the database file.
  static Future<AppDatabase> open() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'patrimonium.db'));

    return AppDatabase(
      NativeDatabase.createInBackground(file),
    );
  }
}
