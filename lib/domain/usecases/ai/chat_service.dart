import '../../../core/error/app_error.dart';
import '../../../data/remote/llm/llm_client.dart';
import '../../../data/repositories/conversation_repository.dart';
import 'context_builder.dart';

const _systemPrompt = '''
You are a personal finance assistant for Patrimonium. You help analyze spending,
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

/// Orchestrates sending a message, streaming the LLM response, and persisting results.
class ChatService {
  ChatService({
    required ConversationRepository conversationRepo,
    required ContextBuilder contextBuilder,
  })  : _conversationRepo = conversationRepo,
        _contextBuilder = contextBuilder;

  final ConversationRepository _conversationRepo;
  final ContextBuilder _contextBuilder;

  static const _dailyCallLimit = 50;
  int _callsToday = 0;
  DateTime? _firstCallDate;

  /// Send a user message and stream the assistant's response.
  ///
  /// Persists the user message before calling the LLM (crash-safe).
  /// The assistant message is persisted in [finally] to capture partial
  /// responses on stream errors.
  Stream<String> sendMessage({
    required LlmClient client,
    required String conversationId,
    required String userMessage,
  }) async* {
    _enforceRateLimit();

    // 1. Persist user message immediately (crash-safe ordering)
    await _conversationRepo.addMessage(conversationId, 'user', userMessage);

    // 2. Build fresh financial context for this turn
    final context = await _contextBuilder.buildContext();

    // 3. Load full conversation history from DB (includes the message we just saved)
    final dbMessages =
        await _conversationRepo.watchMessages(conversationId).first;
    final messages = [
      ChatMessage(role: 'context', content: context),
      ...dbMessages.map((m) => ChatMessage(role: m.role, content: m.content)),
    ];

    // 4. Stream LLM response, accumulating into buffer
    final buffer = StringBuffer();
    try {
      await for (final chunk
          in client.streamComplete(_systemPrompt, messages)) {
        buffer.write(chunk);
        yield chunk;
      }
    } finally {
      // 5. Always persist assistant message (captures partial on error too)
      if (buffer.isNotEmpty) {
        await _conversationRepo.addMessage(
          conversationId,
          'assistant',
          buffer.toString(),
        );
      }
    }

    // 6. Auto-title from first user message (truncated to 50 chars)
    await _maybeSetTitle(conversationId, userMessage);
  }

  void _enforceRateLimit() {
    final today = DateTime.now();
    if (_firstCallDate == null || !_isSameDay(_firstCallDate!, today)) {
      _callsToday = 0;
      _firstCallDate = today;
    }
    if (_callsToday >= _dailyCallLimit) {
      throw LLMError.rateLimited();
    }
    _callsToday++;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _maybeSetTitle(
      String conversationId, String userMessage) async {
    final messages =
        await _conversationRepo.watchMessages(conversationId).first;
    final userMessages = messages.where((m) => m.role == 'user');
    if (userMessages.length == 1) {
      final title = userMessage.length > 50
          ? '${userMessage.substring(0, 50)}...'
          : userMessage;
      await _conversationRepo.updateConversationTitle(conversationId, title);
    }
  }
}
