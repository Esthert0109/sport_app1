import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static List<String> searchHistory = [];

  static Future<String?> getSavedToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveTokenLocally(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> savePasswordLocally(String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  static Future<String?> getPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  static Future<void> removeTokenLocally() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<void> saveUsername(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }

  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  static Future<void> saveContactNumber(String phone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('contactNumber', phone);
  }

  static Future<String?> getContactNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('contactNumber');
  }

  static Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveSearchHistory(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory.add(search);
    await prefs.setStringList('search', searchHistory);
  }

  static Future<List<String>?> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('search');
  }

  static Future<void> clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('search');

    searchHistory.clear();
  }
}
