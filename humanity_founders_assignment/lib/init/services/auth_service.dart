// lib/init/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'mongodb_service.dart';

// Export UserRole for easy imports
export '../models/user_model.dart' show UserRole;

// Global instance that can be imported
final AuthService authService = AuthService();

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final MongoDBService _mongoDBService = MongoDBService();

  User? get currentUser => firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  // Get user data from MongoDB
  Future<UserModel?> getUserData(String uid) async {
    try {
      final userData = await _mongoDBService.getUser(uid);
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting user data: $e');
      }
      return null;
    }
  }

  // Get user role
  Future<UserRole?> getUserRole(String uid) async {
    final userData = await getUserData(uid);
    return userData?.role;
  }

  // Sign in
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Create user with role
  Future<UserCredential> createUser({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    // Create auth user
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update display name
    await credential.user!.updateDisplayName(displayName);

    // Save user data to MongoDB
    final userModel = UserModel(
      id: credential.user!.uid,
      email: email,
      displayName: displayName,
      role: role,
      createdAt: DateTime.now(),
    );

    await _mongoDBService.createUser(userModel.toJson());

    return credential;
  }

  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    return await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String displayName}) async {
    await currentUser!.updateDisplayName(displayName);

    // Also update in MongoDB
    if (currentUser != null) {
      await _mongoDBService.updateUser(
        currentUser!.uid,
        {'displayName': displayName},
      );
    }
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);

    // Delete auth user
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
}
