import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

/// Renders a single chat message as a styled bubble.
///
/// User messages are right-aligned with primary color.
/// Assistant messages are left-aligned with markdown rendering.
class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.role,
    required this.content,
    this.isStreaming = false,
  });

  final String role;
  final String content;
  /// When true, shows a LinearProgressIndicator below the bubble.
  final bool isStreaming;

  bool get _isUser => role == 'user';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: _isUser ? 64 : 12,
        right: _isUser ? 12 : 64,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment:
            _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _isUser
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: _isUser
                ? Text(
                    content,
                    style: TextStyle(color: colorScheme.onPrimary),
                  )
                : MarkdownBody(
                    data: content,
                    onTapLink: (text, href, title) {
                      if (href == null) return;
                      // Only allow https:// links — prevents tel:, sms: injection
                      if (!href.startsWith('https://')) return;
                      launchUrl(Uri.parse(href),
                          mode: LaunchMode.externalApplication);
                    },
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(color: colorScheme.onSurface),
                      code: TextStyle(
                        backgroundColor: colorScheme.surface,
                        color: colorScheme.onSurface,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
          ),
          if (isStreaming) ...[
            const SizedBox(height: 4),
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ],
      ),
    );
  }
}
