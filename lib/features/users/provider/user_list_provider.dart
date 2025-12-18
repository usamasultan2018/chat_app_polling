import 'package:daily_sales_app/features/users/data/repository/user_list_repository.dart';
import 'package:flutter/material.dart';
import '../data/models/user_list_model.dart';

class UserListProvider extends ChangeNotifier {
  final UserListRepository _repository;

  UserListProvider(this._repository);

  // =====================
  // State
  // =====================
  List<UserListModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  // =====================
  // Getters
  // =====================
  List<UserListModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // =====================
  // Helpers
  // =====================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // =====================
  // Actions
  // =====================

  /// Fetch all users
  Future<void> fetchUsers() async {
    _setLoading(true);
    _setError(null);

    try {
      _users = await _repository.getAllUsers();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh users (pull-to-refresh)
  Future<void> refreshUsers() async {
    await fetchUsers();
  }

  /// Toggle user permission (admin)
  Future<void> toggleUserPermission(String userId) async {
    try {
      final updatedUser = await _repository.toggleUserPermission(userId);

      final index = _users.indexWhere((u) => u.id == updatedUser.id);
      if (index != -1) {
        _users[index] = updatedUser;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Clear state (logout)
  void clear() {
    _users = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
