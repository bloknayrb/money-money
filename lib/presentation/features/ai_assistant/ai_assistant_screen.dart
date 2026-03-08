import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/extensions/money_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../data/local/database/app_database.dart';
import '../../shared/empty_states/empty_state_widget.dart';
import '../../shared/widgets/delete_confirmation_dialog.dart';
import 'ai_assistant_providers.dart';

/// AI Assistant tab — shows conversation list with FAB to start new chat.
class AiAssistantScreen extends ConsumerWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final llmAsync = ref.watch(llmClientProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      floatingActionButton: llmAsync.valueOrNull != null
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.aiChat),
              icon: const Icon(Icons.chat),
              label: const Text('New Chat'),
            )
          : null,
      body: llmAsync.when(
        data: (client) {
          if (client == null) {
            return _buildConfigurePrompt(context);
          }
          return conversationsAsync.when(
            data: (conversations) {
              if (conversations.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.smart_toy,
                  title: 'No Conversations',
                  description:
                      'Start a conversation with your AI financial assistant.',
                  actionLabel: 'New Chat',
                  onAction: () => context.push(AppRoutes.aiChat),
                );
              }
              return _ConversationList(conversations: conversations);
            },
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => _buildConfigurePrompt(context),
      ),
    );
  }

  Widget _buildConfigurePrompt(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.smart_toy,
      title: 'Set Up AI Assistant',
      description:
          'Configure an LLM provider in Settings to start using the AI assistant.',
      actionLabel: 'Configure LLM',
      onAction: () => context.push(AppRoutes.llmConfig),
    );
  }
}

class _ConversationList extends ConsumerWidget {
  final List<Conversation> conversations;

  const _ConversationList({required this.conversations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conv = conversations[index];
        return _ConversationTile(conversation: conv);
      },
    );
  }
}

class _ConversationTile extends ConsumerWidget {
  final Conversation conversation;

  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final title = conversation.title ?? 'Untitled';
    final updatedAt = conversation.updatedAt.toDateTime();
    final providerIcon = switch (conversation.provider) {
      'claude' => Icons.auto_awesome,
      'openai' => Icons.psychology,
      'ollama' => Icons.computer,
      _ => Icons.smart_toy,
    };

    return Dismissible(
      key: ValueKey(conversation.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showDeleteConfirmation(
        context,
        itemName: 'conversation',
        message: 'Delete this conversation? All messages will be lost.',
      ),
      onDismissed: (_) {
        ref.read(conversationRepositoryProvider).deleteConversation(conversation.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: theme.colorScheme.error,
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      child: ListTile(
        leading: Icon(providerIcon, color: theme.colorScheme.primary),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          updatedAt.toRelative(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(
          '${AppRoutes.aiChat}?conversationId=${conversation.id}',
        ),
      ),
    );
  }
}
