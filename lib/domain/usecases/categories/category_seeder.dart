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

  /// Seed default categories if none exist, and backfill any missing
  /// categories for existing users (e.g. after adding new default categories).
  ///
  /// Returns true if any categories were seeded.
  Future<bool> seedIfEmpty() async {
    final hasExisting = await _categoryRepository.hasCategories();
    if (hasExisting) {
      return _backfillMissing();
    }

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

  /// Backfill any default categories missing from an existing DB.
  ///
  /// Compares default category names against what's already seeded and
  /// inserts only the missing ones. Handles both parent and child categories.
  Future<bool> _backfillMissing() async {
    final existing = await _categoryRepository.getAllCategories();
    final existingNames = existing.map((c) => c.name).toSet();
    // Map parent names to their IDs for child category insertion
    final parentIdByName = <String, String>{};
    for (final c in existing.where((c) => c.parentId == null)) {
      parentIdByName[c.name] = c.id;
    }

    final companions = <CategoriesCompanion>[];
    final now = DateTime.now().millisecondsSinceEpoch;
    final maxOrder = existing.fold<int>(0, (m, c) => c.displayOrder > m ? c.displayOrder : m);
    var displayOrder = maxOrder + 1;

    for (final catData in [...DefaultCategories.expense, ...DefaultCategories.income]) {
      final name = catData['name'] as String;
      final type = DefaultCategories.expense.contains(catData) ? 'expense' : 'income';

      // Seed parent if missing
      String parentId;
      if (!existingNames.contains(name)) {
        parentId = _uuid.v4();
        companions.add(CategoriesCompanion.insert(
          id: parentId,
          name: name,
          type: type,
          icon: catData['icon'] as String,
          color: catData['color'] as int,
          displayOrder: displayOrder++,
          isSystem: const Value(true),
          createdAt: now,
          updatedAt: now,
        ));
        parentIdByName[name] = parentId;
      } else {
        parentId = parentIdByName[name] ?? '';
      }

      // Seed children if missing
      final children = catData['children'] as List<dynamic>?;
      if (children != null && parentId.isNotEmpty) {
        for (final childName in children) {
          if (!existingNames.contains(childName as String)) {
            companions.add(CategoriesCompanion.insert(
              id: _uuid.v4(),
              name: childName,
              parentId: Value(parentId),
              type: type,
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
    }

    if (companions.isEmpty) return false;
    await _categoryRepository.insertCategories(companions);
    return true;
  }
}
