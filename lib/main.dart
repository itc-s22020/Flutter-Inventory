import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:inventory/page/home.dart';
import 'package:inventory/sembast/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().init();

  runApp(const GetMaterialApp(
    title: "Inventory",
    home: HomePage(),
    initialRoute: "/",
  ));
}