import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSnackBar {
  static Future<void> show({
    required String title,
    required String message,
    bool isError = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    bool showOnlyErrors = prefs.getString('snackBarOnlyError') == 'on';

    if (!isError && showOnlyErrors) {
      return;
    }

    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      titleText: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isError ? Colors.red.shade700 : Colors.indigo.shade700,
          fontSize: 14,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      ),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      duration: const Duration(seconds: 4),
      padding: const EdgeInsets.fromLTRB(25, 8, 15, 8),
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
      icon: Icon(
        isError ? Icons.warning_amber_rounded : Icons.check_circle_outline,
        color: isError ? Colors.red.shade400 : Colors.indigo.shade400,
        size: 20,
      ),
      leftBarIndicatorColor: isError ? Colors.red.shade400 : Colors.indigo.shade400,
    );
  }
}