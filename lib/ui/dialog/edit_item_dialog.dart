import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../generated/l10n.dart';
import '../../getx/inventory_controller.dart';

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
