import 'package:shared_preferences/shared_preferences.dart';

class FetchDB {
  // Fetch the value associated with the key
  static Future<String?> fetchdb(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);  // Return the value as String or null if not found
    print('Fetching value for key "$key": $value');  // Log the fetched value
    return value;
  }

  // Set the value for a specific key
  static Future<void> setdb(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);  // Set the value for the key
    print('Setting value for key "$key": $value');  // Log the saved value
  }
}
