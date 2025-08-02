import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {

  static late SharedPreferences preferences;

  static Future startDb() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveUserName(String username) async {
    return await preferences.setString('username', username);
  }

  static Future isLogin(bool islogin) async {
    await preferences.setBool('islogin', islogin);
  }

  static Future clear() async{
    await preferences.clear();
  }

  static String? getUserName(){
    return preferences.getString('username');
  }

  static bool? getIsLogin(){
    return preferences.getBool('islogin');
  }


  Future setData(String key, dynamic value) async {
    if (value is String) {
      return await preferences.setString(key, value);
    }
    if (value is int) {
      return await preferences.setInt(key, value);
    }
    if (value is bool) {
      return await preferences.setBool(key, value);
    }
  }

  dynamic getData ({required String key}) async{
    return await preferences.get(key);
  }

}