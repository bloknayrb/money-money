import 'package:drift/drift.dart';

import '../local/database/app_database.dart';

/// Repository for insight and feedback CRUD operations.
class InsightRepository {
  InsightRepository(this._db);

  final AppDatabase _db;

  /// Watch active insights (not dismissed, not expired).
  Stream<List<Insight>> watchActiveInsights() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (_db.select(_db.insights)
          ..where((i) =>
              i.isDismissed.equals(false) &
              (i.expiresAt.isNull() | i.expiresAt.isBiggerOrEqualValue(now)))
          ..orderBy([(i) => OrderingTerm.desc(i.createdAt)]))
        .watch();
  }

  /// Watch unread active insights.
  Stream<List<Insight>> watchUnreadInsights() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (_db.select(_db.insights)
          ..where((i) =>
              i.isDismissed.equals(false) &
              i.isRead.equals(false) &
              (i.expiresAt.isNull() | i.expiresAt.isBiggerOrEqualValue(now)))
          ..orderBy([(i) => OrderingTerm.desc(i.createdAt)]))
        .watch();
  }

  /// Insert a new insight.
  Future<void> insertInsight(InsightsCompanion insight) {
    return _db.into(_db.insights).insert(insight);
  }

  /// Insert multiple insights.
  Future<void> insertInsights(List<InsightsCompanion> insights) {
    return _db.batch((batch) {
      batch.insertAll(_db.insights, insights);
    });
  }

  /// Mark an insight as read.
  Future<void> markRead(String id) {
    return (_db.update(_db.insights)..where((i) => i.id.equals(id)))
        .write(const InsightsCompanion(isRead: Value(true)));
  }

  /// Mark all unread active insights as read.
  Future<void> markAllRead() {
    return (_db.update(_db.insights)
          ..where(
              (i) => i.isRead.equals(false) & i.isDismissed.equals(false)))
        .write(const InsightsCompanion(isRead: Value(true)));
  }

  /// Dismiss an insight.
  Future<void> dismiss(String id) {
    return (_db.update(_db.insights)..where((i) => i.id.equals(id)))
        .write(const InsightsCompanion(isDismissed: Value(true)));
  }

  /// Insert feedback for an insight.
  Future<void> insertFeedback(InsightFeedbackCompanion feedback) {
    return _db.into(_db.insightFeedback).insert(feedback);
  }

  /// Check if a non-dismissed insight with the given title exists since [sinceMs].
  Future<bool> hasRecentInsight(String title, int sinceMs) async {
    final result = await (_db.select(_db.insights)
          ..where((i) =>
              i.title.equals(title) &
              i.isDismissed.equals(false) &
              i.createdAt.isBiggerOrEqualValue(sinceMs))
          ..limit(1))
        .get();
    return result.isNotEmpty;
  }

  /// Delete expired insights.
  Future<int> deleteExpired() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (_db.delete(_db.insights)
          ..where(
              (i) => i.expiresAt.isNotNull() & i.expiresAt.isSmallerThanValue(now)))
        .go();
  }

  /// Delete all insights.
  Future<int> deleteAll() {
    return _db.delete(_db.insights).go();
  }
}
