// lib/init/models/user_model.dart

// Define UserRole enum
enum UserRole { worshiper, leader }

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final UserRole role;
  final String? bio;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.role,
    this.bio,
    required this.createdAt,
  });

  // Convert to JSON for MongoDB
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'role': role == UserRole.leader ? 'leader' : 'worshiper',
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // For backward compatibility with Firestore
  Map<String, dynamic> toMap() => toJson();

  // Create from JSON (MongoDB)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? '',
      photoURL: json['photoURL'],
      role: _parseRole(json['role']),
      bio: json['bio'],
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt']
          : DateTime.parse(
              json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // For backward compatibility with Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel.fromJson(map);

  // For Firestore compatibility (if needed)
  factory UserModel.fromSnapshot(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  // Parse role from string
  static UserRole _parseRole(dynamic role) {
    if (role == 'leader' || role == UserRole.leader) {
      return UserRole.leader;
    }
    return UserRole.worshiper;
  }
}
