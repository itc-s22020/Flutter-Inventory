import 'package:flutter/material.dart';
import 'package:inventory/ui/dialog/setting_dialog.dart';

import '../pref/folder_view.dart';
import '../pref/inventory_view.dart';
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
    final currentView =
    page == 0 ? await getFolderView() : await getInventoryView();
    _viewIconNotifier.value = currentView == 'list'
        ? Icons.view_list_rounded
        : Icons.grid_view_rounded;
  }

  void _showSettingDialog(BuildContext context, currentLanguage, currentSnackBarOnlyError) {
    showDialog(
      context: context,
      builder: (_) => SettingDialog(
        currentLanguage: currentLanguage,
        snackBarOnlyError: currentSnackBarOnlyError == 'on',
      ),
    );
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
            onTap: () async {
              String currentLanguage = await getLanguage();
              String currentSnackBarOnlyError = await getSnackBarOnlyError();
              if (!context.mounted) return;
              _showSettingDialog(context, currentLanguage, currentSnackBarOnlyError);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onTap}) {
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
        : saveInventoryView(
            await getInventoryView() == 'list' ? 'grid' : 'list');
    _updateViewIcon();
  }
}
