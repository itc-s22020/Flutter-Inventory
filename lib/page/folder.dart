import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../generated/l10n.dart';
import '../getx/folder_controller.dart';
import '../getx/navigation.dart';
import '../pref/last_used_folder.dart';
import '../ui/custom_app_bar.dart';
import '../ui/dialog/add_folder_dialog.dart';
import '../ui/dialog/folder_options_dialog.dart';

class FolderPage extends StatelessWidget {
  final FolderController folderController = Get.put(FolderController());
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
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddFolderDialog(
          icons: _icons,
        );
      },
    );
  }

  Future<void> _showFolderOptionsDialog(
      BuildContext context, String folderName) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return FolderOptionsDialog(
          folderName: folderName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    folderController.loadFolders();
    return Scaffold(
      appBar: CustomAppBar(title: 'Folder', page: 0),
      body: Obx(() {
        if (folderController.folders.isEmpty) {
          return Center(child: Text(S.of(context).NoFolderFound));
        } else {
          return _buildListView(folderController);
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFolderDialog(context),
        heroTag: 'folder',
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }

  Widget _buildListView(FolderController folderController) {
    return ListView.builder(
      itemCount: folderController.folders.length,
      itemBuilder: (context, index) {
        final folder = folderController.folders[index];
        return InkWell(
          onTap: () {
            toInventory();
            saveLastUsedFolder(folder['name'] as String);
          },
          onLongPress: () {
            _showFolderOptionsDialog(context, folder['name'] as String);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Icon(
                      _icons[folder['iconIndex'] as int],
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          folder['name'] as String,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        FutureBuilder<int>(
                          future: folderController
                              .getItemCount(folder['name'] as String),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('');
                            } else if (snapshot.hasError) {
                              return const Text('Error');
                            } else {
                              return Row(children: [
                                const Icon(
                                  Icons.layers,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                Text(
                                  ' ${snapshot.data ?? 0}',
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ]);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
