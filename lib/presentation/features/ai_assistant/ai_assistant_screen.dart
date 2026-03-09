import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/router/app_router.dart';
import '../../shared/empty_states/empty_state_widget.dart';
import '../../shared/widgets/delete_confirmation_dialog.dart' show showDeleteConfirmation;
import 'ai_assistant_providers.dart';

/// Conversation list — the AI tab root screen.
///
/// Shows an empty state when no LLM is configured, a "Start a Conversation"
/// empty state when configured but no chats exist, and a scrollable list
/// of past conversations otherwise.
class AiAssistantScreen extends ConsumerWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientAsync = ref.watch(activeLlmClientProvider);
    final conversationsAsync = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          clientAsync.whenOrNull(
                data: (client) => client != null
                    ? IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'New conversation',
                        onPressed: () => _startNewConversation(context, ref),
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: clientAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _noProviderEmptyState(context),
        data: (client) {
          if (client == null) return _noProviderEmptyState(context);

          return conversationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: Text('Failed to load conversations')),
            data: (conversations) {
              if (conversations.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.chat_bubble_outline,
                  title: 'Start a Conversation',
                  description:
                      'Ask your AI assistant anything about your finances.',
                  actionLabel: 'New Chat',
                  actionIcon: Icons.add,
                  onAction: () => _startNewConversation(context, ref),
                );
              }

              return ListView.builder(
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  return Dismissible(
                    key: ValueKey(conv.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Theme.of(context).colorScheme.error,
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete,
                          color: Theme.of(context).colorScheme.onError),
                    ),
                    confirmDismiss: (_) async {
                      return showDeleteConfirmation(
                        context,
                        itemName: conv.title ?? 'this conversation',
                      );
                    },
                    onDismissed: (_) {
                      ref
                          .read(conversationRepositoryProvider)
                          .deleteConversation(conv.id);
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(_providerIcon(conv.provider)),
                      ),
                      title:
                          Text(conv.title ?? 'New conversation'),
                      subtitle: Text(
                        conv.model,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Text(
                        _relativeDate(
                            DateTime.fromMillisecondsSinceEpoch(conv.updatedAt)),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onTap: () => context.push(
                          '${AppRoutes.aiChat}/${conv.id}'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _noProviderEmptyState(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.smart_toy,
      title: 'Set Up AI Assistant',
      description:
          'Configure an LLM provider to get personalized financial insights.',
      actionLabel: 'Configure',
      actionIcon: Icons.settings,
      onAction: () => context.push(AppRoutes.llmSettings),
    );
  }

  Future<void> _startNewConversation(
      BuildContext context, WidgetRef ref) async {
    final clientAsync = ref.read(activeLlmClientProvider);
    final client = clientAsync.valueOrNull;
    if (client == null) return;

    final conversationId = await ref
        .read(conversationRepositoryProvider)
        .createConversation(client.providerName, client.modelName);

    if (context.mounted) {
      context.push('${AppRoutes.aiChat}/$conversationId');
    }
  }

  IconData _providerIcon(String provider) {
    switch (provider) {
      case 'gemini':
        return Icons.auto_awesome;
      case 'claude':
        return Icons.psychology;
      case 'openai':
        return Icons.chat;
      default:
        return Icons.computer;
    }
  }

  String _relativeDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.month}/${dt.day}';
  }
}
