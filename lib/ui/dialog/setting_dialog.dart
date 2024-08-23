import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../pref/setting.dart';
import 'package:get/get.dart';
import '../version.dart';

class SettingDialog extends StatelessWidget {
  final String currentLanguage;
  final bool snackBarOnlyError;
  final RxString selectedLanguage = ''.obs;
  final RxBool snackBarOnlyErrorRx = false.obs;

  SettingDialog({
    required this.currentLanguage,
    required this.snackBarOnlyError,
    super.key,
  }) {
    selectedLanguage.value = currentLanguage;
    snackBarOnlyErrorRx.value = snackBarOnlyError;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).setting),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return DropdownButtonFormField<String>(
                value: selectedLanguage.value,
                decoration: InputDecoration(labelText: S.of(context).language),
                items: ['English', 'Japanese']
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ))
                    .toList(),
                onChanged: (String? newValue) {
                  selectedLanguage.value = newValue ?? currentLanguage;
                },
              );
            }),
            const SizedBox(height: 12),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).errorOnly),
                  Switch(
                    value: snackBarOnlyErrorRx.value,
                    onChanged: (bool value) {
                      snackBarOnlyErrorRx.value = value;
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 12),
            const Version(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(S.of(context).cancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(S.of(context).save),
          onPressed: () => _saveSettings(context),
        ),
      ],
    );
  }

  Future<void> _saveSettings(BuildContext context) async {
    await saveLanguage(selectedLanguage.value);
    await saveSnackBarOnlyError(snackBarOnlyErrorRx.value ? 'on' : 'off');

    Locale locale = (selectedLanguage.value == 'Japanese')
        ? const Locale('ja')
        : const Locale('en');
    Get.updateLocale(locale);

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}
