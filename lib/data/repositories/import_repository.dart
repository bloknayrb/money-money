import 'package:drift/drift.dart';

import '../local/database/app_database.dart';

/// Repository for import history CRUD operations.
class ImportRepository {
  ImportRepository(this._db);

  final AppDatabase _db;

  /// Record an import in the history table.
  Future<void> insertImportRecord(ImportHistoryCompanion record) {
    return _db.into(_db.importHistory).insert(record);
  }

  /// Watch all import history records, most recent first.
  Stream<List<ImportHistoryData>> watchImportHistory() {
    return (_db.select(_db.importHistory)
          ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
        .watch();
  }

  /// Get all import history records, most recent first.
  Future<List<ImportHistoryData>> getImportHistory() {
    return (_db.select(_db.importHistory)
          ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
        .get();
  }

  /// Watch import history filtered by source, limited to most recent entries.
  Stream<List<ImportHistoryData>> watchImportHistoryBySource(
    String source, {
    int limit = 10,
  }) {
    return (_db.select(_db.importHistory)
          ..where((r) => r.source.equals(source))
          ..orderBy([(r) => OrderingTerm.desc(r.createdAt)])
          ..limit(limit))
        .watch();
  }

  /// Watch import history filtered by connection ID, limited to most recent entries.
  Stream<List<ImportHistoryData>> watchImportHistoryByConnection(
    String connectionId, {
    int limit = 10,
  }) {
    return (_db.select(_db.importHistory)
          ..where((r) => r.bankConnectionId.equals(connectionId))
          ..orderBy([(r) => OrderingTerm.desc(r.createdAt)])
          ..limit(limit))
        .watch();
  }

  /// Count import records by source since a given timestamp.
  Future<int> countBySourceSince(String source, int sinceTimestamp) async {
    final query = _db.select(_db.importHistory)
      ..where((r) => r.source.equals(source) & r.createdAt.isBiggerOrEqualValue(sinceTimestamp));
    final results = await query.get();
    return results.length;
  }

  /// Delete an import record by ID.
  Future<int> deleteImportRecord(String id) {
    return (_db.delete(_db.importHistory)..where((r) => r.id.equals(id))).go();
  }
}
