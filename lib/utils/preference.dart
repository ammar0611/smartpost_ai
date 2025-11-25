import 'package:smartpost_ai/utils/log_utils.dart';
import 'package:smartpost_ai/values/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void setValue(String key, String value) {
    _prefs.setString(key, value);
  }

  static String getValue(String key) {
    return _prefs.getString(key) ?? '';
  }

  // Clear all preferences
  static void clearAllPreferences() {
    _prefs.clear();
  }
}
