import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory/getx/inventory_controller.dart';
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _inventoryController.loadItems(folderName);
          });
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
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddItemDialog(folderName: folderName);
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
              return Card(
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
                            Obx(() => Text('在庫: ${item['stock'] ?? 0}')),
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
              );
            },
          );
        }
      });
    }
  }
}

class AddItemDialog extends StatelessWidget {
  final String folderName;

  AddItemDialog({required this.folderName, super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(text: '1');
  final CropController cropController = CropController();

  final Rxn<Uint8List> croppedImage = Rxn<Uint8List>();

  Future<void> pickAndCropImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = await pickedFile.readAsBytes();

      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Crop your image'),
            content: SizedBox(
              width: double.maxFinite,
              child: Crop(
                image: image,
                controller: cropController,
                interactive: true,
                fixCropRect: true,
                cornerDotBuilder: (_, __) => const SizedBox.shrink(),
                onCropped: (croppedData) {
                  croppedImage.value = croppedData;
                  Navigator.of(context).pop();
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => cropController.crop(),
                child: const Text('Crop'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Item to $folderName'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: "Item name"),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pickAndCropImage(context),
              child: const Text('Select and Crop Image'),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (croppedImage.value != null) {
                return Image.memory(
                  croppedImage.value!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
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
            final newItemName = nameController.text;
            final newItemQuantity = int.tryParse(quantityController.text) ?? 1;

            if (newItemName.isNotEmpty) {
              await Get.find<InventoryController>().addItem(
                folderName,
                newItemName,
                newItemQuantity,
                croppedImage.value,
              );
              if (!context.mounted) return;
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}