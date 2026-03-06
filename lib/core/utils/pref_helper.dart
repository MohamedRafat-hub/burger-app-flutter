import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String tokenKey = 'auth_token';
  static late SharedPreferences _instance;
  static Future<void> init() async
  {
    _instance =await SharedPreferences.getInstance();
  }

  static Future<void> saveToken({required String token}) async
  {
    await _instance.setString(tokenKey, token);
  }

  static String? getToken()
  {
    return _instance.getString(tokenKey);
  }

  static Future<void> removeToken()async
  {
    await _instance.remove(tokenKey);
  }

}


