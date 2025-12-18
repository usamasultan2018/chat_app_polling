// ======================================================
// CHAT MESSAGES LIST
// ======================================================
import 'package:daily_sales_app/features/chat/data/models/message_model.dart';
import 'package:daily_sales_app/features/chat/view/widgets/chat_bubble.dart';
import 'package:daily_sales_app/features/chat/view/widgets/date_separator.dart';
import 'package:daily_sales_app/features/chat/view/widgets/message_input.dart';
import 'package:flutter/material.dart';

class ChatMessagesList extends StatelessWidget {
  final ScrollController scrollController;
  final List<MessageModel> messages;
  final String myUserId;
  final bool isLoading;
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const ChatMessagesList({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.myUserId,
    required this.isLoading,
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading && messages.isNotEmpty)
          const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            itemCount: messages.length,
            itemBuilder: (_, index) {
              final message = messages[index];
              final isMe = message.isMe(myUserId);
              final showDateSeparator = _shouldShowDateSeparator(index);

              return Column(
                children: [
                  if (showDateSeparator) DateSeparator(date: message.createdAt),
                  ChatBubble(message: message, isMe: isMe),
                ],
              );
            },
          ),
        ),
        MessageInput(
          controller: controller,
          isBlocked: false,
          isSending: isSending,
          onSend: onSend,
        ),
      ],
    );
  }

  bool _shouldShowDateSeparator(int index) {
    if (index == 0) return true;

    final current = messages[index].createdAt;
    final previous = messages[index - 1].createdAt;

    return current.year != previous.year ||
        current.month != previous.month ||
        current.day != previous.day;
  }
}
