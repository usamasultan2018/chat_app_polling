import 'dart:async';
import 'package:flutter/material.dart';
import '../data/repository/chat_repository.dart';
import '../data/models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository;

  ChatProvider(this._repository);

  // =====================
  // State
  // =====================
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;
  String? _currentChatUserId;
  Timer? _pollingTimer;
  String? _lastMessageId;
  int _currentPage = 1;
  bool _hasMoreMessages = true;

  // =====================
  // Getters
  // =====================
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;
  bool get hasMoreMessages => _hasMoreMessages;

  // =====================
  // Polling Configuration
  // =====================
  static const Duration _pollingInterval = Duration(seconds: 3);

  // =====================
  // Load Chat & Start Polling
  // =====================
  Future<void> loadChat(String userId) async {
    _currentChatUserId = userId;
    _currentPage = 1;
    _hasMoreMessages = true;
    _lastMessageId = null;

    // Load initial messages
    await _fetchInitialMessages(userId);

    // Mark messages as read
    await _markMessagesAsRead(userId);

    // Start polling for new messages
    _startPolling(userId);
  }

  // =====================
  // Fetch Initial Messages (with pagination)
  // =====================
  Future<void> _fetchInitialMessages(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final messageList = await _repository.getChatHistory(
        userId,
        page: _currentPage,
        limit: 20,
      );

      _messages = messageList;

      // Store last message ID for polling
      if (_messages.isNotEmpty) {
        _lastMessageId = _messages.last.id;
      }

      // Check if there are more messages
      _hasMoreMessages = messageList.length >= 20;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =====================
  // Load More Messages (Pagination)
  // =====================
  Future<void> loadMoreMessages() async {
    if (!_hasMoreMessages || _isLoading || _currentChatUserId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _currentPage++;
      final olderMessages = await _repository.getChatHistory(
        _currentChatUserId!,
        page: _currentPage,
        limit: 20,
      );

      _hasMoreMessages = olderMessages.length >= 20;

      // Add older messages at the beginning
      _messages.insertAll(0, olderMessages);
    } catch (e) {
      _errorMessage = e.toString();
      _currentPage--;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =====================
  // Start Polling (Fetch Only New Messages)
  // =====================
  void _startPolling(String userId) {
    // Cancel any existing timer
    _pollingTimer?.cancel();

    // Start new polling timer
    _pollingTimer = Timer.periodic(_pollingInterval, (_) async {
      await _pollNewMessages(userId);
    });
  }

  // =====================
  // Poll for New Messages Only
  // =====================
  Future<void> _pollNewMessages(String userId) async {
    if (_currentChatUserId != userId) return;

    try {
      // Fetch only messages after the last known message ID
      final newMessages = await _repository.pollNewMessages(
        userId,
        _lastMessageId,
      );

      if (newMessages.isNotEmpty) {
        // ✅ Check for duplicates before adding
        for (final newMsg in newMessages) {
          final isDuplicate = _messages.any((msg) => msg.id == newMsg.id);
          if (!isDuplicate) {
            _messages.add(newMsg);
          }
        }

        // Update last message ID
        _lastMessageId = newMessages.last.id;

        // Mark new messages as read
        await _markMessagesAsRead(userId);

        notifyListeners();
      }
    } catch (e) {
      // Silent fail for polling
      debugPrint('Polling error: $e');
    }
  }

  // =====================
  // Send Message
  // =====================
  Future<void> sendMessage(String receiverId, String text) async {
    if (text.trim().isEmpty) return;

    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.sendMessage(receiverId: receiverId, message: text);

      // ✅ Wait a moment before polling to ensure backend has processed
      await Future.delayed(const Duration(milliseconds: 500));

      // Poll immediately after sending to get the new message
      await _pollNewMessages(receiverId);
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Send message error: $e');
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  // =====================
  // Mark Messages as Read
  // =====================
  Future<void> _markMessagesAsRead(String userId) async {
    try {
      await _repository.markAsRead(userId);

      // Update local state - mark all messages from this user as read
      bool hasUnread = false;
      for (var message in _messages) {
        if (message.senderId == userId && !message.isRead) {
          message.isRead = true;
          hasUnread = true;
        }
      }

      if (hasUnread) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Mark as read error: $e');
    }
  }

  // =====================
  // Dispose Chat & Stop Polling
  // =====================
  void disposeChat() {
    // ✅ CRITICAL: Stop polling when screen is inactive
    _pollingTimer?.cancel();
    _pollingTimer = null;

    _messages = [];
    _currentChatUserId = null;
    _lastMessageId = null;
    _currentPage = 1;
    _hasMoreMessages = true;
    _errorMessage = null;

    notifyListeners();
  }

  // =====================
  // Clear All Data (Logout)
  // =====================
  void clear() {
    disposeChat();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
