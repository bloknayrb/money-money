import 'dart:convert';

import '../../../data/remote/llm/llm_client.dart';
import 'context_builder.dart';

/// A single budget suggestion from the LLM.
class BudgetSuggestion {
  final String categoryName;
  final String? categoryId;
  final int amountCents;
  final String periodType; // 'monthly' or 'annual'
  final String rationale;

  const BudgetSuggestion({
    required this.categoryName,
    this.categoryId,
    required this.amountCents,
    required this.periodType,
    required this.rationale,
  });
}

/// Generates AI-powered budget suggestions based on spending history.
///
/// Follows the [InsightGenerationService] pattern: one-shot LLM call,
/// JSON parse with markdown code block extraction.
class BudgetSuggestionService {
  BudgetSuggestionService({
    required ContextBuilder contextBuilder,
  }) : _contextBuilder = contextBuilder;

  final ContextBuilder _contextBuilder;

  /// Generate budget suggestions using the provided LLM client.
  Future<List<BudgetSuggestion>> suggest(LlmClient llmClient) async {
    final context = await _contextBuilder.buildContext();
    if (context.contains('No accounts set up yet.')) {
      return [];
    }

    final response = await llmClient.complete(
      _systemPrompt,
      [
        ChatMessage(
          role: 'user',
          content: 'Here is my current financial data:\n\n$context\n\n'
              'Please suggest budgets based on my spending patterns.',
        ),
      ],
    );

    return _parseSuggestions(response);
  }

  List<BudgetSuggestion> _parseSuggestions(String response) {
    var jsonStr = response.trim();
    if (jsonStr.contains('```')) {
      final match =
          RegExp(r'```(?:json)?\s*\n?([\s\S]*?)\n?```').firstMatch(jsonStr);
      if (match != null) {
        jsonStr = match.group(1)!.trim();
      }
    }

    final arrayStart = jsonStr.indexOf('[');
    final arrayEnd = jsonStr.lastIndexOf(']');
    if (arrayStart == -1 || arrayEnd == -1 || arrayEnd <= arrayStart) {
      return [];
    }
    jsonStr = jsonStr.substring(arrayStart, arrayEnd + 1);

    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.where((item) {
        if (item is! Map<String, dynamic>) return false;
        return item['categoryName'] != null && item['amountCents'] != null;
      }).map((item) {
        final map = item as Map<String, dynamic>;
        return BudgetSuggestion(
          categoryName: map['categoryName'] as String,
          categoryId: map['categoryId'] as String?,
          amountCents: (map['amountCents'] as num).toInt(),
          periodType: (map['periodType'] as String?) ?? 'monthly',
          rationale: (map['rationale'] as String?) ?? '',
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  static const _systemPrompt = '''
You are a personal finance budget advisor. Analyze the user's spending data and suggest reasonable monthly budgets.

Respond with ONLY a JSON array. Each suggestion must have:
- "categoryName": The category name (must match existing categories in the data)
- "categoryId": The category ID if available from the data
- "amountCents": Suggested monthly budget in cents (e.g. 50000 = \$500.00)
- "periodType": "monthly"
- "rationale": 1 sentence explaining why this amount

Guidelines:
- Suggest 3-6 budgets for the highest spending categories
- Set amounts slightly above actual average spending (10-20% buffer)
- Focus on categories where budgeting would be most impactful
- Use whole dollar amounts (round to nearest 100 cents)

Example response:
[
  {"categoryName": "Groceries", "categoryId": "abc-123", "amountCents": 60000, "periodType": "monthly", "rationale": "You've averaged \$520/month on groceries; this gives a 15% buffer."},
  {"categoryName": "Dining Out", "categoryId": "def-456", "amountCents": 25000, "periodType": "monthly", "rationale": "Your restaurant spending averages \$210/month and is trending up."}
]

Important: Respond with ONLY the JSON array. No other text.''';
}
