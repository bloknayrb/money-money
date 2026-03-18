import 'package:dio/dio.dart';

import 'openai_compatible_client.dart';

/// LLM client for OpenRouter (OpenAI-compatible API).
class OpenRouterClient extends OpenAiCompatibleClient {
  OpenRouterClient({
    required super.apiKey,
    required Dio dio,
    String model = 'openrouter/auto',
  }) : super(dio: dio, model: model);

  @override
  String get baseUrl => 'https://openrouter.ai/api/v1/chat/completions';

  @override
  String get providerName => 'openrouter';

  @override
  Map<String, String> get extraHeaders => {
        'HTTP-Referer': 'https://moneymoney.app',
        'X-Title': 'Money Money',
      };
}
