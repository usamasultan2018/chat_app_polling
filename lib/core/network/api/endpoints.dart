// lib/core/constants/network/api_constants.dart

class EndPoints {
  // Base URL
  static const String baseUrl = "https://chat-app-backend-green-ten.vercel.app";

  // API Version
  static const String apiVersion = '/api';

  // ========== Auth Endpoints ==========
  static const String register = '$apiVersion/auth/register';
  static const String login = '$apiVersion/auth/login';
  static const String me = '$apiVersion/auth/me';

  // ========== User Endpoints ==========
  static const String users = '$apiVersion/users';

  // Get single user by ID
  static String userById(String userId) {
    return '$apiVersion/users/$userId';
  }

  // Toggle user permission (admin feature)
  static String togglePermission(String userId) {
    return '$apiVersion/users/$userId/permission';
  }

  // ========== Message Endpoints ==========
  static const String messages = '$apiVersion/messages';

  // Get chat history with pagination
  // Example: /api/messages/USER_ID?page=1&limit=50
  static String chatHistory(String userId, {int page = 1, int limit = 50}) {
    return '$apiVersion/messages/$userId?page=$page&limit=$limit';
  }

  // Poll for new messages
  // Example: /api/messages/USER_ID/new?lastMessageId=MESSAGE_ID
  static String pollNewMessages(String userId, {String? lastMessageId}) {
    String endpoint = '$apiVersion/messages/$userId/new';
    if (lastMessageId != null && lastMessageId.isNotEmpty) {
      endpoint += '?lastMessageId=$lastMessageId';
    }
    return endpoint;
  }

  // Mark messages as read
  static String markAsRead(String userId) {
    return '$apiVersion/messages/$userId/read';
  }

  // Get unread message count
  static String unreadCount(String userId) {
    return '$apiVersion/messages/$userId/unread';
  }

  // ========== Timeouts ==========
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Prevent instantiation
  EndPoints._();
}
