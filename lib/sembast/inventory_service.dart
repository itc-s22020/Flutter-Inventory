import 'package:sembast/sembast.dart';
import 'database_service.dart';

class InventoryService {
  final _db = DatabaseService().db;
  final _store = stringMapStoreFactory.store('inventory');

  Future<void> addItem(String category, String name, String image, int iconIndex, String text) async {
    final finder = Finder(filter: Filter.equals('category', category));
    final record = _store.record(category);
    await _db.transaction((txn) async {
      final snapshot = await _store.findFirst(txn, finder: finder);
      if (snapshot == null) {
        await _store.add(txn, {
          'category': category,
          'iconIndex': iconIndex,
          'items': [
            {
              'name': name,
              'image': image,
              'text': text,
            }
          ],
        });
      } else {
        final value = snapshot.value as Map<String, dynamic>;
        final currentItems = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final updatedItems = List<Map<String, dynamic>>.from(currentItems)
          ..add({
            'name': name,
            'image': image,
            'text': text,
          });
        await record.put(txn, {
          'category': category,
          'iconIndex': iconIndex,
          'items': updatedItems,
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> getItems(String category) async {
    final finder = Finder(filter: Filter.equals('category', category));
    final snapshot = await _store.findFirst(_db, finder: finder);
    if (snapshot == null) {
      return [];
    } else {
      final value = snapshot.value as Map<String, dynamic>;
      final items = (value['items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      return items;
    }
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
}