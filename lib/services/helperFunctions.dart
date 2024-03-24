import 'package:shared_preferences/shared_preferences.dart';
final String UID_KEY = 'uid_key';

class HelperFunctions{

  static Future<bool> setUserUidToSharedPreference(String uid)async{
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.setString(UID_KEY, uid);
  }

  static Future getUserUidFromSharedPreference()async{
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.getString(UID_KEY);
  }

  static Future clearUserUidFromSharedPreference()async{
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    return await _prefs.remove(UID_KEY);
  }
}