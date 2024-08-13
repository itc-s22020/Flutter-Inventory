import 'package:sembast/sembast.dart';
import 'database_service.dart';

class InventoryService {
  final _db = DatabaseService().db;
  final _store = stringMapStoreFactory.store('inventory');

  Future<void> addCategory(String category, int iconIndex) async {
    final record = _store.record(category);
    await _db.transaction((txn) async {
      final snapshot = await record.get(txn);
      if (snapshot == null) {
        await record.put(txn, {
          'category': category,
          'iconIndex': iconIndex,
          'items': [],
        });
      }
    });
  }

  Future<void> addItem(String category, String name, String image, int iconIndex, int stock) async {
    final record = _store.record(category);
    await _db.transaction((txn) async {
      final snapshot = await record.get(txn);
      if (snapshot == null) {
        await record.put(txn, {
          'category': category,
          'iconIndex': iconIndex,
          'items': [
            {
              'name': name,
              'image': image,
              'stock': stock,
            }
          ],
        });
      } else {
        final value = snapshot as Map<String, dynamic>;
        final currentItems = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final updatedItems = List<Map<String, dynamic>>.from(currentItems)
          ..add({
            'name': name,
            'image': image,
            'stock': stock,
          });
        await record.update(txn, {
          'items': updatedItems,
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> getItems(String category) async {
    final record = _store.record(category);
    final snapshot = await record.get(_db);
    if (snapshot == null) {
      return [];
    } else {
      final value = snapshot as Map<String, dynamic>;
      final items = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      return items;
    }
  }

  Future<void> updateItemStock(String category, String itemName, int newStock) async {
    final record = _store.record(category);
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

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final snapshots = await _store.find(_db);
    return snapshots.map((snapshot) {
      final value = snapshot.value as Map<String, dynamic>;
      return {
        'name': value['category'] as String,
        'iconIndex': value['iconIndex'] as int,
      };
    }).toList();
  }

  Future<void> renameCategory(String oldName, String newName) async {
    await _db.transaction((txn) async {
      final oldRecord = _store.record(oldName);
      final newRecord = _store.record(newName);

      final oldData = await oldRecord.get(txn);
      if (oldData != null) {
        await newRecord.put(txn, {
          ...oldData as Map<String, dynamic>,
          'category': newName,
        });
        await oldRecord.delete(txn);
      }
    });
  }

  Future<void> deleteCategory(String category) async {
    final record = _store.record(category);
    await record.delete(_db);
  }
}
