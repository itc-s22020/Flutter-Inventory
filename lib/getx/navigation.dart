import 'package:get/get.dart';
import 'package:inventory/page/add_inventory.dart';
import 'package:inventory/page/home.dart';
import 'package:inventory/page/inventory.dart';
import 'package:inventory/page/folder.dart';

void toHome() => Get.to(() => const HomePage());
void toAddInventory() => Get.to(() => const AddInventoryPage());
void toInventory() => Get.to(() => const InventoryPage());
void toFolder() => Get.to(() => FolderPage());
void toBack() => Get.back();