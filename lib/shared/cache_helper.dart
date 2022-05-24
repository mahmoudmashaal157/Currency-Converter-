import 'package:shared_preferences/shared_preferences.dart';

class Cache_Helper {
  static late SharedPreferences sharedPreferences;

  static sharedPrefernceInstance()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static saveListInCache(String key , List<String>value)async{
       sharedPreferences.setStringList(key, value);
  }

  static getListFromCache({required String key}){
    return sharedPreferences.getStringList(key);
  }

}