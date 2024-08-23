import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../generated/l10n.dart';
import '../../getx/folder_controller.dart';
import 'rename_folder_dialog.dart';

class FolderOptionsDialog extends StatelessWidget {
  final String folderName;

  const FolderOptionsDialog({
    super.key,
    required this.folderName,
  });

  Future<void> _showRenameFolderDialog(BuildContext context) async {
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RenameFolderDialog(
          oldName: folderName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FolderController folderController = Get.find<FolderController>();

    return AlertDialog(
      title: Text(folderName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text(S.of(context).rename),
            onTap: () => _showRenameFolderDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(S.of(context).delete),
            onTap: () => folderController.deleteFolder(context, folderName),
          ),
        ],
      ),
    );
  }
}
