import 'package:shared_preferences/shared_preferences.dart';

const _defaultType = 'list';

Future<void> saveFolderView(String viewType) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('folder_view', viewType);
}

Future<String?> getFolderView() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('folder_view') ?? _defaultType;
}