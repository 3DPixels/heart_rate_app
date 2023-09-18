import 'package:heart_rate_app/local/shared_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static putString(SharedKeys key, String value) async {
    await sharedPreferences.setString(key.name, value);
  }

  static getString(SharedKeys key) {
    return sharedPreferences.getString(key.name) ?? '';
  }

  static clear() async {
    await sharedPreferences.clear();
  }
}
