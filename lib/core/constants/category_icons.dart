import 'package:flutter/material.dart';

/// Maps icon name strings (stored in the database) to Flutter [IconData].
///
/// Used by category management screens and pickers to display the correct icon.
const Map<String, IconData> categoryIconMap = {
  // Housing & Home
  'home': Icons.home,
  'home_work': Icons.home_work,
  'house': Icons.house,
  'apartment': Icons.apartment,

  // Transportation
  'directions_car': Icons.directions_car,
  'local_gas_station': Icons.local_gas_station,
  'directions_bus': Icons.directions_bus,
  'flight': Icons.flight,
  'local_parking': Icons.local_parking,
  'directions_bike': Icons.directions_bike,

  // Food & Dining
  'restaurant': Icons.restaurant,
  'shopping_cart': Icons.shopping_cart,
  'local_cafe': Icons.local_cafe,
  'fastfood': Icons.fastfood,
  'delivery_dining': Icons.delivery_dining,
  'local_bar': Icons.local_bar,

  // Shopping
  'shopping_bag': Icons.shopping_bag,
  'store': Icons.store,
  'devices': Icons.devices,

  // Entertainment
  'movie': Icons.movie,
  'sports_esports': Icons.sports_esports,
  'music_note': Icons.music_note,
  'theater_comedy': Icons.theater_comedy,

  // Health & Personal
  'local_hospital': Icons.local_hospital,
  'spa': Icons.spa,
  'fitness_center': Icons.fitness_center,
  'medical_services': Icons.medical_services,
  'health_and_safety': Icons.health_and_safety,

  // Education
  'school': Icons.school,
  'menu_book': Icons.menu_book,
  'auto_stories': Icons.auto_stories,

  // Finance
  'account_balance': Icons.account_balance,
  'credit_card': Icons.credit_card,
  'savings': Icons.savings,
  'account_balance_wallet': Icons.account_balance_wallet,
  'attach_money': Icons.attach_money,
  'money': Icons.money,
  'money_off': Icons.money_off,
  'trending_up': Icons.trending_up,
  'currency_bitcoin': Icons.currency_bitcoin,
  'credit_score': Icons.credit_score,

  // Work & Business
  'work': Icons.work,
  'laptop': Icons.laptop,
  'business_center': Icons.business_center,

  // Gifts & Social
  'card_giftcard': Icons.card_giftcard,
  'volunteer_activism': Icons.volunteer_activism,
  'favorite': Icons.favorite,

  // Pets
  'pets': Icons.pets,

  // Utilities & Services
  'bolt': Icons.bolt,
  'water_drop': Icons.water_drop,
  'wifi': Icons.wifi,
  'phone': Icons.phone,
  'build': Icons.build,

  // Misc
  'shield': Icons.shield,
  'more_horiz': Icons.more_horiz,
  'category': Icons.category,
  'replay': Icons.replay,
  'receipt_long': Icons.receipt_long,
  'child_care': Icons.child_care,
};

/// Returns [IconData] for a stored icon name, falling back to [Icons.category].
IconData getCategoryIcon(String? iconName) {
  if (iconName == null) return Icons.category;
  return categoryIconMap[iconName] ?? Icons.category;
}

/// Curated subset of icons for the icon picker UI.
const List<String> pickableIconNames = [
  'home', 'apartment', 'directions_car', 'local_gas_station',
  'flight', 'directions_bus', 'directions_bike',
  'restaurant', 'shopping_cart', 'local_cafe', 'fastfood',
  'shopping_bag', 'store', 'devices',
  'movie', 'sports_esports', 'music_note',
  'local_hospital', 'spa', 'fitness_center', 'health_and_safety',
  'school', 'menu_book',
  'account_balance', 'credit_card', 'savings', 'attach_money', 'trending_up',
  'work', 'laptop', 'business_center',
  'card_giftcard', 'volunteer_activism', 'favorite',
  'pets', 'bolt', 'water_drop', 'wifi', 'phone', 'build',
  'shield', 'category', 'receipt_long', 'child_care',
];

/// Curated color palette for category colors.
const List<int> pickableColors = [
  0xFFE53935, // Red
  0xFFD81B60, // Pink
  0xFF8E24AA, // Purple
  0xFF5E35B1, // Deep Purple
  0xFF3949AB, // Indigo
  0xFF1E88E5, // Blue
  0xFF039BE5, // Light Blue
  0xFF00ACC1, // Cyan
  0xFF00897B, // Teal
  0xFF43A047, // Green
  0xFF7CB342, // Light Green
  0xFFC0CA33, // Lime
  0xFFFDD835, // Yellow
  0xFFFFB300, // Amber
  0xFFFB8C00, // Orange
  0xFFF4511E, // Deep Orange
  0xFF6D4C41, // Brown
  0xFF757575, // Grey
  0xFF546E7A, // Blue Grey
  0xFF78909C, // Blue Grey Light
];
