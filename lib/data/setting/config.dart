import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static Future<void> setLocal(bool isEnglish,BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isEnglish", isEnglish);
    EasyLocalization.of(context)?.setLocale(isEnglish?Locale('en','US'):Locale('ar','SA'));
    print('rrrrrrrrrrr ${isEnglish} rrrrrrrrrr');
  }

  static Future<void> getLocal(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    EasyLocalization.of(context)?.setLocale(await prefs.getBool("isEnglish")??true?Locale('en','US'):Locale('ar','SA'));
  }
  static  Future<void> setUser(String phone,String password)async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("phone-password", [phone,password]);
  }
  static Future<List<String>?> getUser()async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("phone-password");
  }
  static Future<void> signOutUser()async {
    final prefs = await SharedPreferences.getInstance();
     prefs.remove("phone-password");
  }

}
