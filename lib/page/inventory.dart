import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../generated/l10n.dart';
import '../getx/inventory_controller.dart';
import '../pref/last_used_folder.dart';
import '../ui/custom_app_bar.dart';
import '../ui/dialog/add_item_dialog.dart';
import '../ui/dialog/edit_item_dialog.dart';

class InventoryPage extends StatelessWidget {
  final InventoryController _inventoryController =
      Get.put(InventoryController());

  InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getLastUsedFolder(),
      builder: (context, snapshot) {
        final folderName = snapshot.data ?? '';
        if (snapshot.hasData && folderName.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _inventoryController.items.clear();
            _inventoryController.loadItems(folderName);
          });
        }
        return Scaffold(
          appBar: CustomAppBar(title: folderName, page: 1),
          body: _buildBody(snapshot, context),
          floatingActionButton: folderName.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () => _showAddItemDialog(context, folderName),
                  heroTag: 'inventory',
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context, String folderName) {
    if (folderName.isEmpty) return;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddItemDialog(folderName: folderName);
      },
    );
  }

  void _showEditItemDialog(
      BuildContext context, String folderName, Map<String, dynamic> item) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return EditItemDialog(folderName: folderName, item: item);
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<String?> snapshot, BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text(S.of(context).NoFolderSelected));
    } else {
      final folderName = snapshot.data!;
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(microseconds: 1)), //NOTE::前回のitemが表示される対策として実装　delayedを使用することでsnapshotのデータを破棄する？
        builder: (context, delaySnapshot) {
          if (delaySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Obx(() {
              final items = _inventoryController.items;
              if (items.isEmpty) {
                return Center(child: Text(S.of(context).NoFolderInItem));
              } else {
                return _buildListView(items, folderName);
              }
            });
          }
        },
      );
    }
  }

  Widget _buildListView(items, folderName) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onLongPress: () => _showEditItemDialog(context, folderName, item),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: item['image'] != null && item['image'].isNotEmpty
                        ? Image.memory(
                      Uint8List.fromList(List<int>.from(item['image'])),
                      fit: BoxFit.cover,
                    )
                        : const Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] as String,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Text('${S.of(context).stuck}: ${item['stock'] ?? 0}')),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 20),
                        onPressed: () {
                          final newStock = (item['stock'] as int? ?? 1) - 1;
                          if (newStock >= 0) {
                            _inventoryController.updateItemStockLocally(item['name'] as String, newStock);
                            _inventoryController.updateItemStock(folderName, item['name'] as String, newStock);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () {
                          final newStock = (item['stock'] as int? ?? 1) + 1;
                          _inventoryController.updateItemStockLocally(item['name'] as String, newStock);
                          _inventoryController.updateItemStock(folderName, item['name'] as String, newStock);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

