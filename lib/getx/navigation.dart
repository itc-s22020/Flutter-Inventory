import 'package:get/get.dart';
import 'package:inventory/page/add_inventory.dart';
import 'package:inventory/page/home.dart';

void toHome() => Get.offAll(() => const HomePage(initialIndex: 0));
void toAddInventory() => Get.to(() => const AddInventoryPage());
void toInventory() => Get.offAll(() => const HomePage(initialIndex: 1), transition: Transition.noTransition,duration: const Duration(milliseconds: 200));
void toFolder() => Get.offAll(() => const HomePage(initialIndex: 0), transition: Transition.cupertino,duration: const Duration(milliseconds: 200));
void toBack() => Get.back();