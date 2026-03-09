import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/error/app_error.dart';
import '../../../core/router/app_router.dart';
import 'ai_assistant_providers.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_message_bubble.dart';

/// Full-screen chat view for a single conversation.
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _scrollController = ScrollController();
  int _prevMessageCount = 0;

  @override
  void initState() {
    super.initState();
    // Show financial disclaimer on first open (once per screen instance)
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowDisclaimer());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeShowDisclaimer() {
    // Disclaimer is shown when messages list is empty (new conversation)
    final messages =
        ref.read(messagesProvider(widget.conversationId)).valueOrNull ?? [];
    if (messages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'AI responses are for informational purposes only, not professional financial advice.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final clientAsync = ref.read(activeLlmClientProvider);
    final client = clientAsync.valueOrNull;
    if (client == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No AI provider configured.'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => context.push(AppRoutes.llmSettings),
            ),
          ),
        );
      }
      return;
    }

    ref.read(isStreamingProvider.notifier).state = true;
    ref.read(streamingTextProvider.notifier).state = '';

    final chatService = ref.read(chatServiceProvider);

    try {
      await for (final chunk in chatService.sendMessage(
        client: client,
        conversationId: widget.conversationId,
        userMessage: text,
      )) {
        ref.read(streamingTextProvider.notifier).state += chunk;
        _scrollToBottom();
      }
      // Stream complete — the ChatService finally block already saved the DB message.
      // Wait for messagesProvider to reflect the new assistant message, then clear state.
      // (ref.listen in build() handles this transition)
    } on LLMError catch (e) {
      if (!mounted) return;
      final message = e.message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: message.contains('key') || message.contains('provider')
              ? SnackBarAction(
                  label: 'Fix in Settings',
                  onPressed: () => context.push(AppRoutes.llmSettings),
                )
              : null,
        ),
      );
      // Clear streaming state on error (message was partially saved by finally)
      ref.read(isStreamingProvider.notifier).state = false;
      ref.read(streamingTextProvider.notifier).state = '';
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      ref.read(isStreamingProvider.notifier).state = false;
      ref.read(streamingTextProvider.notifier).state = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.conversationId));
    final isStreaming = ref.watch(isStreamingProvider);
    final streamingText = ref.watch(streamingTextProvider);

    // Clear streaming state once the DB message arrives
    ref.listen(messagesProvider(widget.conversationId), (prev, next) {
      final prevCount = prev?.valueOrNull?.length ?? 0;
      final nextMessages = next.valueOrNull ?? [];
      if (isStreaming &&
          nextMessages.length > prevCount &&
          nextMessages.isNotEmpty &&
          nextMessages.last.role == 'assistant') {
        ref.read(isStreamingProvider.notifier).state = false;
        ref.read(streamingTextProvider.notifier).state = '';
      }
    });

    // Auto-scroll when messages arrive
    final messageCount = messagesAsync.valueOrNull?.length ?? 0;
    if (messageCount > _prevMessageCount) {
      _prevMessageCount = messageCount;
      _scrollToBottom();
    }

    return Scaffold(
      appBar: AppBar(
        title: messagesAsync.when(
          loading: () => const Text('Chat'),
          error: (_, _) => const Text('Chat'),
          data: (msgs) {
            final conversations = ref.read(conversationsProvider).valueOrNull;
            final conv = conversations?.where((c) => c.id == widget.conversationId).firstOrNull;
            return Text(conv?.title ?? 'New Chat');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, _) =>
                  const Center(child: Text('Failed to load messages')),
              data: (messages) {
                final itemCount =
                    messages.length + (isStreaming ? 1 : 0);

                if (itemCount == 0) {
                  return const Center(
                    child: Text(
                      'Ask anything about your finances',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // Streaming bubble is always last
                    if (isStreaming && index == messages.length) {
                      return ChatMessageBubble(
                        role: 'assistant',
                        content: streamingText.isEmpty
                            ? '…'
                            : streamingText,
                        isStreaming: true,
                      );
                    }
                    final msg = messages[index];
                    return ChatMessageBubble(
                      role: msg.role,
                      content: msg.content,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          ChatInputBar(
            isStreaming: isStreaming,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
