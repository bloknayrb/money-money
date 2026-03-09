import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/local/database/app_database.dart';
import '../../../domain/usecases/ai/budget_suggestion_service.dart';
import 'budgets_providers.dart';

/// Screen showing AI-generated budget suggestions.
class AiBudgetSuggestionScreen extends ConsumerStatefulWidget {
  const AiBudgetSuggestionScreen({super.key});

  @override
  ConsumerState<AiBudgetSuggestionScreen> createState() =>
      _AiBudgetSuggestionScreenState();
}

class _AiBudgetSuggestionScreenState
    extends ConsumerState<AiBudgetSuggestionScreen> {
  List<BudgetSuggestion>? _suggestions;
  bool _isLoading = false;
  String? _error;
  final _accepted = <int>{};

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final client = ref.read(activeLlmClientProvider).valueOrNull;
    if (client == null) {
      setState(() => _error = 'No AI provider configured');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = ref.read(budgetSuggestionServiceProvider);
      final suggestions = await service.suggest(client);
      if (mounted) {
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to generate suggestions: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _acceptSuggestion(int index) async {
    final suggestion = _suggestions![index];
    if (suggestion.categoryId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot create budget: no category ID')),
        );
      }
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final budgetRepo = ref.read(budgetRepositoryProvider);

    await budgetRepo.insertBudget(BudgetsCompanion.insert(
      id: const Uuid().v4(),
      categoryId: suggestion.categoryId!,
      amountCents: suggestion.amountCents,
      periodType: suggestion.periodType,
      startDate: now,
      createdAt: now,
      updatedAt: now,
    ));

    setState(() => _accepted.add(index));
    ref.invalidate(budgetsWithSpentProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Created ${suggestion.categoryName} budget: ${suggestion.amountCents.toCurrency()}/mo',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finance = theme.finance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Budget Suggestions'),
      ),
      body: _buildBody(theme, finance),
    );
  }

  Widget _buildBody(ThemeData theme, FinanceColors finance) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing your spending patterns...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadSuggestions,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_suggestions == null || _suggestions!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No budget suggestions available. Add more transactions to get personalized suggestions.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _suggestions!.length,
      itemBuilder: (context, index) {
        final s = _suggestions![index];
        final isAccepted = _accepted.contains(index);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        s.categoryName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${s.amountCents.toCurrency()}/mo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: finance.budgetOnTrack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  s.rationale,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                if (isAccepted)
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: finance.budgetOnTrack, size: 20),
                      const SizedBox(width: 8),
                      Text('Budget created',
                          style: TextStyle(color: finance.budgetOnTrack)),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          // Dismiss by removing from list
                          setState(() => _suggestions!.removeAt(index));
                        },
                        child: const Text('Dismiss'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => _acceptSuggestion(index),
                        child: const Text('Accept'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
