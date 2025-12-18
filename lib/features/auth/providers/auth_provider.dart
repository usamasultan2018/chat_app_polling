import 'package:daily_sales_app/core/network/erorr/api_exceptions.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  AuthState _state = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  // Getters
  AuthState get state => _state;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;
  bool get hasError => _state == AuthState.error;

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setState(AuthState.loading);
    _errorMessage = null;

    try {
      dev.log('📝 Attempting registration for: $email', name: 'AuthProvider');

      final result = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );

      _currentUser = result.user;
      _setState(AuthState.authenticated);

      dev.log('✅ Registration successful', name: 'AuthProvider');

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setState(AuthState.error);
      dev.log('❌ Bad request: ${e.message}', name: 'AuthProvider');
      return false;
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      _setState(AuthState.error);
      dev.log('❌ Unknown error: $e', name: 'AuthProvider');
      return false;
    }
  }

  /// Login user
  Future<bool> login({required String email, required String password}) async {
    _setState(AuthState.loading);
    _errorMessage = null;

    try {
      dev.log('🔐 Attempting login for: $email', name: 'AuthProvider');

      final result = await _authRepository.login(
        email: email,
        password: password,
      );

      _currentUser = result.user;
      _setState(AuthState.authenticated);

      dev.log('✅ Login successful', name: 'AuthProvider');

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setState(AuthState.error);
      dev.log('❌ Unauthorized: ${e.message}', name: 'AuthProvider');
      return false;
    } catch (e) {
      _errorMessage = 'Login failed. Please try again.';
      _setState(AuthState.error);
      dev.log('❌ Unknown error: $e', name: 'AuthProvider');
      return false;
    }
  }

  /// Get current user
  Future<void> getCurrentUser() async {
    try {
      dev.log('👤 Fetching current user', name: 'AuthProvider');

      _currentUser = await _authRepository.getCurrentUser();
      _setState(AuthState.authenticated);

      dev.log('✅ Current user fetched', name: 'AuthProvider');
    } catch (e) {
      dev.log('❌ Failed to fetch current user: $e', name: 'AuthProvider');
      await logout();
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      dev.log('🚪 Logging out', name: 'AuthProvider');

      await _authRepository.logout();
      _currentUser = null;
      _errorMessage = null;
      _setState(AuthState.unauthenticated);

      dev.log('✅ Logout successful', name: 'AuthProvider');
    } catch (e) {
      dev.log('❌ Logout error: $e', name: 'AuthProvider');
    }
  }

  /// Check if user is logged in
  Future<bool> checkAuthStatus() async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        await getCurrentUser();
        return true;
      } else {
        _setState(AuthState.unauthenticated);
        return false;
      }
    } catch (e) {
      _setState(AuthState.unauthenticated);
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _setState(AuthState.initial);
    }
  }

  /// Set state and notify listeners
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }
}
