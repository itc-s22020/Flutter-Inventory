import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../sembast/inventory_service.dart';
import '../../generated/l10n.dart';
import '../pref/last_used_folder.dart';
import '../ui/custom_snack_bar.dart';

class FolderController extends GetxController {
  RxList<Map<String, dynamic>> folders = <Map<String, dynamic>>[].obs;
  final InventoryService _inventoryService = InventoryService();

  Future<void> loadFolders() async {
    final folderList = await _inventoryService.getAllFolder();
    folders.assignAll(folderList);
  }

  Future<void> addFolder(BuildContext context, String folder, int iconIndex,
      List<IconData> icons) async {
    try {
      final existingFolders = await getAllFolder();
      final folderNames =
          existingFolders.map((cat) => cat['name'] as String).toList();

      if (folderNames.contains(folder)) {
        if (!context.mounted) return;
        CustomSnackBar.show(
          title: S.of(context).error,
          message: S.of(context).errorDuplicationFolder(folder),
          isError: true,
        );
        return;
      }

      await _inventoryService.addFolder(folder, iconIndex);
      loadFolders();

      if (!context.mounted) return;
      CustomSnackBar.show(
        title: S.of(context).success,
        message: S.of(context).successMakeFolder(folder),
      );
    } catch (e) {
      CustomSnackBar.show(
        title: S.of(context).error,
        message: S.of(context).errorFolder(e.toString()),
        isError: true,
      );
    }
  }

  Future<void> renameFolder(
      BuildContext context, String oldName, String newName) async {
    try {
      final existingFolder = await _inventoryService.getAllFolder();
      final folderNames =
          existingFolder.map((cat) => cat['name'] as String).toList();

      if (!context.mounted) return;
      if (folderNames.contains(newName)) {
        CustomSnackBar.show(
          title: S.of(context).error,
          message: S.of(context).errorDuplicationFolder(newName),
          isError: true,
        );
        return;
      }

      await saveLastUsedFolder(newName);
      await _inventoryService.renameFolder(oldName, newName);
      loadFolders();
      if (!context.mounted) return;
      CustomSnackBar.show(
        title: S.of(context).success,
        message: S.of(context).successRenameFolder(oldName, newName),
      );
      Navigator.of(context).pop();
    } catch (e) {
      CustomSnackBar.show(
        title: S.of(context).error,
        message: S.of(context).errorFolderRename(e),
        isError: true,
      );
    }
  }

  Future<void> deleteFolder(BuildContext context, String folderName) async {
    try {
      await _inventoryService.deleteFolder(folderName);
      loadFolders();
      await saveLastUsedFolder('');
      if (!context.mounted) return;
      CustomSnackBar.show(
        title: S.of(context).success,
        message: S.of(context).successDeleteFolder(folderName),
      );
      Navigator.of(context).pop();
    } catch (e) {
      CustomSnackBar.show(
        title: S.of(context).error,
        message: S.of(context).errorDeleteFolder(e),
        isError: true,
      );
    }
  }

  Future<int> getItemCount(folder) {
    return _inventoryService.getItemCount(folder);
  }

  Future<List<Map<String, dynamic>>> getAllFolder() async {
    return await _inventoryService.getAllFolder();
  }
}
