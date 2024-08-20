import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../getx/navigation.dart';
import '../pref/last_used_folder.dart';
import '../sembast/inventory_service.dart';
import '../ui/custom_app_bar.dart';
import '../ui/custom_snack_bar.dart';

class FolderPage extends StatelessWidget {
  final InventoryService _inventoryService = InventoryService();
  final ValueNotifier<int> _notifier = ValueNotifier<int>(0);

  final List<IconData> _icons = [
    Icons.folder,
    Icons.work,
    Icons.home,
    Icons.school,
    Icons.favorite,
    Icons.music_note,
    Icons.sports_soccer,
    Icons.star,
    Icons.local_dining,
    Icons.shopping_cart,
    Icons.book,
    Icons.science,
    Icons.water_drop,
    Icons.pentagon
  ];

  FolderPage({super.key});

  Future<void> _showAddFolderDialog(BuildContext context) async {
    String newCategory = '';
    IconData selectedIcon = _icons.first;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(S.of(context).makeFolder),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: S.of(context).folderNameField),
                      onChanged: (value) {
                        newCategory = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(S.of(context).icon),
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
                              color: selectedIcon == icon
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.transparent,
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
                  child: Text(S.of(context).cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(S.of(context).create),
                  onPressed: () {
                    if (newCategory.isNotEmpty) {
                      _addFolder(context, newCategory, selectedIcon);
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

  Future<void> _addFolder(
      BuildContext context, String folder, IconData icon) async {
    try {
      final existingCategories = await _inventoryService.getAllCategories();
      final categoryNames =
          existingCategories.map((cat) => cat['name'] as String).toList();

      if (categoryNames.contains(folder)) {
        if (!context.mounted) return;
        CustomSnackBar.show(
          title: S.of(context).error,
          message: S.of(context).errorDuplicationFolder(folder),
          isError: true,
        );
        Navigator.of(context).pop();
        return;
      }

      int iconIndex = _icons.indexOf(icon);
      await _inventoryService.addCategory(folder, iconIndex);
      if (!context.mounted) return;
      CustomSnackBar.show(
        title: S.of(context).success,
        message: S.of(context).successMakeFolder(folder),
      );
      _notifier.value++;
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      CustomSnackBar.show(
        title: S.of(context).error,
        message: S.of(context).errorFolder(e),
        isError: true,
      );
    }
  }

  Future<void> _showFolderOptionsDialog(
      BuildContext context, String folderName) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(folderName),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).rename),
              onPressed: () {
                Navigator.of(context).pop();
                _showRenameFolderDialog(context, folderName);
              },
            ),
            TextButton(
              child: Text(S.of(context).rename),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFolder(context, folderName);
              },
            ),
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRenameFolderDialog(
      BuildContext context, String oldName) async {
    String newName = '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).renameFolder),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: S.of(context).newFolderName),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).rename),
              onPressed: () {
                if (newName.isNotEmpty) {
                  _renameFolder(context, oldName, newName);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameFolder(
      BuildContext context, String oldName, String newName) async {
    try {
      final existingCategories = await _inventoryService.getAllCategories();
      final categoryNames =
          existingCategories.map((cat) => cat['name'] as String).toList();

      if (!context.mounted) return;
      if (categoryNames.contains(newName)) {
        CustomSnackBar.show(
          title: S.of(context).error,
          message: S.of(context).errorDuplicationFolder(newName),
          isError: true,
        );
        return;
      }

      await saveLastUsedFolder(newName);
      await _inventoryService.renameCategory(oldName, newName);
      if (!context.mounted) return;
      CustomSnackBar.show(
        title: S.of(context).success,
        message: S.of(context).successRenameFolder(oldName, newName),
      );
      _notifier.value++;
    } catch (e) {
      CustomSnackBar.show(
        title: S.of(context).error,
        message: S.of(context).errorFolderRename(e),
        isError: true,
      );
    }
  }

  Future<void> _deleteFolder(BuildContext context, String folderName) async {
    try {
      await _inventoryService.deleteCategory(folderName);
      await saveLastUsedFolder('');
      if (!context.mounted) return;
      CustomSnackBar.show(
        title: S.of(context).success,
        message: S.of(context).successDeleteFolder(folderName),
      );
      _notifier.value++;
    } catch (e) {
      CustomSnackBar.show(
        title: S.of(context).error,
        message: S.of(context).errorDeleteFolder(e),
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
                return Center(child: Text(S.of(context).NoFolderFound));
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
                        _showFolderOptionsDialog(
                            context, category['name'] as String);
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
        onPressed: () => _showAddFolderDialog(context),
        heroTag: 'folder',
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }
}
