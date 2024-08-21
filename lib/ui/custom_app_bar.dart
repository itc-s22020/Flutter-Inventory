import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/ui/version.dart';

import '../generated/l10n.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leadingWidth: 56,
      // ::TODO 未実装なので一時的に非表示
      // leading: Padding(
      //   padding: const EdgeInsets.only(left: 4.0),
      //   child: ValueListenableBuilder<IconData>(
      //     valueListenable: _viewIconNotifier,
      //     builder: (context, icon, child) {
      //       return _buildIconButton(
      //         icon: icon,
      //         onTap: () => _changeViewStyle(page),
      //       );
      //     },
      //   ),
      // ),
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

  Future<void> _showSettingDialog(BuildContext context) async {
    String currentLanguage = await getLanguage();
    String currentSnackBarOnlyError = await getSnackBarOnlyError();

    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String selectedLanguage = currentLanguage;
        bool snackBarOnlyError = currentSnackBarOnlyError == 'on';

        return StatefulBuilder(
          builder: (BuildContext builderContext, StateSetter setState) {
            return AlertDialog(
              title: Text(S.of(builderContext).setting),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    decoration: InputDecoration(
                        labelText: S.of(builderContext).language),
                    items: ['English', 'Japanese']
                        .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLanguage = newValue ?? currentLanguage;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(builderContext).errorOnly),
                      Switch(
                        value: snackBarOnlyError,
                        onChanged: (bool value) {
                          setState(() {
                            snackBarOnlyError = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Version()
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(S.of(context).cancel),
                  onPressed: () {
                    Navigator.of(builderContext).pop();
                  },
                ),
                TextButton(
                  child: Text(S.of(context).save),
                  onPressed: () async {
                    await saveLanguage(selectedLanguage);
                    await saveSnackBarOnlyError(
                        snackBarOnlyError ? 'on' : 'off');
                    Locale locale = (selectedLanguage == 'Japanese')
                        ? const Locale('ja')
                        : const Locale('en');
                    Get.updateLocale(locale);
                    if (!builderContext.mounted) return;
                    Navigator.of(builderContext).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
