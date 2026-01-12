// lib/init/integration/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/mongodb_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/leader/dashboard.dart';
import '../screens/worshiper/home.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final mongoDBService = MongoDBService();
  bool _isCheckingConnection = true;
  String? _connectionError;

  @override
  void initState() {
    super.initState();
    _checkMongoDBConnection();
  }

  Future<void> _checkMongoDBConnection() async {
    try {
      if (!mongoDBService.isConnected) {
        await mongoDBService.connect();
      }

      if (mounted) {
        setState(() {
          _connectionError = null;
          _isCheckingConnection = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _connectionError = e.toString();
          _isCheckingConnection = false;
        });
      }
    }
  }

  Future<void> _retryConnection() async {
    setState(() {
      _isCheckingConnection = true;
      _connectionError = null;
    });
    await _checkMongoDBConnection();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingConnection) {
      return const Scaffold(
        backgroundColor: Color(0xFF0E0E0E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.purple),
              SizedBox(height: 20),
              Text(
                'Connecting to database...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    if (_connectionError != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0E0E0E),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 20),
                const Text(
                  'Database Connection Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _connectionError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _retryConnection,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Connection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0E0E0E),
            body: Center(
              child: CircularProgressIndicator(color: Colors.purple),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<Map<String, dynamic>?>(
            future: mongoDBService.getUser(snapshot.data!.uid),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Color(0xFF0E0E0E),
                  body: Center(
                    child: CircularProgressIndicator(color: Colors.purple),
                  ),
                );
              }

              if (userSnapshot.hasError) {
                FirebaseAuth.instance.signOut();
                return const LoginScreen();
              }

              final userData = userSnapshot.data;

              if (userData == null) {
                FirebaseAuth.instance.signOut();
                return const LoginScreen();
              }

              final role = userData['role'] as String?;

              // Route to appropriate screen based on role
              if (role == 'leader') {
                return DashboardScreen();
              } else {
                return HomeScreen();
              }
            },
          );
        }

        return const LoginScreen();
      },
    );
  }
}
