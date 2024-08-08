import 'package:shared_preferences/shared_preferences.dart';

const _defaultType = 'list';

Future<void> saveInventoryView(String viewType) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('inventory_view', viewType);
}

Future<String?> getInventoryView() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('inventory_view') ?? _defaultType;
}