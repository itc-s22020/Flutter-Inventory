import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory/getx/inventory_controller.dart';
import 'package:inventory/pref/last_used_folder.dart';
import 'package:inventory/ui/custom_app_bar.dart';

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
    Uint8List? croppedImage;
    final CropController cropController = CropController();

    Future<void> pickAndCropImage() async {
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
                    croppedImage = croppedData;
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: pickAndCropImage,
                  child: const Text('Select and Crop Image'),
                ),
                if (croppedImage != null)
                  Image.memory(croppedImage!, height: 100),
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
                  await _inventoryController.addItem(
                    folderName,
                    newItemName,
                    newItemQuantity,
                    croppedImage,
                  );
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
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: item['image'] != null && item['image'].isNotEmpty
                      ? Image.memory(
                    Uint8List.fromList(List<int>.from(item['image'])),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(
                    Icons.image_not_supported,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
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
                          await _inventoryController.updateItemStock(
                              folderName, item['name'] as String, newStock);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () async {
                        final newStock = (item['stock'] as int? ?? 1) + 1;
                        await _inventoryController.updateItemStock(
                            folderName, item['name'] as String, newStock);
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
