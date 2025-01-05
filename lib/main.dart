import 'package:flutter/material.dart';
import '/auth_service/auth_service.dart';
import 'screens/dashboard.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Study App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<bool> _isLoggedIn() async {
    final authService = AuthService();
    return await authService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool isLoggedIn = snapshot.data ?? false;

        // Navigate based on login state
        if (isLoggedIn) {
          return const Dashboard();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
