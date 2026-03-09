import 'dart:convert';

import 'package:dio/dio.dart';

import 'llm_client.dart';

/// LLM client for local Ollama server.
///
/// Uses NDJSON streaming (not SSE) — each line is a complete JSON object.
class OllamaClient implements LlmClient {
  OllamaClient({
    required this.baseUrl,
    required Dio dio,
    String model = 'llama3.2',
  })  : _dio = dio,
        _model = model;

  final String baseUrl;
  final Dio _dio;
  final String _model;

  @override
  String get providerName => 'ollama';

  @override
  String get modelName => _model;

  String get _chatUrl => '$baseUrl/api/chat';

  List<Map<String, String>> _toApiMessages(
      String systemPrompt, List<ChatMessage> messages) {
    return [
      {'role': 'system', 'content': systemPrompt},
      ...messages.map((m) {
        final role = m.role == 'assistant' ? 'assistant' : 'user';
        return {'role': role, 'content': m.content};
      }),
    ];
  }

  @override
  Future<String> complete(
      String systemPrompt, List<ChatMessage> messages) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _chatUrl,
      options: Options(responseType: ResponseType.json),
      data: {
        'model': _model,
        'stream': false,
        'messages': _toApiMessages(systemPrompt, messages),
      },
    );

    final message = response.data!['message'] as Map;
    return message['content'] as String;
  }

  @override
  Stream<String> streamComplete(
      String systemPrompt, List<ChatMessage> messages) async* {
    final response = await _dio.post<ResponseBody>(
      _chatUrl,
      options: Options(responseType: ResponseType.stream),
      data: {
        'model': _model,
        'stream': true,
        'messages': _toApiMessages(systemPrompt, messages),
      },
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();

    await for (final chunk in stream) {
      buffer.write(utf8.decode(chunk));
      final raw = buffer.toString();

      // NDJSON: split on newlines, each complete line is a JSON object
      final lines = raw.split('\n');
      buffer
        ..clear()
        ..write(lines.last);

      for (final line in lines.sublist(0, lines.length - 1)) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;

        try {
          final json = jsonDecode(trimmed) as Map<String, dynamic>;
          final done = json['done'] as bool? ?? false;
          if (done) break;

          final message = json['message'] as Map?;
          final content = message?['content'] as String?;
          if (content != null && content.isNotEmpty) {
            yield content;
          }
        } catch (_) {
          // Skip malformed lines
        }
      }
    }
  }

  /// Returns available models from the Ollama server.
  Future<List<String>> listModels() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$baseUrl/api/tags',
        options: Options(responseType: ResponseType.json),
      );
      final models = response.data!['models'] as List? ?? [];
      return models
          .map((m) => (m as Map)['name'] as String)
          .toList();
    } catch (_) {
      return [];
    }
  }
}
