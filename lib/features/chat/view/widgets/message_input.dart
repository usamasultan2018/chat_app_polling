// ======================================================
// MESSAGE INPUT
// ======================================================
import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isBlocked;
  final bool isSending;
  final VoidCallback onSend;

  const MessageInput({
    super.key,
    required this.controller,
    required this.isBlocked,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: !isBlocked,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: isBlocked || isSending ? null : (_) => onSend(),
                decoration: InputDecoration(
                  hintText: isBlocked
                      ? 'You are blocked from chat'
                      : 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: isBlocked
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.surface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: (isBlocked || isSending)
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: isBlocked || isSending ? null : onSend,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: isSending
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.send,
                          color: (isBlocked || isSending)
                              ? theme.colorScheme.onSurface.withOpacity(0.5)
                              : theme.colorScheme.onPrimary,
                          size: 22,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
