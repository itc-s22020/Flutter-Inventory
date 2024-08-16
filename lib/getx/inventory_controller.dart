import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inventory/sembast/inventory_service.dart';
import 'package:inventory/ui/custom_snack_bar.dart';

class InventoryController extends GetxController {
  final items = <RxMap<String, dynamic>>[].obs;
  final InventoryService _inventoryService = InventoryService();
  final Map<String, Timer> _debounceTimers = {};

  Future<void> loadItems(String folderName) async {
    try {
      final fetchedItems = await _inventoryService.getItems(folderName);
      items.assignAll(fetchedItems.map((item) => RxMap<String, dynamic>.from(item)));
    } catch (e) {
      if (kDebugMode) {
        print('Error loading items: $e');
      }
    }
  }

  Future<bool> addItem(String folderName, String name, int stock, Uint8List? image) async {
    try {
      final existingItems = await _inventoryService.getItems(folderName);
      if (existingItems.any((item) => item['name'] == name)) {
        showSnackBar('Error: $name already exists in $folderName', isError: true);
        return false;
      }
      await _inventoryService.addItem(folderName, name, image, 0, stock);
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

  void updateItemStockLocally(String name, int stock) {
    final index = items.indexWhere((item) => item['name'] == name);
    if (index != -1) {
      items[index]['stock'] = stock;
    }
  }

  Future<void> updateItemStock(String folderName, String name, int stock) async {
    updateItemStockLocally(name, stock);

    if (_debounceTimers.containsKey(name)) {
      _debounceTimers[name]!.cancel();
    }

    _debounceTimers[name] = Timer(const Duration(milliseconds: 500), () async {
      try {
        await _inventoryService.updateItemStock(folderName, name, stock);
      } catch (e) {
        if (kDebugMode) {
          print('Error updating item stock: $e');
        }
        loadItems(folderName);
      }
    });
  }

  void showSnackBar(String message, {bool isError = false}) {
    CustomSnackBar.show(
      title: 'Inventory Update',
      message: message,
      isError: isError,
    );
  }
}