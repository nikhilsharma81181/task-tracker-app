import 'package:shared_preferences/shared_preferences.dart';

class SavedSettings {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserToken(String token) async {
    await _preferences!.setString('userToken', token);
  }

  static String? getUserToken() => _preferences!.getString('userToken');

  static Future setUserId(String uid) async {
    await _preferences!.setString('userId', uid);
  }

  static String? getUserId() => _preferences!.getString('userId');

  static Future setUserName(String name) async {
    await _preferences!.setString('userName', name);
  }

  static String? getUserName() => _preferences!.getString('userName');

  static Future setUserEmail(String email) async {
    await _preferences!.setString('userEmail', email);
  }

  static String? getUserEmail() => _preferences!.getString('userEmail');
}
