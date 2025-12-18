class UserListModel {
  final String id;
  final String name;
  final String email;
  final bool allowed;
  final bool online;
  final DateTime createdAt;
  final DateTime? lastSeen;

  UserListModel({
    required this.id,
    required this.name,
    required this.email,
    required this.allowed,
    required this.online,
    required this.createdAt,
    this.lastSeen,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      allowed: json['allowed'] ?? false,
      online: json['online'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'])
          : null,
    );
  }
}
