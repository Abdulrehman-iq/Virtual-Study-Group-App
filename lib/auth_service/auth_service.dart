import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  // Signup method
  Future<bool> signup(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(_usernameKey) != null) {
      // User already exists
      return false;
    }

    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
    return true;
  }

  // Login method
  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final storedUsername = prefs.getString(_usernameKey);
    final storedPassword = prefs.getString(_passwordKey);

    if (storedUsername == username && storedPassword == password) {
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    }

    return false;
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Logout method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }
}
