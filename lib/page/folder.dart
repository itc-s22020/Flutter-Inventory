import 'package:flutter/material.dart';
import '../sembast/inventory_service.dart';

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
              title: const Text('Create New Folder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(hintText: "Enter folder name"),
                      onChanged: (value) {
                        newCategory = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Select an icon:'),
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
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('フォルダ名 "$category" が重複 (エラー)')),
        );
        Navigator.of(context).pop();
        return;
      }

      int iconIndex = _icons.indexOf(icon);
      await _inventoryService.addItem(category, '', '', iconIndex, '');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('フォルダ "$category" を作成')),
      );
      _notifier.value++;
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating folder: $e (エラー)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
      ),
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
                return const Center(child: Text('No folders found'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final category = snapshot.data![index];
                    return ListTile(
                      leading: Icon(_icons[category['iconIndex'] as int]),
                      title: Text(category['name'] as String),
                      onTap: () {
                        // TODO: あとで
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
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }
}
