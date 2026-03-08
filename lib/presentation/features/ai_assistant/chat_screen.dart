import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/error/app_error.dart';
import '../../../data/local/database/app_database.dart';
import '../../shared/utils/snackbar_helpers.dart';
import 'ai_assistant_providers.dart';

/// Full-screen chat view for a single conversation.
class ChatScreen extends ConsumerStatefulWidget {
  final String? conversationId;

  const ChatScreen({super.key, this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  String? _conversationId;

  @override
  void initState() {
    super.initState();
    _conversationId = widget.conversationId;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGenerating = ref.watch(isGeneratingProvider);
    final streamingText = ref.watch(streamingMessageProvider);

    return Scaffold(
      appBar: AppBar(
        title: _conversationId != null
            ? _ConversationTitle(conversationId: _conversationId!)
            : const Text('New Chat'),
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: _conversationId != null
                ? _MessageList(
                    conversationId: _conversationId!,
                    streamingText: streamingText,
                    scrollController: _scrollController,
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.smart_toy_outlined,
                            size: 48,
                            color: theme.colorScheme.primary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ask me about your finances',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'I can help with budgeting, spending analysis, '
                            'goal tracking, and more.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),

          // Input bar
          _ChatInputBar(
            controller: _controller,
            isGenerating: isGenerating,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final llmClient = ref.read(llmClientProvider).valueOrNull;
    if (llmClient == null) {
      showErrorSnackbar(context, 'No LLM provider configured. Set one up in Settings.');
      return;
    }

    _controller.clear();
    ref.read(isGeneratingProvider.notifier).state = true;
    ref.read(streamingMessageProvider.notifier).state = '';

    try {
      final chatService = ref.read(aiChatServiceProvider);
      final providerName = await ref.read(secureStorageProvider).getActiveLlmProvider() ?? 'claude';
      final model = _defaultModel(providerName);

      final (convId, stream) = await chatService.sendMessage(
        conversationId: _conversationId,
        userMessage: text,
        llmClient: llmClient,
        provider: providerName,
        model: model,
      );

      if (_conversationId == null) {
        setState(() => _conversationId = convId);
      }

      // Accumulate streaming chunks
      final buffer = StringBuffer();
      await for (final chunk in stream) {
        buffer.write(chunk);
        ref.read(streamingMessageProvider.notifier).state = buffer.toString();
        _scrollToBottom();
      }
    } on LLMError catch (e) {
      if (mounted) showErrorSnackbar(context, e.userMessage);
    } catch (e) {
      if (mounted) showErrorSnackbar(context, 'Failed to get response: $e');
    } finally {
      if (mounted) {
        ref.read(streamingMessageProvider.notifier).state = null;
        ref.read(isGeneratingProvider.notifier).state = false;
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  String _defaultModel(String provider) => switch (provider) {
        'claude' => 'claude-sonnet-4-20250514',
        'openai' => 'gpt-4o',
        'ollama' => 'llama3.2',
        _ => 'claude-sonnet-4-20250514',
      };
}

// =============================================================================
// Sub-widgets
// =============================================================================

class _ConversationTitle extends ConsumerWidget {
  final String conversationId;

  const _ConversationTitle({required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider(conversationId));
    return messagesAsync.when(
      data: (messages) {
        final firstUser = messages.where((m) => m.role == 'user').firstOrNull;
        if (firstUser == null) return const Text('Chat');
        final title = firstUser.content.length > 30
            ? '${firstUser.content.substring(0, 27)}...'
            : firstUser.content;
        return Text(title, overflow: TextOverflow.ellipsis);
      },
      loading: () => const Text('Chat'),
      error: (err, st) => const Text('Chat'),
    );
  }
}

class _MessageList extends ConsumerWidget {
  final String conversationId;
  final String? streamingText;
  final ScrollController scrollController;

  const _MessageList({
    required this.conversationId,
    required this.streamingText,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider(conversationId));

    return messagesAsync.when(
      data: (messages) {
        // Filter out the empty placeholder assistant message if streaming
        final displayMessages = streamingText != null
            ? messages.where((m) => !(m.role == 'assistant' && m.content.isEmpty)).toList()
            : messages.where((m) => m.content.isNotEmpty).toList();

        final itemCount = displayMessages.length + (streamingText != null ? 1 : 0);

        if (itemCount == 0) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index < displayMessages.length) {
              return _MessageBubble(message: displayMessages[index]);
            }
            // Streaming bubble
            return _StreamingBubble(text: streamingText!);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading messages: $e')),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return _BubbleLayout(isUser: isUser, content: message.content);
  }
}

class _StreamingBubble extends StatelessWidget {
  final String text;

  const _StreamingBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return _BubbleLayout(
      isUser: false,
      content: text.isEmpty ? null : text,
      isStreaming: true,
    );
  }
}

class _BubbleLayout extends StatelessWidget {
  final bool isUser;
  final String? content;
  final bool isStreaming;

  const _BubbleLayout({
    required this.isUser,
    this.content,
    this.isStreaming = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),
        child: content != null && content!.isNotEmpty
            ? isUser
                ? Text(
                    content!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  )
                : MarkdownBody(
                    data: content!,
                    styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      code: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        backgroundColor: colorScheme.surfaceContainerLow,
                      ),
                    ),
                    shrinkWrap: true,
                  )
            : SizedBox(
                width: 32,
                height: 16,
                child: _TypingIndicator(color: colorScheme.onSurfaceVariant),
              ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  final Color color;

  const _TypingIndicator({required this.color});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final t = (_controller.value - delay).clamp(0.0, 1.0);
            final opacity = (t < 0.5 ? t * 2 : 2 - t * 2).clamp(0.3, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: opacity,
                child: CircleAvatar(
                  radius: 3,
                  backgroundColor: widget.color,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isGenerating;
  final VoidCallback onSend;

  const _ChatInputBar({
    required this.controller,
    required this.isGenerating,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Ask about your finances...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              enabled: !isGenerating,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: isGenerating ? null : onSend,
            icon: isGenerating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
