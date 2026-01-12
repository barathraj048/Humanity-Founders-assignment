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
    try {
      return UserModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        displayName: json['displayName']?.toString() ??
            json['display_name']?.toString() ??
            '',
        photoURL: json['photoURL']?.toString() ?? json['photo_url']?.toString(),
        role: _parseRole(json['role']),
        bio: json['bio']?.toString(),
        createdAt: _parseDateTime(json['createdAt'] ?? json['created_at']),
      );
    } catch (e) {
      print('❌ Error parsing UserModel from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // For backward compatibility with Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel.fromJson(map);

  // For Firestore compatibility (if needed)
  factory UserModel.fromSnapshot(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(data);
  }

  // Parse role from string or enum
  static UserRole _parseRole(dynamic role) {
    if (role == null) return UserRole.worshiper;

    if (role is UserRole) return role;

    final roleStr = role.toString().toLowerCase();
    if (roleStr == 'leader' || roleStr == 'userrole.leader') {
      return UserRole.leader;
    }
    return UserRole.worshiper;
  }

  // Parse DateTime from various formats
  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();

    if (dateTime is DateTime) return dateTime;

    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        print('⚠️ Error parsing DateTime string: $dateTime');
        return DateTime.now();
      }
    }

    // If it's a timestamp (int or double)
    if (dateTime is int || dateTime is double) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(dateTime.toInt());
      } catch (e) {
        print('⚠️ Error parsing DateTime from timestamp: $dateTime');
        return DateTime.now();
      }
    }

    return DateTime.now();
  }

  // Copy with method for easy updates
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    UserRole? role,
    String? bio,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // String representation for debugging
  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, role: $role)';
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoURL == photoURL &&
        other.role == role &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        displayName.hashCode ^
        photoURL.hashCode ^
        role.hashCode ^
        bio.hashCode;
  }
}
