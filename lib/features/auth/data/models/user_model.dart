// lib/features/auth/data/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final bool allowed;
  final DateTime lastSeen;
  final bool? online;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.allowed,
    required this.lastSeen,
    this.online,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      allowed: json['allowed'] ?? true,
      lastSeen: DateTime.parse(
        json['lastSeen'] ?? DateTime.now().toIso8601String(),
      ),
      online: json['online'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'allowed': allowed,
      'lastSeen': lastSeen.toIso8601String(),
      'online': online,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    bool? allowed,
    DateTime? lastSeen,
    bool? online,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      allowed: allowed ?? this.allowed,
      lastSeen: lastSeen ?? this.lastSeen,
      online: online ?? this.online,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, allowed: $allowed)';
  }
}
