import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:inventory/page/home.dart';

void main() {
  runApp(const GetMaterialApp(
    title: "Inventory",
    home: HomePage(),
    initialRoute: "/",
  ));
}