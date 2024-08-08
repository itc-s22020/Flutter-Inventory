import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLastUsedFolder(String folderName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_used_folder', folderName);
}

Future<String?> getLastUsedFolder() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('last_used_folder');
}

