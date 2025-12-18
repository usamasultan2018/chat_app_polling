import 'package:daily_sales_app/core/network/client/api_client.dart';
import 'package:daily_sales_app/core/network/erorr/api_exceptions.dart';
import 'package:daily_sales_app/core/network/utils/request_type.dart';
import 'package:daily_sales_app/core/token_repository.dart';
import 'package:daily_sales_app/core/network/api/endpoints.dart';
import '../models/message_model.dart';

class ChatRepository {
  final ApiClient _dioClient;

  ChatRepository(this._dioClient);

  /// Send message - ✅ FIXED: Backend expects 'content' not 'message'
  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    if (message.trim().isEmpty) {
      throw ApiException('Message cannot be empty');
    }

    try {
      await _dioClient.request(
        EndPoints.messages,
        requestType: RequestType.post,
        data: {
          'receiverId': receiverId,
          'content': message.trim(), // ✅ Changed from 'message' to 'content'
        },
      );
    } catch (e) {
      throw ApiException('Failed to send message');
    }
  }

  Future<List<MessageModel>> getChatHistory(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dioClient.request(
        EndPoints.chatHistory(userId),
        requestType: RequestType.get,
        queryParameters: {'page': page, 'limit': limit},
      );

      final List messagesJson = response.data['data']['messages'] ?? [];

      return messagesJson.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      throw ApiException('Failed to load chat history');
    }
  }

  Future<List<MessageModel>> pollNewMessages(
    String userId,
    String? lastMessageId,
  ) async {
    try {
      final response = await _dioClient.request(
        EndPoints.pollNewMessages(userId),
        requestType: RequestType.get,
        queryParameters: lastMessageId == null
            ? null
            : {'lastMessageId': lastMessageId},
      );

      final List messagesJson = response.data['data']['messages'] ?? [];

      return messagesJson.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      throw ApiException('Failed to poll new messages');
    }
  }

  /// Mark messages as read
  Future<void> markAsRead(String userId) async {
    try {
      await _dioClient.request(
        EndPoints.markAsRead(userId),
        requestType: RequestType.patch,
      );
    } catch (_) {
      throw ApiException('Failed to mark messages as read');
    }
  }

  /// Get unread count
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _dioClient.request(
        EndPoints.unreadCount(userId),
        requestType: RequestType.get,
      );

      return response.data['count'] ?? 0;
    } catch (_) {
      throw ApiException('Failed to fetch unread count');
    }
  }
}
