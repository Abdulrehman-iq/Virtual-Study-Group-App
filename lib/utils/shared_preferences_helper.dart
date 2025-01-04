import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Singleton pattern
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._privateConstructor();
  static SharedPreferences? _prefs;

  SharedPreferencesHelper._privateConstructor();

  // Access SharedPreferences instance
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Set a value
  Future<void> setString(String key, String value) async {
    final prefs = await this.prefs;
    prefs.setString(key, value);
  }

  // Get a value
  Future<String?> getString(String key) async {
    final prefs = await this.prefs;
    return prefs.getString(key);
  }

  // Set a boolean value
  Future<void> setBool(String key, bool value) async {
    final prefs = await this.prefs;
    prefs.setBool(key, value);
  }

  // Get a boolean value
  Future<bool?> getBool(String key) async {
    final prefs = await this.prefs;
    return prefs.getBool(key);
  }

  // Add more methods as needed (e.g., setInt, getInt, remove, etc.)
}
