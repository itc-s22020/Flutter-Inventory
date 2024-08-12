import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../getx/inventory_controller.dart';
import '../pref/last_used_folder.dart';
import '../ui/custom_app_bar.dart';

class InventoryPage extends StatelessWidget {
  final InventoryController _inventoryController = Get.put(InventoryController());

  InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getLastUsedFolder(),
      builder: (context, snapshot) {
        final folderName = snapshot.data ?? '';
        if (snapshot.hasData && folderName.isNotEmpty) {
          _inventoryController.loadItems(folderName);
        }
        return Scaffold(
          appBar: CustomAppBar(title: folderName, page: 1),
          body: buildBody(snapshot),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddItemDialog(context, folderName),
            heroTag: 'inventory',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context, String folderName) {
    String newItemName = '';
    int newItemQuantity = 1;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Item to $folderName'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(labelText: "Item name"),
                  onChanged: (value) {
                    newItemName = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: "Quantity"),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    newItemQuantity = int.tryParse(value) ?? 1;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (newItemName.isNotEmpty) {
                  await _inventoryController.addItem(folderName, newItemName, newItemQuantity);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildBody(AsyncSnapshot<String?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No folder found'));
    } else {
      final folderName = snapshot.data!;
      return Obx(() {
        final items = _inventoryController.items;
        if (items.isEmpty) {
          return const Center(child: Text('No items in this folder'));
        } else {
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(
                  item['name'] as String,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${item['stock'] ?? 0}'),
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: () async {
                        final newStock = (item['stock'] as int? ?? 1) - 1;
                        if (newStock >= 0) {
                          await _inventoryController.updateItemStock(folderName, item['name'] as String, newStock);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () async {
                        final newStock = (item['stock'] as int? ?? 1) + 1;
                        await _inventoryController.updateItemStock(folderName, item['name'] as String, newStock);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      });
    }
  }
}