import '../../../core/constants/app_constants.dart';
import '../../../data/remote/llm/llm_client.dart';
import '../../../data/repositories/conversation_repository.dart';
import 'context_builder.dart';

const _systemPrompt = '''
You are a personal finance assistant for Money Money. You help analyze spending,
optimize budgets, and plan financial goals based on the user's actual financial data.

Rules:
- Be concise and specific. Use actual numbers from the data provided.
- Say "I don't have enough data" rather than guessing.
- You are not a licensed financial advisor. For tax, legal, or investment-specific
  questions, recommend consulting a professional.
- Focus on actionable insights: "You spent \$X more on dining this month than last"
  rather than generic advice.
- When suggesting budget changes, reference specific categories and amounts.
- Format currency as \$X,XXX.XX. Use markdown for structure.
''';

/// Exception thrown when the daily LLM call limit is reached.
class RateLimitException implements Exception {
  const RateLimitException();
  @override
  String toString() =>
      'Daily limit of ${AppConstants.maxLlmCallsPerDay} AI queries reached.';
}

/// Orchestrates sending messages, streaming responses, and persisting conversation history.
class ChatService {
  ChatService({
    required ConversationRepository conversationRepo,
    required ContextBuilder contextBuilder,
  })  : _conversationRepo = conversationRepo,
        _contextBuilder = contextBuilder;

  final ConversationRepository _conversationRepo;
  final ContextBuilder _contextBuilder;

  // In-memory daily rate limit tracking
  int _callsToday = 0;
  DateTime? _rateLimitResetDate;

  bool _isRateLimited() {
    final today = DateTime.now();
    if (_rateLimitResetDate == null ||
        today.day != _rateLimitResetDate!.day ||
        today.month != _rateLimitResetDate!.month ||
        today.year != _rateLimitResetDate!.year) {
      // New day — reset counter
      _callsToday = 0;
      _rateLimitResetDate = today;
    }
    return _callsToday >= AppConstants.maxLlmCallsPerDay;
  }

  /// Send a message and stream the assistant's response.
  ///
  /// Saves the user message before the LLM call (no data loss on crash).
  /// Saves the assistant message in a finally block (captures partial on error).
  Stream<String> sendMessage({
    required LlmClient client,
    required String conversationId,
    required String userMessage,
    String? systemPromptOverride,
  }) async* {
    if (_isRateLimited()) throw const RateLimitException();
    _callsToday++;

    // Save user message first — before any network call
    await _conversationRepo.addMessage(conversationId, 'user', userMessage);

    // Build fresh financial context each turn
    final context = await _contextBuilder.buildContext();

    // Load conversation history
    final dbMessages = await _conversationRepo.getMessages(conversationId);
    final history = dbMessages.map((m) {
      return ChatMessage(role: m.role, content: m.content);
    }).toList();

    // Prepend financial context as first user-role message
    final messages = [
      ChatMessage(role: 'context', content: context),
      ...history,
    ];

    // Stream response, accumulate for DB save
    final buffer = StringBuffer();
    try {
      final prompt = systemPromptOverride ?? _systemPrompt;
      await for (final chunk in client.streamComplete(prompt, messages)) {
        buffer.write(chunk);
        yield chunk;
      }
    } finally {
      // Always save assistant message — even partial responses on error
      if (buffer.isNotEmpty) {
        await _conversationRepo.addMessage(
          conversationId,
          'assistant',
          buffer.toString(),
        );
      }
    }

    // Auto-title: first exchange — use first 50 chars of user message
    await _maybeSetTitle(conversationId, userMessage);
  }

  Future<void> _maybeSetTitle(
      String conversationId, String userMessage) async {
    final messages = await _conversationRepo.getMessages(conversationId);
    // Only set title after first exchange (user + assistant = 2 messages)
    if (messages.length == 2) {
      final title = userMessage.length > 50
          ? '${userMessage.substring(0, 50)}…'
          : userMessage;
      await _conversationRepo.updateConversationTitle(conversationId, title);
    }
  }
}
