import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../generated/l10n.dart';
import '../../getx/folder_controller.dart';

class RenameFolderDialog extends StatelessWidget {
  final String oldName;

  const RenameFolderDialog({
    super.key,
    required this.oldName,
  });

  @override
  Widget build(BuildContext context) {
    final FolderController folderController = Get.find<FolderController>();
    String newName = '';

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
              folderController.renameFolder(context, oldName, newName);
            }
          },
        ),
      ],
    );
  }
}
