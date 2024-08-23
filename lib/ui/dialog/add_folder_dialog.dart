import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'package:get/get.dart';

import '../../getx/folder_controller.dart';

class AddFolderDialog extends StatelessWidget {
  final List<IconData> icons;
  final FolderController controller = Get.find<FolderController>();

  AddFolderDialog({
    super.key,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    String newFolder = '';
    IconData selectedIcon = icons.first;

    return AlertDialog(
      title: Text(S.of(context).makeFolder),
      content: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration:
                      InputDecoration(hintText: S.of(context).folderNameField),
                  onChanged: (value) {
                    newFolder = value;
                  },
                ),
                const SizedBox(height: 20),
                Text(S.of(context).icon),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: icons.map((IconData icon) {
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
          );
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
          child: Text(S.of(context).create),
          onPressed: () {
            if (newFolder.isNotEmpty) {
              controller
                  .addFolder(
                      context, newFolder, icons.indexOf(selectedIcon), icons)
                  .then((_) {
                Navigator.of(context).pop();
              });
            }
          },
        ),
      ],
    );
  }
}
