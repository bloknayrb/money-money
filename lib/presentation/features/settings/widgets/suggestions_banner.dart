import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../domain/usecases/categorize/rule_suggestion_service.dart';
import '../auto_categorize_providers.dart';

/// Banner that surfaces rule suggestions derived from recent corrections.
/// Shown at the top of the rules screen, above the test-a-payee panel.
/// Auto-hides when there are no qualifying suggestions.
class SuggestionsBanner extends ConsumerWidget {
  const SuggestionsBanner({super.key});

  /// Cap visible suggestions so the banner doesn't dominate the screen.
  /// Lower-confidence groups can still be surfaced after the user
  /// acts on (accept/dismiss) the top items, since each action refreshes
  /// the suggestions provider.
  static const int _maxVisible = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsAsync = ref.watch(ruleSuggestionsProvider);
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final categoryNames = <String, String>{};
    categoriesAsync.whenData((cats) {
      for (final c in cats) {
        categoryNames[c.id] = c.name;
      }
    });
    return suggestionsAsync.when(
      // Provider exposes its own error/loading. Loading is a no-op
      // (banner stays hidden until ready), and error is logged but
      // hidden — the banner is a nice-to-have, not core UX.
      loading: () => const SizedBox.shrink(),
      error: (e, _) {
        if (kDebugMode) debugPrint('ruleSuggestionsProvider error: $e');
        return const SizedBox.shrink();
      },
      data: (suggestions) {
        if (suggestions.isEmpty) return const SizedBox.shrink();
        final visible = suggestions.take(_maxVisible).toList();
        final scheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Card(
            margin: EdgeInsets.zero,
            color: scheme.primaryContainer.withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome_outlined,
                          size: 20, color: scheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        suggestions.length == 1
                            ? 'Suggested rule'
                            : 'Suggested rules (${suggestions.length})',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  for (final s in visible)
                    _SuggestionRow(
                      suggestion: s,
                      categoryName:
                          categoryNames[s.suggestedCategoryId] ?? 'Unknown',
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionRow extends ConsumerStatefulWidget {
  const _SuggestionRow({
    required this.suggestion,
    required this.categoryName,
  });

  final SuggestedRule suggestion;
  final String categoryName;

  @override
  ConsumerState<_SuggestionRow> createState() => _SuggestionRowState();
}

class _SuggestionRowState extends ConsumerState<_SuggestionRow> {
  // In-flight guard: prevents double-taps from creating duplicate rules
  // (payeeExact has no unique constraint) or firing two dismissal writes.
  bool _busy = false;

  Future<void> _accept() async {
    if (_busy) return;
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;
    setState(() => _busy = true);
    try {
      await ref
          .read(ruleSuggestionServiceProvider)
          .acceptSuggestion(widget.suggestion);
      // Only refresh on success; failure path leaves the suggestion
      // visible so the user can retry.
      ref.invalidate(ruleSuggestionsProvider);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text(
          'Rule created: ${widget.suggestion.normalizedPayee} → '
          '${widget.categoryName}',
        ),
      ));
    } on Exception catch (e) {
      // Narrow to Exception so Error subclasses (StateError, AssertionError)
      // propagate to FlutterError.onError instead of being swallowed.
      if (kDebugMode) debugPrint('acceptSuggestion failed: $e');
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: const Text("Couldn't create rule"),
        backgroundColor: errorColor,
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _dismiss() async {
    if (_busy) return;
    final messenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;
    setState(() => _busy = true);
    try {
      await ref
          .read(ruleSuggestionServiceProvider)
          .dismissSuggestion(widget.suggestion);
      // Same rationale as _accept: only refresh on success.
      ref.invalidate(ruleSuggestionsProvider);
    } on Exception catch (e) {
      if (kDebugMode) debugPrint('dismissSuggestion failed: $e');
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: const Text("Couldn't dismiss suggestion"),
        backgroundColor: errorColor,
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.suggestion.normalizedPayee,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' → '),
                      TextSpan(text: widget.categoryName),
                    ],
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${widget.suggestion.correctionCount} corrections in the '
                  'last 90 days',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _busy ? null : _accept,
            child: _busy
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create rule'),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Dismiss',
            onPressed: _busy ? null : _dismiss,
          ),
        ],
      ),
    );
  }
}
