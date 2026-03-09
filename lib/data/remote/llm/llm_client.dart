/// Abstract interface for LLM provider clients.
abstract class LlmClient {
  /// One-shot completion — returns the full response as a string.
  Future<String> complete(String systemPrompt, List<ChatMessage> messages);

  /// Streaming completion — yields incremental text chunks.
  Stream<String> streamComplete(String systemPrompt, List<ChatMessage> messages);

  String get providerName;
  String get modelName;
}

/// A single message in a conversation.
class ChatMessage {
  final String role; // 'user', 'assistant', or 'context'
  final String content;

  const ChatMessage({required this.role, required this.content});
}
