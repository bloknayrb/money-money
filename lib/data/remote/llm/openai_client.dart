import 'package:dio/dio.dart';

import 'openai_compatible_client.dart';

/// LLM client for OpenAI via the Chat Completions API.
class OpenAiClient extends OpenAiCompatibleClient {
  OpenAiClient({
    required super.apiKey,
    required Dio dio,
    String model = 'gpt-5-mini',
  }) : super(dio: dio, model: model);

  @override
  String get baseUrl => 'https://api.openai.com/v1/chat/completions';

  @override
  String get providerName => 'openai';
}
