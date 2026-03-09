import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/local/database/app_database.dart';

/// All conversations, most recent first.
final conversationsProvider =
    StreamProvider.autoDispose<List<Conversation>>((ref) {
  return ref.watch(conversationRepositoryProvider).watchAllConversations();
});

/// Messages for a specific conversation, oldest first.
final messagesProvider =
    StreamProvider.autoDispose.family<List<Message>, String>((ref, id) {
  return ref.watch(conversationRepositoryProvider).watchMessages(id);
});

/// Whether the AI is currently streaming a response.
final isStreamingProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Accumulated streaming text — shown while the DB write is in-flight.
final streamingTextProvider =
    StateProvider.autoDispose<String>((ref) => '');
