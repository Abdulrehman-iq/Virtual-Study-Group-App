import 'package:flutter/material.dart';
import '/auth_service/auth_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _checkLoginStatus(BuildContext context) async {
    final authService = AuthService();
    final bool isLoggedIn = await authService.isLoggedIn();

    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn) {
      // If logged in, navigate to the Dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // If not logged in, navigate to the Login screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkLoginStatus(context);

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Virtual Study App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
