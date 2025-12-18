import 'package:flutter/material.dart';

class ChatBlockedState extends StatelessWidget {
  final TextEditingController controller;
  final String? message;

  const ChatBlockedState({super.key, required this.controller, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(Icons.block, size: 64, color: colorScheme.onSurfaceVariant),

            const SizedBox(height: 16),

            // Title
            Text(
              'Chat Unavailable',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // Message
            Text(
              message ?? 'This conversation is not accessible.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
