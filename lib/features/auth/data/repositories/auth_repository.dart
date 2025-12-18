import 'package:daily_sales_app/core/network/api/endpoints.dart';
import 'package:daily_sales_app/core/network/client/api_client.dart';
import 'package:daily_sales_app/core/network/utils/request_type.dart';
import 'package:daily_sales_app/core/token_repository.dart';
import 'package:daily_sales_app/features/auth/data/models/auth_response.dart';
import 'package:daily_sales_app/features/auth/data/models/user_model.dart';
import 'dart:developer' as dev;

class AuthRepository {
  final ApiClient _dioClient;
  final TokenRepository _tokenRepository;

  AuthRepository(this._dioClient, this._tokenRepository);

  /// Register new user
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      dev.log('📝 Registering user: $email', name: 'AuthRepository');

      final response = await _dioClient.request(
        EndPoints.register,
        requestType: RequestType.post,
        data: {'name': name, 'email': email, 'password': password},
      );

      final data = response.data['data'];
      final authResponse = AuthResponseModel.fromJson(data);

      // Save token and user info
      await _tokenRepository.saveToken(authResponse.token);
      await _tokenRepository.saveUserInfo(
        userId: authResponse.user.id,
        name: authResponse.user.name,
        email: authResponse.user.email,
      );

      dev.log(
        '✅ Registration successful: ${authResponse.user.name}',
        name: 'AuthRepository',
      );

      return authResponse;
    } catch (e) {
      dev.log('❌ Registration failed: $e', name: 'AuthRepository');
      rethrow;
    }
  }

  /// Login user
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      dev.log('🔐 Logging in user: $email', name: 'AuthRepository');

      final response = await _dioClient.request(
        EndPoints.login,
        requestType: RequestType.post,
        data: {'email': email, 'password': password},
      );
    
     
      final data = response.data['data'];
      final authResponse = AuthResponseModel.fromJson(data);

      // Save token and user info
      await _tokenRepository.saveToken(authResponse.token);
      await _tokenRepository.saveUserInfo(
        userId: authResponse.user.id,
        name: authResponse.user.name,
        email: authResponse.user.email,
      );

      dev.log(
        '✅ Login successful: ${authResponse.user.name}',
        name: 'AuthRepository',
      );

      return authResponse;
    } catch (e) {
      dev.log('❌ Login failed: $e', name: 'AuthRepository');
      rethrow;
    }
  }

  /// Get current logged in user
  Future<UserModel> getCurrentUser() async {
    try {
      dev.log('👤 Fetching current user', name: 'AuthRepository');

      final response = await _dioClient.request(
        EndPoints.me,
        requestType: RequestType.get,
      );
      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);

      dev.log('✅ Current user fetched: ${user.name}', name: 'AuthRepository');

      return user;
    } catch (e) {
      dev.log('❌ Failed to fetch current user: $e', name: 'AuthRepository');
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      dev.log('🚪 Logging out user', name: 'AuthRepository');

      await _tokenRepository.clearAll();

      dev.log('✅ Logout successful', name: 'AuthRepository');
    } catch (e) {
      dev.log('❌ Logout failed: $e', name: 'AuthRepository');
      rethrow;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _tokenRepository.hasToken();
  }

  /// Get stored user info
  Future<Map<String, String?>> getUserInfo() async {
    return await _tokenRepository.getUserInfo();
  }
}
