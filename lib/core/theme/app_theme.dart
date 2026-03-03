import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

/// The user's theme preference.
enum AppThemeMode {
  system,
  light,
  dark,
  amoledBlack,
}

/// Finance-specific color extensions for the theme.
class FinanceColors extends ThemeExtension<FinanceColors> {
  final Color income;
  final Color expense;
  final Color budgetOnTrack;
  final Color budgetWarning;
  final Color budgetOver;
  final Color transfer;
  final Color netWorthPositive;
  final Color netWorthNegative;

  const FinanceColors({
    required this.income,
    required this.expense,
    required this.budgetOnTrack,
    required this.budgetWarning,
    required this.budgetOver,
    required this.transfer,
    required this.netWorthPositive,
    required this.netWorthNegative,
  });

  static const light = FinanceColors(
    income: Color(0xFF2E7D32),
    expense: Color(0xFFC62828),
    budgetOnTrack: Color(0xFF43A047),
    budgetWarning: Color(0xFFF9A825),
    budgetOver: Color(0xFFD32F2F),
    transfer: Color(0xFF1565C0),
    netWorthPositive: Color(0xFF1B5E20),
    netWorthNegative: Color(0xFFB71C1C),
  );

  static const dark = FinanceColors(
    income: Color(0xFF81C784),
    expense: Color(0xFFEF9A9A),
    budgetOnTrack: Color(0xFF81C784),
    budgetWarning: Color(0xFFFFD54F),
    budgetOver: Color(0xFFEF5350),
    transfer: Color(0xFF64B5F6),
    netWorthPositive: Color(0xFFA5D6A7),
    netWorthNegative: Color(0xFFEF9A9A),
  );

  @override
  FinanceColors copyWith({
    Color? income,
    Color? expense,
    Color? budgetOnTrack,
    Color? budgetWarning,
    Color? budgetOver,
    Color? transfer,
    Color? netWorthPositive,
    Color? netWorthNegative,
  }) {
    return FinanceColors(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      budgetOnTrack: budgetOnTrack ?? this.budgetOnTrack,
      budgetWarning: budgetWarning ?? this.budgetWarning,
      budgetOver: budgetOver ?? this.budgetOver,
      transfer: transfer ?? this.transfer,
      netWorthPositive: netWorthPositive ?? this.netWorthPositive,
      netWorthNegative: netWorthNegative ?? this.netWorthNegative,
    );
  }

  @override
  FinanceColors lerp(ThemeExtension<FinanceColors>? other, double t) {
    if (other is! FinanceColors) return this;
    return FinanceColors(
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      budgetOnTrack: Color.lerp(budgetOnTrack, other.budgetOnTrack, t)!,
      budgetWarning: Color.lerp(budgetWarning, other.budgetWarning, t)!,
      budgetOver: Color.lerp(budgetOver, other.budgetOver, t)!,
      transfer: Color.lerp(transfer, other.transfer, t)!,
      netWorthPositive: Color.lerp(netWorthPositive, other.netWorthPositive, t)!,
      netWorthNegative: Color.lerp(netWorthNegative, other.netWorthNegative, t)!,
    );
  }
}

/// Application theme builder.
class AppTheme {
  AppTheme._();

  /// Seed color: deep forest green.
  static const Color seedColor = Color(0xFF1B5E20);

  /// Build the light theme, using dynamic color if available.
  static ThemeData light([ColorScheme? dynamicScheme]) {
    final colorScheme = dynamicScheme?.harmonized() ??
        ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        );

    return _buildTheme(colorScheme, Brightness.light);
  }

  /// Build the dark theme, using dynamic color if available.
  static ThemeData dark([ColorScheme? dynamicScheme]) {
    final colorScheme = dynamicScheme?.harmonized() ??
        ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  /// Build the AMOLED black theme: pure black backgrounds for OLED screens.
  static ThemeData amoledBlack() {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    final colorScheme = baseScheme.copyWith(
      surface: const Color(0xFF000000),
      surfaceContainerLowest: const Color(0xFF000000),
      surfaceContainerLow: const Color(0xFF0A0A0A),
      surfaceContainer: const Color(0xFF111111),
      surfaceContainerHigh: const Color(0xFF1A1A1A),
      surfaceContainerHighest: const Color(0xFF222222),
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,

      // App Bar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        indicatorColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surface,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Snack Bar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Extensions
      extensions: [
        isLight ? FinanceColors.light : FinanceColors.dark,
      ],
    );
  }
}

/// Convenience extension to access FinanceColors from BuildContext.
extension FinanceColorsExtension on ThemeData {
  FinanceColors get finance => extension<FinanceColors>() ?? FinanceColors.light;
}
