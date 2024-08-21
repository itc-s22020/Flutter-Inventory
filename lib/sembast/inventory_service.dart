import 'dart:typed_data';
import 'package:sembast/sembast.dart';
import 'database_service.dart';

class InventoryService {
  final _db = DatabaseService().db;
  final _store = stringMapStoreFactory.store('inventory');

  Future<void> addFolder(String folder, int iconIndex) async {
    final record = _store.record(folder);
    await _db.transaction((txn) async {
      final snapshot = await record.get(txn);
      if (snapshot == null) {
        await record.put(txn, {
          'folder': folder,
          'iconIndex': iconIndex,
          'items': [],
        });
      }
    });
  }

  Future<Map<String, dynamic>> addItem(String folder, String name, Uint8List? image, int iconIndex, int stock) async {
    final record = _store.record(folder);
    final newItem = {
      'name': name,
      'image': image ?? '',
      'stock': stock,
    };

    await _db.transaction((txn) async {
      final snapshot = await record.get(txn);
      if (snapshot == null) {
        await record.put(txn, {
          'folder': folder,
          'iconIndex': iconIndex,
          'items': [newItem],
        });
      } else {
        final value = snapshot as Map<String, dynamic>;
        final currentItems = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final updatedItems = List<Map<String, dynamic>>.from(currentItems)..add(newItem);
        await record.update(txn, {
          'items': updatedItems,
        });
      }
    });

    return newItem;
  }

  Future<List<Map<String, dynamic>>> getItems(String folder) async {
    final record = _store.record(folder);
    final snapshot = await record.get(_db);
    if (snapshot == null) {
      return [];
    } else {
      final value = snapshot as Map<String, dynamic>;
      final items = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      return items;
    }
  }

  Future<void> renameItem(String folder, String oldName, String newName) async {
    final record = _store.record(folder);
    await _db.transaction((txn) async {
      final snapshot = await record.get(txn);
      if (snapshot != null) {
        final value = snapshot as Map<String, dynamic>;
        final currentItems = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final updatedItems = currentItems.map((item) {
          if (item['name'] == oldName) {
            return {...item, 'name': newName};
          }
          return item;
        }).toList();

        await record.update(txn, {
          'items': updatedItems,
        });
      }
    });
  }

  Future<void> updateItemStock(String folder, String itemName, int newStock) async {
    final record = _store.record(folder);
    await _db.transaction((txn) async {
      final snapshot = await record.get(txn);
      if (snapshot != null) {
        final value = snapshot as Map<String, dynamic>;
        final currentItems = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final updatedItems = currentItems.map((item) {
          if (item['name'] == itemName) {
            return {...item, 'stock': newStock};
          }
          return item;
        }).toList();

        await record.update(txn, {
          'items': updatedItems,
        });
      }
    });
  }

  Future<void> deleteItem(String folder, String itemName) async {
    final record = _store.record(folder);
    await _db.transaction((txn) async {
      final snapshot = await record.get(txn);
      if (snapshot != null) {
        final value = snapshot as Map<String, dynamic>;
        final currentItems = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final updatedItems = currentItems.where((item) => item['name'] != itemName).toList();

        await record.update(txn, {
          'items': updatedItems,
        });
      }
    });
  }

  Future<void> updateItemImage(String folder, String itemName, Uint8List newImage) async {
    final record = _store.record(folder);
    await _db.transaction((txn) async {
      final snapshot = await record.get(txn);
      if (snapshot != null) {
        final value = snapshot as Map<String, dynamic>;
        final currentItems = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final updatedItems = currentItems.map((item) {
          if (item['name'] == itemName) {
            return {...item, 'image': newImage};
          }
          return item;
        }).toList();

        await record.update(txn, {
          'items': updatedItems,
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> getAllFolder() async {
    final snapshots = await _store.find(_db);
    return snapshots.map((snapshot) {
      final value = snapshot.value as Map<String, dynamic>;
      return {
        'name': value['folder'] as String,
        'iconIndex': value['iconIndex'] as int,
      };
    }).toList();
  }

  Future<void> renameFolder(String oldName, String newName) async {
    await _db.transaction((txn) async {
      final oldRecord = _store.record(oldName);
      final newRecord = _store.record(newName);

      final oldData = await oldRecord.get(txn);
      if (oldData != null) {
        await newRecord.put(txn, {
          ...oldData as Map<String, dynamic>,
          'folder': newName,
        });
        await oldRecord.delete(txn);
      }
    });
  }

  Future<void> deleteFolder(String folder) async {
    final record = _store.record(folder);
    await record.delete(_db);
  }
}
