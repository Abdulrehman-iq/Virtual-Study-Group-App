// screens/splash_screen.dart
import 'package:flutter/material.dart';
import '/auth_service/auth_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _checkLoginStatus(BuildContext context) async {
    final authService = AuthService();
    final bool isLoggedIn = await authService.isLoggedIn();

    if (isLoggedIn) {
      // Navigate to the Dashboard if logged in
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // Navigate to the Login screen if not logged in
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Delay for a few seconds to show the splash screen before navigating
    Future.delayed(const Duration(seconds: 3), () {
      _checkLoginStatus(context);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Virtual Study App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
