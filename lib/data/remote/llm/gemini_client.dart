import 'package:google_generative_ai/google_generative_ai.dart';

import 'llm_client.dart';

/// LLM client for Google Gemini via the official Dart SDK.
class GeminiClient implements LlmClient {
  GeminiClient({
    required this.apiKey,
    String model = 'gemini-2.0-flash',
  }) : _modelName = model;

  final String apiKey;
  final String _modelName;

  GenerativeModel? _model;
  String? _cachedSystemPrompt;

  @override
  String get providerName => 'gemini';

  @override
  String get modelName => _modelName;

  /// Returns a cached model, recreating only when the system prompt changes.
  GenerativeModel _getModel(String systemPrompt) {
    if (_model == null || _cachedSystemPrompt != systemPrompt) {
      _cachedSystemPrompt = systemPrompt;
      _model = GenerativeModel(
        model: _modelName,
        apiKey: apiKey,
        systemInstruction: Content.system(systemPrompt),
      );
    }
    return _model!;
  }

  List<Content> _toGeminiHistory(List<ChatMessage> messages) {
    return messages.map((m) {
      // Gemini uses 'user' and 'model' roles
      final role = m.role == 'assistant' ? 'model' : 'user';
      return Content(role, [TextPart(m.content)]);
    }).toList();
  }

  @override
  Future<String> complete(
      String systemPrompt, List<ChatMessage> messages) async {
    final model = _getModel(systemPrompt);
    final history = _toGeminiHistory(messages);

    GenerateContentResponse response;
    if (history.length > 1) {
      final chat = model.startChat(history: history.sublist(0, history.length - 1));
      response = await chat.sendMessage(history.last);
    } else {
      response = await model.generateContent(history);
    }

    return response.text ?? '';
  }

  @override
  Stream<String> streamComplete(
      String systemPrompt, List<ChatMessage> messages) async* {
    final model = _getModel(systemPrompt);
    final history = _toGeminiHistory(messages);

    Stream<GenerateContentResponse> responseStream;
    if (history.length > 1) {
      final chat = model.startChat(history: history.sublist(0, history.length - 1));
      responseStream = chat.sendMessageStream(history.last);
    } else {
      responseStream = model.generateContentStream(history);
    }

    await for (final response in responseStream) {
      final text = response.text;
      if (text != null && text.isNotEmpty) {
        yield text;
      }
    }
  }
}
