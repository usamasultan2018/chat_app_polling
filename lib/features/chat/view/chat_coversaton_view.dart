import 'package:daily_sales_app/features/chat/view/widgets/chat_blocked_state.dart';
import 'package:daily_sales_app/features/chat/view/widgets/chat_empty_state.dart' show ChatEmptyState;
import 'package:daily_sales_app/features/chat/view/widgets/chat_message_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';
import '../../auth/providers/auth_provider.dart';

class ChatConversationView extends StatefulWidget {
  final String userId;
  final String userName;
  final bool isTargetUserAllowed; // Add this parameter

  const ChatConversationView({
    super.key,
    required this.userId,
    required this.userName,
    required this.isTargetUserAllowed, // Add this
  });

  @override
  State<ChatConversationView> createState() => _ChatConversationViewState();
}

class _ChatConversationViewState extends State<ChatConversationView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      // Only load chat if both users are allowed
      if (user != null && user.allowed && widget.isTargetUserAllowed) {
        context.read<ChatProvider>().loadChat(widget.userId);
      }
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100) {
      context.read<ChatProvider>().loadMoreMessages();
    }
  }

  @override
  void dispose() {
    context.read<ChatProvider>().disposeChat();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(ChatProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    provider.sendMessage(widget.userId, text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final myUserId = user.id;
    final isCurrentUserBlocked = !user.allowed;
    final isTargetUserBlocked = !widget.isTargetUserAllowed;

    return Scaffold(
      appBar: AppBar(title: Text(widget.userName), elevation: 1),
      body: Consumer<ChatProvider>(
        builder: (_, provider, __) {
          if (provider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.errorMessage!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  duration: const Duration(seconds: 3),
                ),
              );
            });
          }

          // Check if either user is blocked
          if (isCurrentUserBlocked || isTargetUserBlocked) {
            return ChatBlockedState(
              controller: _controller,
              message: isCurrentUserBlocked
                  ? 'You do not have permission to use chat features.'
                  : '${widget.userName} is not available for chat.',
            );
          }

          if (provider.isLoading && provider.messages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.messages.isEmpty) {
            return ChatEmptyState(
              controller: _controller,
              isSending: provider.isSending,
              onSend: () => _sendMessage(provider),
            );
          }

          return ChatMessagesList(
            scrollController: _scrollController,
            messages: provider.messages,
            myUserId: myUserId,
            isLoading: provider.isLoading,
            controller: _controller,
            isSending: provider.isSending,
            onSend: () => _sendMessage(provider),
          );
        },
      ),
    );
  }
}
