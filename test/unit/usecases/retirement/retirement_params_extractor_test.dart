import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymoney/data/local/database/app_database.dart';
import 'package:moneymoney/data/remote/llm/llm_client.dart';
import 'package:moneymoney/data/repositories/conversation_repository.dart';
import 'package:moneymoney/domain/usecases/retirement/retirement_params_extractor.dart';

class MockConversationRepository extends Mock
    implements ConversationRepository {}

class MockLlmClient extends Mock implements LlmClient {}

void main() {
  late MockConversationRepository mockConvRepo;
  late MockLlmClient mockClient;
  late RetirementParamsExtractor extractor;

  setUp(() {
    mockConvRepo = MockConversationRepository();
    mockClient = MockLlmClient();
    extractor = RetirementParamsExtractor(conversationRepo: mockConvRepo);
  });

  setUpAll(() {
    registerFallbackValue(const ChatMessage(role: 'user', content: ''));
  });

  Message makeMessage(String role, String content) {
    return Message(
      id: 'msg-1',
      conversationId: 'conv-1',
      role: role,
      content: content,
      tokenCount: null,
      createdAt: 1000000,
    );
  }

  group('RetirementParamsExtractor', () {
    test('extracts valid JSON response', () async {
      when(() => mockConvRepo.getMessages('conv-1')).thenAnswer(
        (_) async => [
          makeMessage('user', 'I am 30 years old'),
          makeMessage('assistant', 'Great! When do you want to retire?'),
          makeMessage('user', 'At 65, contributing \$500/month'),
          makeMessage('assistant', 'And your risk tolerance?'),
          makeMessage('user', 'Moderate. I want \$5000/month in retirement'),
        ],
      );

      when(() => mockClient.complete(any(), any())).thenAnswer(
        (_) async => '''
{
  "goalName": "Retirement by 2061",
  "monthlyContributionCents": 50000,
  "annualReturnBps": 450,
  "annualVolatilityBps": 1500,
  "retirementYear": 2061,
  "desiredMonthlyIncomeCents": 500000
}
''',
      );

      final result = await extractor.extract(mockClient, 'conv-1');

      expect(result, isNotNull);
      expect(result!.goalName, 'Retirement by 2061');
      expect(result.monthlyContributionCents, 50000);
      expect(result.annualReturnBps, 450);
      expect(result.annualVolatilityBps, 1500);
      expect(result.retirementYear, 2061);
      expect(result.desiredMonthlyIncomeCents, 500000);
    });

    test('handles JSON wrapped in markdown code block', () async {
      when(() => mockConvRepo.getMessages('conv-1')).thenAnswer(
        (_) async => [makeMessage('user', 'plan my retirement')],
      );

      when(() => mockClient.complete(any(), any())).thenAnswer(
        (_) async => '''
```json
{
  "goalName": "Retirement",
  "monthlyContributionCents": 100000,
  "annualReturnBps": 650,
  "annualVolatilityBps": 2000,
  "retirementYear": 2050,
  "desiredMonthlyIncomeCents": 800000
}
```
''',
      );

      final result = await extractor.extract(mockClient, 'conv-1');

      expect(result, isNotNull);
      expect(result!.monthlyContributionCents, 100000);
      expect(result.annualReturnBps, 650);
    });

    test('returns null for missing required fields', () async {
      when(() => mockConvRepo.getMessages('conv-1')).thenAnswer(
        (_) async => [makeMessage('user', 'test')],
      );

      when(() => mockClient.complete(any(), any())).thenAnswer(
        (_) async => '{"goalName": "Retirement"}',
      );

      final result = await extractor.extract(mockClient, 'conv-1');
      expect(result, isNull);
    });

    test('returns null for malformed JSON', () async {
      when(() => mockConvRepo.getMessages('conv-1')).thenAnswer(
        (_) async => [makeMessage('user', 'test')],
      );

      when(() => mockClient.complete(any(), any())).thenAnswer(
        (_) async => 'This is not JSON at all',
      );

      final result = await extractor.extract(mockClient, 'conv-1');
      expect(result, isNull);
    });

    test('returns null for empty conversation', () async {
      when(() => mockConvRepo.getMessages('conv-1')).thenAnswer(
        (_) async => [],
      );

      final result = await extractor.extract(mockClient, 'conv-1');
      expect(result, isNull);
    });

    test('rejects retirement year in the past', () async {
      when(() => mockConvRepo.getMessages('conv-1')).thenAnswer(
        (_) async => [makeMessage('user', 'test')],
      );

      when(() => mockClient.complete(any(), any())).thenAnswer(
        (_) async => '''
{
  "goalName": "Retirement",
  "monthlyContributionCents": 50000,
  "annualReturnBps": 450,
  "annualVolatilityBps": 1500,
  "retirementYear": 2020,
  "desiredMonthlyIncomeCents": 500000
}
''',
      );

      final result = await extractor.extract(mockClient, 'conv-1');
      expect(result, isNull);
    });

    test('rejects out-of-bounds return rate', () async {
      when(() => mockConvRepo.getMessages('conv-1')).thenAnswer(
        (_) async => [makeMessage('user', 'test')],
      );

      when(() => mockClient.complete(any(), any())).thenAnswer(
        (_) async => '''
{
  "goalName": "Retirement",
  "monthlyContributionCents": 50000,
  "annualReturnBps": 5000,
  "annualVolatilityBps": 1500,
  "retirementYear": 2060,
  "desiredMonthlyIncomeCents": 500000
}
''',
      );

      final result = await extractor.extract(mockClient, 'conv-1');
      expect(result, isNull,
          reason: '50% return is out of 1-12% bounds');
    });

    test('rejects negative contribution', () async {
      when(() => mockConvRepo.getMessages('conv-1')).thenAnswer(
        (_) async => [makeMessage('user', 'test')],
      );

      when(() => mockClient.complete(any(), any())).thenAnswer(
        (_) async => '''
{
  "goalName": "Retirement",
  "monthlyContributionCents": -100,
  "annualReturnBps": 450,
  "annualVolatilityBps": 1500,
  "retirementYear": 2060,
  "desiredMonthlyIncomeCents": 500000
}
''',
      );

      final result = await extractor.extract(mockClient, 'conv-1');
      expect(result, isNull);
    });
  });
}
