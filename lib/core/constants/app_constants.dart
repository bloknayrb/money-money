/// Core application constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Money Money';
  static const String appVersion = '0.3.3';

  /// Auto-lock timeout in seconds (default 5 minutes).
  static const int autoLockTimeoutSeconds = 300;

  /// Maximum failed PIN attempts before lockout.
  static const int maxPinAttempts = 5;

  /// Lockout durations in seconds after failed attempts.
  static const int shortLockoutSeconds = 30;
  static const int longLockoutSeconds = 300;

  /// Bank sync constraints.
  static const int minSyncIntervalMinutes = 15;
  static const int syncTimeoutSeconds = 60;
  static const int maxConsecutiveSyncFailures = 3;
  static const int maxDailySyncs = 24;
  static const int backgroundSyncIntervalHours = 8;

  /// LLM rate limits.
  static const int maxLlmCallsPerDay = 50;
  static const int maxInsightsPerDay = 5;

  /// Database.
  static const String databaseName = 'patrimonium.db';
  static const int databaseSchemaVersion = 1;
}

/// Default expense categories with icons and colors.
class DefaultCategories {
  DefaultCategories._();

  static const List<Map<String, dynamic>> expense = [
    {'name': 'Housing', 'icon': 'home', 'color': 0xFF5C6BC0, 'children': ['Rent/Mortgage', 'Utilities', 'Maintenance', 'Insurance']},
    {'name': 'Transportation', 'icon': 'directions_car', 'color': 0xFF42A5F5, 'children': ['Gas', 'Auto Payment', 'Auto Insurance', 'Parking', 'Public Transit']},
    {'name': 'Groceries', 'icon': 'shopping_cart', 'color': 0xFF66BB6A, 'children': <String>[]},
    {'name': 'Dining', 'icon': 'restaurant', 'color': 0xFFEF5350, 'children': ['Restaurants', 'Coffee Shops', 'Fast Food', 'Delivery']},
    {'name': 'Shopping', 'icon': 'shopping_bag', 'color': 0xFFAB47BC, 'children': ['Clothing', 'Electronics', 'Home Goods']},
    {'name': 'Entertainment', 'icon': 'movie', 'color': 0xFFFF7043, 'children': ['Subscriptions', 'Events', 'Hobbies', 'Games']},
    {'name': 'Healthcare', 'icon': 'local_hospital', 'color': 0xFFEC407A, 'children': ['Insurance', 'Medical', 'Pharmacy', 'Dental', 'Vision']},
    {'name': 'Personal Care', 'icon': 'spa', 'color': 0xFF26C6DA, 'children': ['Haircuts', 'Gym', 'Cosmetics']},
    {'name': 'Education', 'icon': 'school', 'color': 0xFF8D6E63, 'children': ['Tuition', 'Books', 'Courses']},
    {'name': 'Travel', 'icon': 'flight', 'color': 0xFF29B6F6, 'children': ['Flights', 'Hotels', 'Activities']},
    {'name': 'Gifts & Donations', 'icon': 'card_giftcard', 'color': 0xFFF06292, 'children': ['Gifts', 'Charity']},
    {'name': 'Pets', 'icon': 'pets', 'color': 0xFFA1887F, 'children': ['Food', 'Vet', 'Supplies']},
    {'name': 'Taxes', 'icon': 'account_balance', 'color': 0xFF78909C, 'children': ['Federal', 'State', 'Property']},
    {'name': 'Insurance', 'icon': 'shield', 'color': 0xFF7E57C2, 'children': ['Life', 'Health', 'Home', 'Auto']},
    {'name': 'Debt Payments', 'icon': 'credit_card', 'color': 0xFFE53935, 'children': ['Credit Card', 'Student Loan', 'Personal Loan']},
    {'name': 'Miscellaneous', 'icon': 'more_horiz', 'color': 0xFF9E9E9E, 'children': <String>[]},
  ];

  static const List<Map<String, dynamic>> income = [
    {'name': 'Salary', 'icon': 'work', 'color': 0xFF43A047},
    {'name': 'Freelance', 'icon': 'laptop', 'color': 0xFF2E7D32},
    {'name': 'Investments', 'icon': 'trending_up', 'color': 0xFF1B5E20},
    {'name': 'Interest', 'icon': 'savings', 'color': 0xFF4CAF50},
    {'name': 'Dividends', 'icon': 'account_balance_wallet', 'color': 0xFF388E3C},
    {'name': 'Refunds', 'icon': 'replay', 'color': 0xFF66BB6A},
    {'name': 'Other Income', 'icon': 'attach_money', 'color': 0xFF81C784},
  ];
}
