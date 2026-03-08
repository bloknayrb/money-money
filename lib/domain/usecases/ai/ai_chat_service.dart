import 'dart:async';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/remote/llm/llm_client.dart';
import '../../../data/repositories/conversation_repository.dart';
import 'financial_context_builder.dart';

/// Orchestrates LLM chat: manages conversations, injects financial context,
/// streams responses, and persists messages.
class AiChatService {
  AiChatService({
    required ConversationRepository conversationRepo,
    required FinancialContextBuilder contextBuilder,
  })  : _conversationRepo = conversationRepo,
        _contextBuilder = contextBuilder;

  final ConversationRepository _conversationRepo;
  final FinancialContextBuilder _contextBuilder;

  /// Send a user message and stream back the assistant response.
  ///
  /// If [conversationId] is null, creates a new conversation.
  /// Returns a tuple of (conversationId, Stream of text chunks).
  /// The stream yields incremental text. When complete, the full message is
  /// persisted and the streaming provider should be cleared.
  Future<(String conversationId, Stream<String> stream)> sendMessage({
    String? conversationId,
    required String userMessage,
    required LlmClient llmClient,
    required String provider,
    required String model,
  }) async {
    // Create conversation on first message
    final convId = conversationId ??
        await _createConversation(
          title: userMessage.length > 50
              ? '${userMessage.substring(0, 47)}...'
              : userMessage,
          provider: provider,
          model: model,
        );

    // Save user message
    final now = DateTime.now().millisecondsSinceEpoch;
    await _conversationRepo.insertMessage(MessagesCompanion.insert(
      id: const Uuid().v4(),
      conversationId: convId,
      role: 'user',
      content: userMessage,
      createdAt: now,
    ));

    // Build LLM messages: system prompt + conversation history
    final systemPrompt = await _contextBuilder.build();
    final history = await _conversationRepo.getMessages(convId);

    final llmMessages = [
      LlmMessage(role: 'system', content: _buildSystemPrompt(systemPrompt)),
      ...history.map((m) => LlmMessage(role: m.role, content: m.content)),
    ];

    // Truncate to last 20 user/assistant messages to manage token limits
    if (llmMessages.length > 21) {
      final system = llmMessages.first;
      final recent = llmMessages.skip(llmMessages.length - 20).toList();
      llmMessages
        ..clear()
        ..add(system)
        ..addAll(recent);
    }

    // Insert placeholder assistant message
    final assistantMsgId = const Uuid().v4();
    await _conversationRepo.insertMessage(MessagesCompanion.insert(
      id: assistantMsgId,
      conversationId: convId,
      role: 'assistant',
      content: '',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ));

    // Stream from LLM, accumulate, and persist on completion
    final stream = _accumulateAndPersist(
      llmClient.sendMessageStream(llmMessages),
      assistantMsgId,
      convId,
    );

    return (convId, stream);
  }

  Future<String> _createConversation({
    required String title,
    required String provider,
    required String model,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _conversationRepo.insertConversation(ConversationsCompanion.insert(
      id: id,
      title: Value(title),
      provider: provider,
      model: model,
      createdAt: now,
      updatedAt: now,
    ));
    return id;
  }

  Stream<String> _accumulateAndPersist(
    Stream<String> source,
    String msgId,
    String convId,
  ) async* {
    final buffer = StringBuffer();
    await for (final chunk in source) {
      buffer.write(chunk);
      yield chunk;
    }
    // Persist full response
    await _conversationRepo.updateMessageContent(msgId, buffer.toString());
    await _conversationRepo.touchConversation(convId);
  }

  String _buildSystemPrompt(String financialContext) {
    return '''You are a helpful personal finance assistant for the Patrimonium app. You have access to the user's financial data below. Give concise, actionable advice. Use specific numbers from their data when relevant.

$financialContext

Guidelines:
- Be concise and specific. Reference their actual accounts and amounts.
- For budgeting questions, suggest concrete dollar amounts based on their income.
- Flag any concerning patterns you see (overspending, low savings rate, etc.).
- If you're unsure, say so. Don't make up financial advice.
- Format amounts as currency (e.g., \$1,234.56).
- Use markdown for formatting when helpful.''';
  }
}
