// ======================================================
// CHAT BUBBLE
// ======================================================
import 'package:daily_sales_app/features/chat/data/models/message_model.dart'
    show MessageModel;
import 'package:flutter/material.dart';

// ======================================================
// CHAT BUBBLE
// ======================================================
class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ✅ Correct color pairing (prevents invisible text)
    final bgColor = isMe
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;

    final textColor = isMe
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;

    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: alignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Message text
                Text(
                  message.content,
                  style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                ),

                const SizedBox(height: 4),

                // Time + read status
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.isRead ? Icons.done_all : Icons.done,
                        size: 16,
                        color: message.isRead
                            ? textColor.withOpacity(0.9)
                            : textColor.withOpacity(0.7),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // TIME FORMAT
  // ======================================================
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
