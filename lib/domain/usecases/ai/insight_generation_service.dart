import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/database/app_database.dart';
import '../../../data/remote/llm/llm_client.dart';
import '../../../data/repositories/insight_repository.dart';
import 'financial_context_builder.dart';

/// Generates AI-powered financial insights using an LLM.
///
/// Builds a financial context snapshot, sends it to the configured LLM,
/// and parses the structured JSON response into insight records.
class InsightGenerationService {
  InsightGenerationService({
    required FinancialContextBuilder contextBuilder,
    required InsightRepository insightRepo,
  })  : _contextBuilder = contextBuilder,
        _insightRepo = insightRepo;

  final FinancialContextBuilder _contextBuilder;
  final InsightRepository _insightRepo;

  static const _uuid = Uuid();

  /// Generate insights using the provided LLM client.
  ///
  /// Returns the number of insights generated, or throws on error.
  Future<int> generate(LlmClient llmClient) async {
    final context = await _contextBuilder.build();
    if (context.contains('No accounts set up yet.')) {
      return 0; // No data to analyze
    }

    final messages = [
      const LlmMessage(
        role: 'system',
        content: _systemPrompt,
      ),
      LlmMessage(
        role: 'user',
        content: 'Here is my current financial data:\n\n$context\n\n'
            'Please analyze this data and provide insights.',
      ),
    ];

    // Collect the full streamed response
    final buffer = StringBuffer();
    await for (final chunk in llmClient.sendMessageStream(messages)) {
      buffer.write(chunk);
    }

    final insights = _parseInsights(buffer.toString());
    if (insights.isEmpty) return 0;

    // Clean up old dismissed insights before inserting new ones
    await _insightRepo.deleteExpired();

    await _insightRepo.insertInsights(insights);
    return insights.length;
  }

  List<InsightsCompanion> _parseInsights(String response) {
    // Extract JSON array from response (may be wrapped in markdown code block)
    var jsonStr = response.trim();
    if (jsonStr.contains('```')) {
      final match = RegExp(r'```(?:json)?\s*\n?([\s\S]*?)\n?```').firstMatch(jsonStr);
      if (match != null) {
        jsonStr = match.group(1)!.trim();
      }
    }

    // Try to find a JSON array in the response
    final arrayStart = jsonStr.indexOf('[');
    final arrayEnd = jsonStr.lastIndexOf(']');
    if (arrayStart == -1 || arrayEnd == -1 || arrayEnd <= arrayStart) {
      return [];
    }
    jsonStr = jsonStr.substring(arrayStart, arrayEnd + 1);

    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final now = DateTime.now().millisecondsSinceEpoch;
      // Expire insights after 24 hours
      final expiresAt = now + const Duration(hours: 24).inMilliseconds;

      return list.where((item) {
        if (item is! Map<String, dynamic>) return false;
        return item['title'] != null && item['description'] != null;
      }).map((item) {
        final map = item as Map<String, dynamic>;
        return InsightsCompanion.insert(
          id: _uuid.v4(),
          title: map['title'] as String,
          description: map['description'] as String,
          insightType: _validateInsightType(map['insightType'] as String?),
          severity: _validateSeverity(map['severity'] as String?),
          createdAt: now,
          expiresAt: Value(expiresAt),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  String _validateInsightType(String? type) {
    const valid = {'spending', 'budget', 'goal', 'saving', 'general'};
    return valid.contains(type) ? type! : 'general';
  }

  String _validateSeverity(String? severity) {
    const valid = {'info', 'warning', 'alert'};
    return valid.contains(severity) ? severity! : 'info';
  }

  static const _systemPrompt = '''
You are a personal finance analyst. Analyze the user's financial data and provide actionable insights.

Respond with ONLY a JSON array of insights. Each insight must have these fields:
- "title": Short headline (under 60 characters)
- "description": 1-2 sentence explanation with specific numbers
- "insightType": One of: "spending", "budget", "goal", "saving", "general"
- "severity": One of: "info" (neutral observation), "warning" (needs attention), "alert" (urgent)

Generate 3-5 insights. Focus on:
- Spending patterns and anomalies
- Budget utilization (approaching or exceeding limits)
- Goal progress (on track, behind, or ahead)
- Saving opportunities
- Net worth and income vs expense trends

Example response:
[
  {"title": "Grocery spending up 30%", "description": "You've spent \$450 on groceries this month, up from your usual \$350. Consider reviewing recent purchases.", "insightType": "spending", "severity": "warning"},
  {"title": "Emergency fund on track", "description": "At your current savings rate, you'll reach your \$15,000 goal by August 2026.", "insightType": "goal", "severity": "info"}
]

Important: Respond with ONLY the JSON array. No other text.''';
}
