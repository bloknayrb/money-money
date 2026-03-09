import 'package:drift/drift.dart';

import '../local/database/app_database.dart';

/// Repository for category CRUD and hierarchy operations.
class CategoryRepository {
  CategoryRepository(this._db);

  final AppDatabase _db;

  /// Watch all categories ordered by display order.
  Stream<List<Category>> watchAllCategories() {
    return (_db.select(_db.categories)
          ..orderBy([(c) => OrderingTerm.asc(c.displayOrder)]))
        .watch();
  }

  /// Watch expense categories only.
  Stream<List<Category>> watchExpenseCategories() {
    return (_db.select(_db.categories)
          ..where((c) => c.type.equals('expense'))
          ..orderBy([(c) => OrderingTerm.asc(c.displayOrder)]))
        .watch();
  }

  /// Watch income categories only.
  Stream<List<Category>> watchIncomeCategories() {
    return (_db.select(_db.categories)
          ..where((c) => c.type.equals('income'))
          ..orderBy([(c) => OrderingTerm.asc(c.displayOrder)]))
        .watch();
  }

  /// Get all top-level categories (no parent).
  Future<List<Category>> getTopLevelCategories({String? type}) {
    final query = _db.select(_db.categories)
      ..where((c) => c.parentId.isNull());
    if (type != null) {
      query.where((c) => c.type.equals(type));
    }
    query.orderBy([(c) => OrderingTerm.asc(c.displayOrder)]);
    return query.get();
  }

  /// Get subcategories for a parent.
  Future<List<Category>> getSubcategories(String parentId) {
    return (_db.select(_db.categories)
          ..where((c) => c.parentId.equals(parentId))
          ..orderBy([(c) => OrderingTerm.asc(c.displayOrder)]))
        .get();
  }

  /// Get a single category by ID.
  Future<Category?> getCategoryById(String id) {
    return (_db.select(_db.categories)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get all categories as a flat list.
  Future<List<Category>> getAllCategories() {
    return (_db.select(_db.categories)
          ..orderBy([(c) => OrderingTerm.asc(c.displayOrder)]))
        .get();
  }

  /// Insert a new category.
  Future<void> insertCategory(CategoriesCompanion category) {
    return _db.into(_db.categories).insert(category);
  }

  /// Insert multiple categories (bulk seed).
  Future<void> insertCategories(List<CategoriesCompanion> categories) {
    return _db.batch((batch) {
      batch.insertAll(_db.categories, categories);
    });
  }

  /// Update a category.
  Future<bool> updateCategory(CategoriesCompanion category) {
    return (_db.update(_db.categories)
          ..where((c) => c.id.equals(category.id.value)))
        .write(category)
        .then((rows) => rows > 0);
  }

  /// Delete a category and cascade: removes children, nulls out references
  /// on transactions/recurring, and deletes associated budgets.
  Future<void> deleteCategory(String id) async {
    await _db.transaction(() async {
      // Find child category IDs
      final children = await (_db.select(_db.categories)
            ..where((c) => c.parentId.equals(id)))
          .get();
      final childIds = children.map((c) => c.id).toList();
      final allIds = [id, ...childIds];

      // Null out categoryId on transactions referencing affected categories
      for (final catId in allIds) {
        await (_db.update(_db.transactions)
              ..where((t) => t.categoryId.equals(catId)))
            .write(const TransactionsCompanion(categoryId: Value(null)));
      }

      // Null out categoryId on recurring transactions
      for (final catId in allIds) {
        await (_db.update(_db.recurringTransactions)
              ..where((r) => r.categoryId.equals(catId)))
            .write(
                const RecurringTransactionsCompanion(categoryId: Value(null)));
      }

      // Delete budgets referencing affected categories
      for (final catId in allIds) {
        await (_db.delete(_db.budgets)
              ..where((b) => b.categoryId.equals(catId)))
            .go();
      }

      // Clean up auto-categorization tables
      for (final catId in allIds) {
        await (_db.delete(_db.payeeCategoryCache)
              ..where((c) => c.categoryId.equals(catId)))
            .go();
        await (_db.delete(_db.autoCategorizeRules)
              ..where((r) => r.categoryId.equals(catId)))
            .go();
      }

      // Delete child categories, then parent
      for (final childId in childIds) {
        await (_db.delete(_db.categories)..where((c) => c.id.equals(childId)))
            .go();
      }
      await (_db.delete(_db.categories)..where((c) => c.id.equals(id))).go();
    });
  }

  /// Check if any categories exist (for initial seed check).
  Future<bool> hasCategories() async {
    final count = _db.categories.id.count();
    final result = await (_db.selectOnly(_db.categories)
          ..addColumns([count]))
        .getSingle();
    return (result.read(count) ?? 0) > 0;
  }
}
