import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../sembast/inventory_service.dart';
import '../ui/custom_snack_bar.dart';

class InventoryController extends GetxController {
  var items = <Map<String, dynamic>>[].obs;
  final InventoryService _inventoryService = InventoryService();

  Future<void> loadItems(String folderName) async {
    try {
      final fetchedItems = await _inventoryService.getItems(folderName);
      items.assignAll(fetchedItems);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading items: $e');
      }
    }
  }
  Future<bool> addItem(String folderName, String name, int stock) async {
    try {
      final existingItems = await _inventoryService.getItems(folderName);
      if (existingItems.any((item) => item['name'] == name)) {
        showSnackBar('Error: $name already exists in $folderName', isError: true);
        return false;
      }
      await _inventoryService.addItem(folderName, name, '', 0, stock);
      await loadItems(folderName);
      showSnackBar('$name added to $folderName');
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item: $e');
      }
      showSnackBar('Error adding item: $e', isError: true);
      return false;
    }
  }

  Future<void> updateItemStock(String folderName, String name, int stock) async {
    try {
      await _inventoryService.updateItemStock(folderName, name, stock);
      loadItems(folderName);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating item stock: $e');
      }
    }
  }

  void showSnackBar(String message, {bool isError = false}) {
    CustomSnackBar.show(
      title: 'Inventory Update',
      message: message,
      isError: isError,
    );
  }
}
