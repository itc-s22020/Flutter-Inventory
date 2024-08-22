import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../generated/l10n.dart';
import '../../getx/inventory_controller.dart';

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
