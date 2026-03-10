import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/repositories/auto_categorize_repository.dart';
import '../../../data/repositories/category_repository.dart';

/// Result of a CSV rules import operation.
class RulesImportResult {
  const RulesImportResult({
    required this.imported,
    required this.skippedDuplicate,
    required this.skippedCategoryNotFound,
    required this.unknownCategories,
  });

  final int imported;
  final int skippedDuplicate;
  final int skippedCategoryNotFound;
  final List<String> unknownCategories;
}

/// Imports auto-categorization rules from CSV content.
///
/// CSV format — two columns, optional header row:
/// ```
/// payee,category
/// KROGER,Groceries
/// MY LOCAL GYM,Gym & Fitness
/// ```
///
/// Payees are uppercased and stored as `payeeContains`.
/// Categories are matched by name (case-insensitive); parent wins on duplicates.
class RulesImportService {
  RulesImportService(this._autoCategorizeRepository, this._categoryRepository);

  final AutoCategorizeRepository _autoCategorizeRepository;
  final CategoryRepository _categoryRepository;

  static const _uuid = Uuid();

  Future<RulesImportResult> importFromCsv(String csvContent) async {
    final rows = _parseCsv(csvContent);
    if (rows.isEmpty) {
      return const RulesImportResult(
        imported: 0,
        skippedDuplicate: 0,
        skippedCategoryNotFound: 0,
        unknownCategories: [],
      );
    }

    // Auto-detect header: skip first row if it looks like a header.
    final dataRows = _hasHeader(rows.first) ? rows.skip(1).toList() : rows;

    // Build name → ID lookup (parents first so parent wins on duplicate names).
    final categories = await _categoryRepository.getAllCategories();
    final catByName = <String, String>{};
    for (final c in categories.where((c) => c.parentId == null)) {
      catByName.putIfAbsent(c.name.toLowerCase(), () => c.id);
    }
    for (final c in categories.where((c) => c.parentId != null)) {
      catByName.putIfAbsent(c.name.toLowerCase(), () => c.id);
    }

    // Build set of existing payeeContains for dedup.
    final existingRules = await _autoCategorizeRepository.getAllRules();
    final existingPayees = <String>{
      for (final r in existingRules)
        if (r.payeeContains != null) r.payeeContains!,
    };

    // Find max priority among existing rules so new rules land above defaults.
    final maxPriority =
        existingRules.isEmpty ? -1 : existingRules.map((r) => r.priority).reduce((a, b) => a > b ? a : b);
    var priority = maxPriority + 1;

    final now = DateTime.now().millisecondsSinceEpoch;
    final toInsert = <AutoCategorizeRulesCompanion>[];
    var skippedDuplicate = 0;
    var skippedCategoryNotFound = 0;
    final unknownCategories = <String>[];

    for (final row in dataRows) {
      if (row.length < 2) continue;
      final payee = row[0].trim().toUpperCase();
      final categoryName = row[1].trim();
      if (payee.isEmpty || categoryName.isEmpty) continue;

      if (existingPayees.contains(payee)) {
        skippedDuplicate++;
        continue;
      }

      final categoryId = catByName[categoryName.toLowerCase()];
      if (categoryId == null) {
        skippedCategoryNotFound++;
        if (!unknownCategories.contains(categoryName)) {
          unknownCategories.add(categoryName);
        }
        continue;
      }

      existingPayees.add(payee); // prevent intra-batch duplicates
      toInsert.add(AutoCategorizeRulesCompanion.insert(
        id: _uuid.v4(),
        name: '$payee → $categoryName',
        priority: priority++,
        categoryId: categoryId,
        payeeContains: Value(payee),
        isEnabled: const Value(true),
        createdAt: now,
        updatedAt: now,
      ));
    }

    if (toInsert.isNotEmpty) {
      await _autoCategorizeRepository.insertRules(toInsert);
    }

    return RulesImportResult(
      imported: toInsert.length,
      skippedDuplicate: skippedDuplicate,
      skippedCategoryNotFound: skippedCategoryNotFound,
      unknownCategories: unknownCategories,
    );
  }

  /// Parse CSV content into rows of string values.
  List<List<String>> _parseCsv(String content) {
    final rows = <List<String>>[];
    for (final line in content.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      rows.add(_parseLine(trimmed));
    }
    return rows;
  }

  List<String> _parseLine(String line) {
    final fields = <String>[];
    final buffer = StringBuffer();
    var inQuotes = false;
    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        inQuotes = !inQuotes;
      } else if (ch == ',' && !inQuotes) {
        fields.add(buffer.toString().trim());
        buffer.clear();
      } else {
        buffer.write(ch);
      }
    }
    fields.add(buffer.toString().trim());
    return fields;
  }

  bool _hasHeader(List<String> firstRow) {
    if (firstRow.length < 2) return false;
    final a = firstRow[0].toLowerCase();
    final b = firstRow[1].toLowerCase();
    return a.contains('payee') || b.contains('category');
  }
}
