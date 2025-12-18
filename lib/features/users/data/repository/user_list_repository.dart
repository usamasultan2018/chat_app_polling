// ==========================================
// 2. USER REPOSITORY
// File: lib/features/users/data/repositories/user_list_repository.dart
// ==========================================

import 'package:daily_sales_app/core/network/api/endpoints.dart';
import 'package:daily_sales_app/core/network/client/api_client.dart';
import 'package:daily_sales_app/core/network/erorr/api_exceptions.dart';
import 'package:daily_sales_app/core/network/utils/request_type.dart';
import 'package:daily_sales_app/core/token_repository.dart';
import '../models/user_list_model.dart';

class UserListRepository {
  final ApiClient _dioClient;
  final TokenRepository _tokenRepository;

  UserListRepository(this._dioClient, this._tokenRepository);

  /// Get all users
  Future<List<UserListModel>> getAllUsers() async {
    try {
      final response = await _dioClient.request(
        EndPoints.users,
        requestType: RequestType.get,
      );

      final usersJson = response.data['data']?['users'] as List?;
      if (usersJson == null) return [];

      return usersJson.map((json) => UserListModel.fromJson(json)).toList();
    } catch (e) {
      throw ApiException('Failed to fetch users');
    }
  }

  /// Get single user by ID
  Future<UserListModel> getUserById(String userId) async {
    try {
      final token = await _tokenRepository.getToken();
      if (token == null) throw ApiException('Not authenticated');

      final response = await _dioClient.request(
        EndPoints.userById(userId),
        requestType: RequestType.get,
      );

      final user = response.data['user'];
      if (user == null) throw ApiException('User not found');

      return UserListModel.fromJson(user);
    } catch (e) {
      throw ApiException('Failed to fetch user');
    }
  }

  /// Toggle user permission (admin)
  Future<UserListModel> toggleUserPermission(String userId) async {
    try {
      final token = await _tokenRepository.getToken();
      if (token == null) throw ApiException('Not authenticated');

      final response = await _dioClient.request(
        EndPoints.togglePermission(userId),
        requestType: RequestType.patch,
      );

      final user = response.data['user'];
      if (user == null) throw ApiException('Failed to update permission');

      return UserListModel.fromJson(user);
    } catch (e) {
      throw ApiException('Failed to update permission');
    }
  }
}
