import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLanguage(String language) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', language);
}

Future<String> getLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('language') ?? 'English';
}

Future<void> saveSnackBarTheme(String theme) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('snackBarTheme', theme);
}

Future<String> getSnackBarTheme() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('snackBarTheme') ?? 'simpleModern';
}

Future<void> saveSnackBarOnlyError(String theme) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('snackBarOnlyError', theme);
}

Future<String> getSnackBarOnlyError() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('snackBarOnlyError') ?? 'off';
}


