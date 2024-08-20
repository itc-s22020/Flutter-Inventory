import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLanguage(String language) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', language);
}

Future<String> getLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  String? language = prefs.getString('language');
  if (language == null) {
    final locale = Get.deviceLocale?.languageCode;
    if (locale != 'ja') {
      return 'English';
    } else {
      return 'Japanese';
    }
  }
  return language;
}

Future<void> saveSnackBarOnlyError(String theme) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('snackBarOnlyError', theme);
}

Future<String> getSnackBarOnlyError() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('snackBarOnlyError') ?? 'off';
}
