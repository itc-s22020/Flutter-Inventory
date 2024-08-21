import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../generated/l10n.dart';
import '../getx/inventory_controller.dart';
import '../pref/last_used_folder.dart';
import '../ui/custom_app_bar.dart';

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
          body: buildBody(snapshot, context),
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

  Widget buildBody(AsyncSnapshot<String?> snapshot, BuildContext context) {
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
            });
          }
        },
      );
    }
  }
}

class AddItemDialog extends StatelessWidget {
  final String folderName;

  AddItemDialog({required this.folderName, super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController =
      TextEditingController(text: '1');
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
      title: Text(S.of(context).addItemMessage(folderName)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(labelText: S.of(context).itemName),
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: S.of(context).stuckNum),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pickAndCropImage(context),
              child: Text(S.of(context).imageSelect),
            ),
            const SizedBox(height: 10),
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
          child: Text(S.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(S.of(context).create),
          onPressed: () async {
            final newItemName = nameController.text;
            final newItemQuantity = int.tryParse(quantityController.text) ?? 1;

            if (newItemName.isNotEmpty) {
              await Get.find<InventoryController>().addItem(folderName,
                  newItemName, newItemQuantity, croppedImage.value, context);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

class EditItemDialog extends StatelessWidget {
  final String folderName;
  final Map<String, dynamic> item;
  final InventoryController _inventoryController =
      Get.find<InventoryController>();

  EditItemDialog({required this.folderName, required this.item, super.key}) {
    _nameController.text = item['name'] as String;
    _quantityController.text = (item['stock'] ?? 0).toString();
    _itemImage.value = item['image'] != null &&
            item['image'] is List<int> &&
            item['image'].isNotEmpty
        ? Uint8List.fromList(List<int>.from(item['image']))
        : null;
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final Rx<Uint8List?> _itemImage = Rx<Uint8List?>(null);
  final CropController _cropController = CropController();

  Future<void> _pickAndCropImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }

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
              controller: _cropController,
              interactive: true,
              fixCropRect: true,
              cornerDotBuilder: (_, __) => const SizedBox.shrink(),
              onCropped: (croppedData) {
                _itemImage.value = croppedData;
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
              onPressed: () => _cropController.crop(),
              child: const Text('Crop'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${item['name']}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: S.of(context).itemName),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: S.of(context).stuckNum),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickAndCropImage(context),
              child: Text(S.of(context).imageChange),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (_itemImage.value != null) {
                return Image.memory(
                  _itemImage.value!,
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
          child: Text(S.of(context).cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(S.of(context).delete),
          onPressed: () => _showDeleteConfirmation(context),
        ),
        TextButton(
          child: Text(S.of(context).save),
          onPressed: () => _saveChanges(context),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).delete),
          content: Text(S.of(context).deleteCheck),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(S.of(context).delete),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true) {
        _inventoryController.deleteItem(
            folderName, item['name'] as String, context);
        Navigator.of(context).pop();
      }
    });
  }

  void _saveChanges(BuildContext context) {
    final newName = _nameController.text;
    final newQuantity =
        int.tryParse(_quantityController.text) ?? item['stock'] as int;

    Map<String, dynamic> updatedItem = Map.from(item);
    updatedItem['name'] = newName;
    updatedItem['stock'] = newQuantity;
    if (_itemImage.value != null) {
      updatedItem['image'] = _itemImage.value!.toList();
    }

    _inventoryController
        .updateItem(folderName, item, updatedItem, context)
        .then((_) {
      _inventoryController.items.refresh();
      Navigator.of(context).pop();
    });
  }
}
