import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/local/database/app_database.dart';
import '../../../data/repositories/category_repository.dart';

/// Seeds default categories into the database on first launch.
class CategorySeeder {
  CategorySeeder(this._categoryRepository);

  final CategoryRepository _categoryRepository;
  static const _uuid = Uuid();

  /// Seed default categories if none exist.
  ///
  /// Returns true if categories were seeded, false if they already existed.
  Future<bool> seedIfEmpty() async {
    final hasExisting = await _categoryRepository.hasCategories();
    if (hasExisting) return false;

    final companions = <CategoriesCompanion>[];
    final now = DateTime.now().millisecondsSinceEpoch;
    var displayOrder = 0;

    // Seed expense categories
    for (final catData in DefaultCategories.expense) {
      final parentId = _uuid.v4();
      companions.add(CategoriesCompanion.insert(
        id: parentId,
        name: catData['name'] as String,
        type: 'expense',
        icon: catData['icon'] as String,
        color: catData['color'] as int,
        displayOrder: displayOrder++,
        isSystem: const Value(true),
        createdAt: now,
        updatedAt: now,
      ));

      // Seed child categories
      final children = catData['children'] as List<dynamic>;
      for (final childName in children) {
        companions.add(CategoriesCompanion.insert(
          id: _uuid.v4(),
          name: childName as String,
          parentId: Value(parentId),
          type: 'expense',
          icon: catData['icon'] as String,
          color: catData['color'] as int,
          displayOrder: displayOrder++,
          isSystem: const Value(true),
          createdAt: now,
          updatedAt: now,
        ));
      }
    }

    // Seed income categories
    for (final catData in DefaultCategories.income) {
      final parentId = _uuid.v4();
      companions.add(CategoriesCompanion.insert(
        id: parentId,
        name: catData['name'] as String,
        type: 'income',
        icon: catData['icon'] as String,
        color: catData['color'] as int,
        displayOrder: displayOrder++,
        isSystem: const Value(true),
        createdAt: now,
        updatedAt: now,
      ));

      // Seed child categories if present
      final children = catData['children'] as List<dynamic>?;
      if (children != null) {
        for (final childName in children) {
          companions.add(CategoriesCompanion.insert(
            id: _uuid.v4(),
            name: childName as String,
            parentId: Value(parentId),
            type: 'income',
            icon: catData['icon'] as String,
            color: catData['color'] as int,
            displayOrder: displayOrder++,
            isSystem: const Value(true),
            createdAt: now,
            updatedAt: now,
          ));
        }
      }
    }

    await _categoryRepository.insertCategories(companions);
    return true;
  }
}
