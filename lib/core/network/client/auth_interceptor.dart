import 'package:daily_sales_app/core/token_repository.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as dev;

class AuthInterceptor extends Interceptor {
  final TokenRepository _tokenRepository = TokenRepository();

  AuthInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from repository
    final token = await _tokenRepository.getToken();

    // Add token to headers if it exists
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      dev.log(
        '🔐 Token added to request: ${options.path}',
        name: 'AuthInterceptor',
      );
    } else {
      dev.log(
        '⚠️ No token found for request: ${options.path}',
        name: 'AuthInterceptor',
      );
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - Token expired or invalid
    if (err.response?.statusCode == 401) {
      dev.log('❌ 401 Unauthorized - Clearing session', name: 'AuthInterceptor');

      // Clear all tokens and user data
      await _tokenRepository.clearAll();

      // You can navigate to login here or handle in UI
      // NavigationService.clearAndNavigateTo(AppRoutes.login);
    }

    // Pass error to next handler
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log(
      '✅ Response received: ${response.requestOptions.path} - ${response.statusCode}',
      name: 'AuthInterceptor',
    );
    handler.next(response);
  }

  // Helper method to get token
  Future<String?> getToken() => _tokenRepository.getToken();
}

// ============================================

// lib/core/constants/network/dio/logger_interceptor.dart
