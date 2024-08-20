import 'package:get/get.dart';
import 'package:inventory/pref/folder_view.dart';
import 'package:inventory/pref/inventory_view.dart';

class ViewController extends GetxController {
  final RxString folderViewType = 'list'.obs;
  final RxString inventoryViewType = 'list'.obs;

  @override
  void onInit() {
    super.onInit();
    loadViewTypes();
  }

  Future<void> loadViewTypes() async {
    final savedFolderViewType = await getFolderView();
    final savedInventoryViewType = await getInventoryView();
    folderViewType.value = savedFolderViewType ?? 'list';
    inventoryViewType.value = savedInventoryViewType ?? 'list';
  }

  Future<void> toggleViewType(int page) async {
    if (page == 0) {
      final newViewType = folderViewType.value == 'list' ? 'grid' : 'list';
      await saveFolderView(newViewType);
      folderViewType.value = newViewType;
    } else {
      final newViewType = inventoryViewType.value == 'list' ? 'grid' : 'list';
      await saveInventoryView(newViewType);
      inventoryViewType.value = newViewType;
    }
  }

  String getViewType(int page) {
    return page == 0 ? folderViewType.value : inventoryViewType.value;
  }
}