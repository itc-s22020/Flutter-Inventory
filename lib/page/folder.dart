import 'package:flutter/material.dart';
import 'package:inventory/getx/navigation.dart';
import 'package:inventory/pref/last_used_folder.dart';
import 'package:inventory/sembast/inventory_service.dart';
import 'package:inventory/ui/custom_app_bar.dart';
import 'package:inventory/ui/custom_snack_bar.dart';

class FolderPage extends StatelessWidget {
  final InventoryService _inventoryService = InventoryService();
  final ValueNotifier<int> _notifier = ValueNotifier<int>(0);

  final List<IconData> _icons = [
    Icons.folder, Icons.work, Icons.home, Icons.school,
    Icons.favorite, Icons.music_note, Icons.sports_soccer, Icons.star,
    Icons.local_dining, Icons.shopping_cart, Icons.book, Icons.science,
    Icons.water_drop, Icons.pentagon
  ];

  FolderPage({super.key});

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    String newCategory = '';
    IconData selectedIcon = _icons.first;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('フォルダ作成'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(hintText: "フォルダ名を入力"),
                      onChanged: (value) {
                        newCategory = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('アイコン:'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _icons.map((IconData icon) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIcon = icon;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedIcon == icon ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon),
                          ),
                        );
                      }).toList(),
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
                  child: const Text('Create'),
                  onPressed: () {
                    if (newCategory.isNotEmpty) {
                      _addCategory(context, newCategory, selectedIcon);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addCategory(BuildContext context, String category, IconData icon) async {
    try {
      final existingCategories = await _inventoryService.getAllCategories();
      final categoryNames = existingCategories.map((cat) => cat['name'] as String).toList();

      if (categoryNames.contains(category)) {
        CustomSnackBar.show(
          title: 'エラー',
          message: 'フォルダ "$category" が重複しています',
          isError: true,
        );
        if (!context.mounted) return;
        Navigator.of(context).pop();
        return;
      }

      int iconIndex = _icons.indexOf(icon);
      await _inventoryService.addCategory(category, iconIndex);
      CustomSnackBar.show(
        title: '成功',
        message: 'フォルダ "$category" を作成しました',
      );
      _notifier.value++;
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      CustomSnackBar.show(
        title: 'エラー',
        message: 'フォルダの作成に失敗しました: $e',
        isError: true,
      );
    }
  }

  Future<void> _showFolderOptionsDialog(BuildContext context, String folderName) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(folderName),
          actions: <Widget>[
            TextButton(
              child: const Text('rename'),
              onPressed: () {
                Navigator.of(context).pop();
                _showRenameFolderDialog(context, folderName);
              },
            ),
            TextButton(
              child: const Text('delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCategory(context, folderName);
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRenameFolderDialog(BuildContext context, String oldName) async {
    String newName = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename Folder'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "新しいフォルダ名を入力"),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Rename'),
              onPressed: () {
                if (newName.isNotEmpty) {
                  _renameCategory(context, oldName, newName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameCategory(BuildContext context, String oldName, String newName) async {
    try {
      final existingCategories = await _inventoryService.getAllCategories();
      final categoryNames = existingCategories.map((cat) => cat['name'] as String).toList();

      if (categoryNames.contains(newName)) {
        CustomSnackBar.show(
          title: 'エラー',
          message: 'フォルダ "$newName" が既に存在しています',
          isError: true,
        );
        return;
      }

      await saveLastUsedFolder(newName);
      await _inventoryService.renameCategory(oldName, newName);
      CustomSnackBar.show(
        title: '成功',
        message: 'フォルダ "$oldName" を "$newName" に変更しました',
      );
      _notifier.value++;
    } catch (e) {
      CustomSnackBar.show(
        title: 'エラー',
        message: 'フォルダの名前変更に失敗しました: $e',
        isError: true,
      );
    }
  }

  Future<void> _deleteCategory(BuildContext context, String folderName) async {
    try {
      await _inventoryService.deleteCategory(folderName);
      await saveLastUsedFolder('');
      CustomSnackBar.show(
        title: '成功',
        message: 'フォルダ "$folderName" を削除しました',
      );
      _notifier.value++;
    } catch (e) {
      CustomSnackBar.show(
        title: 'エラー',
        message: 'フォルダの削除に失敗しました: $e',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Folder', page: 0),
      body: ValueListenableBuilder<int>(
        valueListenable: _notifier,
        builder: (context, value, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _inventoryService.getAllCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('フォルダが存在しません'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final category = snapshot.data![index];
                    return ListTile(
                      leading: Icon(_icons[category['iconIndex'] as int]),
                      title: Text(category['name'] as String),
                      onTap: () {
                        toInventory();
                        saveLastUsedFolder(category['name'] as String);
                      },
                      onLongPress: () {
                        _showFolderOptionsDialog(context, category['name'] as String);
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        heroTag: 'folder',
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }
}

