import 'package:flutter/material.dart';
import 'package:inventory/pref/folder_view.dart';
import 'package:inventory/pref/inventory_view.dart';

import '../pref/setting.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int page;
  final ValueNotifier<IconData> _viewIconNotifier;

  CustomAppBar({super.key, required this.title, required this.page})
      : _viewIconNotifier = ValueNotifier(Icons.view_list_rounded) {
    _updateViewIcon();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _updateViewIcon() async {
    final currentView = page == 0
        ? await getFolderView()
        : await getInventoryView();
    _viewIconNotifier.value = currentView == 'list'
        ? Icons.view_list_rounded
        : Icons.grid_view_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leadingWidth: 56,
      leading: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: ValueListenableBuilder<IconData>(
          valueListenable: _viewIconNotifier,
          builder: (context, icon, child) {
            return _buildIconButton(
              icon: icon,
              onTap: () => _changeViewStyle(page),
            );
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: _buildIconButton(
            icon: Icons.settings,
            onTap: () => _showSettingDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Icon(icon),
        ),
      ),
    );
  }

  Future<void> _changeViewStyle(int page) async {
    (page == 0)
        ? saveFolderView(await getFolderView() == 'list' ? 'grid' : 'list')
        : saveInventoryView(await getInventoryView() == 'list' ? 'grid' : 'list');
    _updateViewIcon();
  }

  Future<void> _showSettingDialog(BuildContext context) async {
    String currentLanguage = await getLanguage();
    String currentSnackBarTheme = await getSnackBarTheme();

    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedLanguage = currentLanguage;
        String selectedSnackBarTheme = currentSnackBarTheme;

        return AlertDialog(
          title: const Text('設定'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedLanguage,
                decoration: const InputDecoration(labelText: '言語'),
                items: ['English', 'Japanese']
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                    .toList(),
                onChanged: (String? newValue) {
                  selectedLanguage = newValue ?? currentLanguage;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedSnackBarTheme,
                decoration: const InputDecoration(labelText: 'スナックバーテーマ'),
                items: ['simpleModern']
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                    .toList(),
                onChanged: (String? newValue) {
                  selectedSnackBarTheme = newValue ?? currentSnackBarTheme;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('保存'),
              onPressed: () async {
                await saveLanguage(selectedLanguage);
                await saveSnackBarTheme(selectedSnackBarTheme);
                if (!context.mounted) return;
                Navigator.of(context).pop();
                // 必要に応じてUIやテーマの更新を行う
              },
            ),
          ],
        );
      },
    );
  }
}