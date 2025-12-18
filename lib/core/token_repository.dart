// lib/core/services/token_repository.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class TokenRepository {
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';

  /// Save JWT token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    dev.log('✅ JWT token saved', name: 'TokenRepository');
  }

  /// Get JWT token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    dev.log(
      'Token: ${token != null ? "Token exists" : "No token found"}',
      name: 'TokenRepository',
    );
    return token;
  }

  /// Save user info (ID, name, email)
  Future<void> saveUserInfo({
    required String userId,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    dev.log('✅ User info saved (ID: $userId)', name: 'TokenRepository');
  }

  /// Get user ID
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey);
    dev.log(
      'User ID: ${userId ?? "No user ID found"}',
      name: 'TokenRepository',
    );
    return userId;
  }

  /// Get user name
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// Get all user info at once
  Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_userIdKey),
      'name': prefs.getString(_userNameKey),
      'email': prefs.getString(_userEmailKey),
    };
  }

  /// Check if user is logged in (has token)
  Future<bool> hasToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final exists = token != null && token.isNotEmpty;

      dev.log(
        'Token check: ${exists ? "Token exists" : "No token found"}',
        name: 'TokenRepository',
      );
      return exists;
    } catch (e) {
      dev.log('❌ Error checking token: $e', name: 'TokenRepository');
      return false;
    }
  }

  /// Check if user is guest (no token)
  Future<bool> isGuest() async {
    final token = await getToken();
    return token == null || token.isEmpty;
  }

  /// Delete all tokens and user info (Logout)
  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    dev.log('✅ All tokens and user info deleted', name: 'TokenRepository');
  }

  /// Clear all (alias for deleteAll)
  Future<void> clearAll() async {
    try {
      await deleteAll();
      dev.log('✅ Session cleared successfully', name: 'TokenRepository');
    } catch (e) {
      dev.log('❌ Error clearing session: $e', name: 'TokenRepository');
      rethrow;
    }
  }

  /// Delete token only
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    dev.log('✅ Token deleted', name: 'TokenRepository');
  }

  /// Delete user ID only
  Future<void> deleteUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    dev.log('✅ User ID deleted', name: 'TokenRepository');
  }
}

// ============================================

