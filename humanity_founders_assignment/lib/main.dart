import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'init/services/mongodb_service.dart';
import 'init/integration/auth_wrapper.dart';

final mongoDBService = MongoDBService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (for Auth only)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }

  // Initialize MongoDB
  try {
    await mongoDBService.connect();
    print('✅ MongoDB initialized successfully');
  } catch (e) {
    print('❌ MongoDB initialization failed: $e');
    // App can still run with limited functionality
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaithConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E0E0E),
        colorScheme: ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.purple.shade300,
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
