import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database/app_database.dart';

/// Repository for AI conversation and message persistence.
class ConversationRepository {
  ConversationRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  // ─── Conversations ──────────────────────────────────────────────────

  /// Watch all conversations, most recent first.
  Stream<List<Conversation>> watchAllConversations() {
    return (_db.select(_db.conversations)
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .watch();
  }

  /// Create a new conversation and return its ID.
  Future<String> createConversation(String provider, String model) async {
    final id = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.conversations).insert(ConversationsCompanion(
      id: Value(id),
      provider: Value(provider),
      model: Value(model),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
    return id;
  }

  /// Update the display title of a conversation.
  Future<void> updateConversationTitle(String id, String title) {
    return (_db.update(_db.conversations)..where((c) => c.id.equals(id)))
        .write(ConversationsCompanion(
      title: Value(title),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  /// Delete a conversation and all its messages.
  Future<void> deleteConversation(String id) {
    return _db.transaction(() async {
      await (_db.delete(_db.messages)
            ..where((m) => m.conversationId.equals(id)))
          .go();
      await (_db.delete(_db.conversations)..where((c) => c.id.equals(id))).go();
    });
  }

  // ─── Messages ───────────────────────────────────────────────────────

  /// Watch messages for a conversation, oldest first.
  Stream<List<Message>> watchMessages(String conversationId) {
    return (_db.select(_db.messages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  }

  /// Get messages for a conversation (one-shot, for building LLM context).
  Future<List<Message>> getMessages(String conversationId) {
    return (_db.select(_db.messages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
  }

  /// Append a message to a conversation. Bumps the conversation's [updatedAt].
  Future<void> addMessage(
    String conversationId,
    String role,
    String content, {
    int? tokenCount,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.messages).insert(MessagesCompanion(
      id: Value(_uuid.v4()),
      conversationId: Value(conversationId),
      role: Value(role),
      content: Value(content),
      tokenCount: tokenCount != null ? Value(tokenCount) : const Value.absent(),
      createdAt: Value(now),
    ));
    await (_db.update(_db.conversations)
          ..where((c) => c.id.equals(conversationId)))
        .write(ConversationsCompanion(updatedAt: Value(now)));
  }

  /// Delete a single message by ID.
  Future<void> deleteMessage(String id) {
    return (_db.delete(_db.messages)..where((m) => m.id.equals(id))).go();
  }
}
