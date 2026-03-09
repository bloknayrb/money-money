import 'dart:convert';

import 'package:dio/dio.dart';

import 'llm_client.dart';

/// LLM client for Anthropic Claude via the Messages API.
class ClaudeClient implements LlmClient {
  ClaudeClient({
    required this.apiKey,
    required Dio dio,
    String model = 'claude-haiku-4-5-20251001',
  })  : _dio = dio,
        _model = model;

  final String apiKey;
  final Dio _dio;
  final String _model;

  static const _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const _anthropicVersion = '2023-06-01';

  @override
  String get providerName => 'claude';

  @override
  String get modelName => _model;

  Map<String, String> get _headers => {
        'x-api-key': apiKey,
        'anthropic-version': _anthropicVersion,
        'content-type': 'application/json',
        'accept': 'text/event-stream',
      };

  List<Map<String, String>> _toApiMessages(List<ChatMessage> messages) {
    return messages.map((m) {
      // 'context' role maps to 'user' for Claude
      final role = m.role == 'assistant' ? 'assistant' : 'user';
      return {'role': role, 'content': m.content};
    }).toList();
  }

  @override
  Future<String> complete(
      String systemPrompt, List<ChatMessage> messages) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _baseUrl,
      options: Options(
        headers: Map.of(_headers)..['accept'] = 'application/json',
        responseType: ResponseType.json,
      ),
      data: {
        'model': _model,
        'max_tokens': 1024,
        'system': systemPrompt,
        'messages': _toApiMessages(messages),
      },
    );

    final content = response.data!['content'] as List;
    return (content.first as Map)['text'] as String;
  }

  @override
  Stream<String> streamComplete(
      String systemPrompt, List<ChatMessage> messages) async* {
    final response = await _dio.post<ResponseBody>(
      _baseUrl,
      options: Options(
        headers: _headers,
        responseType: ResponseType.stream,
      ),
      data: {
        'model': _model,
        'max_tokens': 1024,
        'system': systemPrompt,
        'stream': true,
        'messages': _toApiMessages(messages),
      },
    );

    final stream = response.data!.stream;
    final buffer = StringBuffer();

    await for (final chunk in stream) {
      buffer.write(utf8.decode(chunk));
      final raw = buffer.toString();

      // Process complete lines only (SSE lines end with \n)
      final lines = raw.split('\n');
      // Keep the last (potentially incomplete) segment in the buffer
      buffer
        ..clear()
        ..write(lines.last);

      for (final line in lines.sublist(0, lines.length - 1)) {
        if (!line.startsWith('data: ')) continue;
        final data = line.substring(6).trim();
        if (data == '[DONE]' || data.isEmpty) continue;

        try {
          final json = jsonDecode(data) as Map<String, dynamic>;
          final type = json['type'] as String?;
          if (type == 'content_block_delta') {
            final delta = json['delta'] as Map<String, dynamic>?;
            if (delta?['type'] == 'text_delta') {
              yield delta!['text'] as String;
            }
          }
        } catch (_) {
          // Skip malformed SSE lines
        }
      }
    }
  }
}
