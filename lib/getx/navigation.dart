import 'package:get/get.dart';
import 'package:inventory/page/add_inventory.dart';
import 'package:inventory/page/home.dart';
import 'package:inventory/page/inventory.dart';
import 'package:inventory/page/make_folder.dart';

void toHome() => Get.offAll(() => const HomePage());
void toAddInventory() => Get.to(() => const AddInventoryPage());
void toInventory() => Get.to(() => const InventoryPage());
void toMakeFolder() => Get.to(() => const MakeFolderPage());
void toBack() => Get.back();