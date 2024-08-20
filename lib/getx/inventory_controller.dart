import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

import '../generated/l10n.dart';
import '../sembast/inventory_service.dart';
import '../ui/custom_snack_bar.dart';

class InventoryController extends GetxController {
  final items = <RxMap<String, dynamic>>[].obs;
  final InventoryService _inventoryService = InventoryService();
  final Map<String, Timer> _debounceTimers = {};
  final Map<String, List<RxMap<String, dynamic>>> _itemCache = {};

  Future<void> loadItems(String folderName) async {
    try {
      final fetchedItems = await _inventoryService.getItems(folderName);
      items.assignAll(
          fetchedItems.map((item) => RxMap<String, dynamic>.from(item)));
    } catch (e) {
      if (kDebugMode) {
        print('Error loading items: $e');
      }
    }
  }

  void updateItemStockLocally(String name, int stock) {
    final index = items.indexWhere((item) => item['name'] == name);
    if (index != -1) {
      items[index]['stock'] = stock;
    }
  }

  Future<void> updateItem(String folderName, Map<String, dynamic> oldItem,
      Map<String, dynamic> newItem, BuildContext context) async {
    try {
      if (oldItem['name'] != newItem['name']) {
        await renameItem(folderName, oldItem['name'] as String,
            newItem['name'] as String, context);
      }

      await updateItemStock(
          folderName, newItem['name'] as String, newItem['stock'] as int);

      if (newItem['image'] != null && newItem['image'] != oldItem['image']) {
        if (!context.mounted) return;
        await updateItemImage(folderName, newItem['name'] as String,
            Uint8List.fromList(newItem['image'] as List<int>), context);
      }

      final index = items.indexWhere((item) => item['name'] == oldItem['name']);
      if (index != -1) {
        items[index].assignAll(newItem);
      }

      update();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating item: $e');
      }
      if (!context.mounted) return;
      showSnackBar(S.of(context).errorUpdateItem(e), context, isError: true);
    }
  }

  Future<void> updateItemStock(
      String folderName, String name, int stock) async {
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

  Future<bool> renameItem(String folderName, String oldName, String newName,
      BuildContext context) async {
    try {
      await _inventoryService.renameItem(folderName, oldName, newName);

      final index = items.indexWhere((item) => item['name'] == oldName);
      if (index != -1) {
        items[index]['name'] = newName;
      }

      if (_itemCache.containsKey(folderName)) {
        final cacheIndex = _itemCache[folderName]!
            .indexWhere((item) => item['name'] == oldName);
        if (cacheIndex != -1) {
          _itemCache[folderName]![cacheIndex]['name'] = newName;
        }
      }
      if (!context.mounted) return false;
      showSnackBar(S.of(context).successRenameItem(oldName, newName), context);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error renaming item: $e');
      }
      showSnackBar(S.of(context).errorItemRename(e), context, isError: true);
      return false;
    }
  }

  Future<bool> updateItemImage(String folderName, String name,
      Uint8List newImage, BuildContext context) async {
    try {
      Uint8List? optimizedImage = await compute(optimizeImage, newImage);

      if (optimizedImage != null) {
        await _inventoryService.updateItemImage(
            folderName, name, optimizedImage);

        final index = items.indexWhere((item) => item['name'] == name);
        if (index != -1) {
          items[index]['image'] = optimizedImage;
        }

        if (_itemCache.containsKey(folderName)) {
          final cacheIndex = _itemCache[folderName]!
              .indexWhere((item) => item['name'] == name);
          if (cacheIndex != -1) {
            _itemCache[folderName]![cacheIndex]['image'] = optimizedImage;
          }
        }

        if (!context.mounted) return false;
        showSnackBar(S.of(context).successImageChange(name), context);
        return true;
      } else {
        if (!context.mounted) return false;
        showSnackBar(S.of(context).errorImageOptimizing, context,
            isError: true);
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating item image: $e');
      }
      showSnackBar(S.of(context).errorUpdateImage(e), context, isError: true);
      return false;
    }
  }

  Future<bool> deleteItem(
      String folderName, String name, BuildContext context) async {
    try {
      await _inventoryService.deleteItem(folderName, name);

      items.removeWhere((item) => item['name'] == name);

      if (_itemCache.containsKey(folderName)) {
        _itemCache[folderName]!.removeWhere((item) => item['name'] == name);
      }

      if (!context.mounted) return false;
      showSnackBar(S.of(context).successDeleteItem(name, folderName), context);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting item: $e');
      }
      showSnackBar(S.of(context).errorDeleteItem(e), context, isError: true);
      return false;
    }
  }

  static Uint8List? optimizeImage(Uint8List originalImage) {
    img.Image? image = img.decodeImage(originalImage);
    if (image == null) return null;

    int maxDimension = 300;
    if (image.width > maxDimension || image.height > maxDimension) {
      image = img.copyResize(
        image,
        width: image.width > image.height ? maxDimension : null,
        height: image.height >= image.width ? maxDimension : null,
      );
    }

    return Uint8List.fromList(img.encodePng(image));
  }

  Future<bool> addItem(String folderName, String name, int stock,
      Uint8List? image, BuildContext context) async {
    try {
      final existingItems = _itemCache[folderName] ??
          await _inventoryService.getItems(folderName);
      if (existingItems.any((item) => item['name'] == name)) {
        if (!context.mounted) return false;
        showSnackBar(
            S.of(context).errorDuplicationItem(name, folderName), context,
            isError: true);
        return false;
      }

      Uint8List? optimizedImage;
      if (image != null) {
        optimizedImage = await compute(optimizeImage, image);
      }

      final newItem = await _inventoryService.addItem(
          folderName, name, optimizedImage, 0, stock);
      if (_itemCache.containsKey(folderName)) {
        _itemCache[folderName]!.add(RxMap<String, dynamic>.from(newItem));
      } else {
        _itemCache[folderName] = [RxMap<String, dynamic>.from(newItem)];
      }

      items.add(RxMap<String, dynamic>.from(newItem));

      if (!context.mounted) return false;
      showSnackBar(S.of(context).successMakeItem(name, folderName), context);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding item: $e');
      }
      showSnackBar(S.of(context).errorItem(e), context, isError: true);
      return false;
    }
  }

  Future<void> optimizeExistingImages(
      String folderName, BuildContext context) async {
    try {
      final items = await _inventoryService.getItems(folderName);
      for (var item in items) {
        if (item['image'] != null && item['image'].isNotEmpty) {
          Uint8List? optimizedImage =
              optimizeImage(Uint8List.fromList(List<int>.from(item['image'])));
          if (optimizedImage != null) {
            await _inventoryService.updateItemImage(
                folderName, item['name'], optimizedImage);
          }
        }
      }
      await loadItems(folderName);
    } catch (e) {
      if (kDebugMode) {
        print('Error optimizing existing images: $e');
      }
      if (!context.mounted) return;
      showSnackBar(S.of(context).errorImageOptimizing, context, isError: true);
    }
  }

  void showSnackBar(String message, BuildContext context,
      {bool isError = false}) {
    CustomSnackBar.show(
      title: isError ? S.of(context).error : S.of(context).success,
      message: message,
      isError: isError,
    );
  }
}
