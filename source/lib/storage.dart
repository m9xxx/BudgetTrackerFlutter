import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static Future<void> saveData(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      print('Error saving data: $e');
      // Handle error, e.g., display error message to user
    }
  }

  static Future<String?> loadData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print('Error loading data: $e');
      // Handle error, e.g., return default value or display error message
      return null;
    }
  }

  static Future<void> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

