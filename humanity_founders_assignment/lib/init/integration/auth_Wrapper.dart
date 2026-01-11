import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/worshiper/home.dart';
import '../screens/leader/dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0E0E0E),
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        // User not logged in
        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }

        // User logged in - check role
        return FutureBuilder<UserRole?>(
          future: authService.getUserRole(snapshot.data!.uid),
          builder: (context, roleSnapshot) {
            // Loading role
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Color(0xFF0E0E0E),
                body: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }

            // Role not found - sign out and show login
            if (!roleSnapshot.hasData || roleSnapshot.data == null) {
              authService.signOut();
              return const LoginScreen();
            }

            // Route based on role
            final role = roleSnapshot.data!;
            if (role == UserRole.leader) {
              return const LeaderDashboard();
            } else {
              return const WorshiperHome();
            }
          },
        );
      },
    );
  }
}
