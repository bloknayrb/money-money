import 'dart:convert';

import 'package:dio/dio.dart';

import 'llm_client.dart';

/// Base class for OpenAI-compatible Chat Completions APIs.
///
/// Subclasses provide [baseUrl], [providerName], and optionally
/// [extraHeaders] for provider-specific requirements.
abstract class OpenAiCompatibleClient implements LlmClient {
  OpenAiCompatibleClient({
    required this.apiKey,
    required Dio dio,
    required String model,
  })  : _dio = dio,
        _model = model;

  final String apiKey;
  final Dio _dio;
  final String _model;

  /// The API endpoint URL.
  String get baseUrl;

  /// Additional headers beyond the standard Authorization/Content-Type.
  Map<String, String> get extraHeaders => {};

  @override
  String get modelName => _model;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $apiKey',
        'content-type': 'application/json',
        'accept': 'text/event-stream',
        ...extraHeaders,
      };

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
      baseUrl,
      options: Options(
        headers: Map.of(_headers)..['accept'] = 'application/json',
        responseType: ResponseType.json,
      ),
      data: {
        'model': _model,
        'messages': _toApiMessages(systemPrompt, messages),
      },
    );

    final choices = response.data!['choices'] as List;
    final message = (choices.first as Map)['message'] as Map;
    return message['content'] as String;
  }

  @override
  Stream<String> streamComplete(
      String systemPrompt, List<ChatMessage> messages) async* {
    final response = await _dio.post<ResponseBody>(
      baseUrl,
      options: Options(
        headers: _headers,
        responseType: ResponseType.stream,
      ),
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

      final lines = raw.split('\n');
      buffer
        ..clear()
        ..write(lines.last);

      for (final line in lines.sublist(0, lines.length - 1)) {
        if (!line.startsWith('data: ')) continue;
        final data = line.substring(6).trim();
        if (data == '[DONE]' || data.isEmpty) continue;

        try {
          final json = jsonDecode(data) as Map<String, dynamic>;
          final choices = json['choices'] as List?;
          if (choices == null || choices.isEmpty) continue;

          final delta = (choices.first as Map)['delta'] as Map?;
          final text = delta?['content'] as String?;
          if (text != null && text.isNotEmpty) {
            yield text;
          }
        } catch (_) {
          // Skip malformed SSE lines
        }
      }
    }
  }
}
