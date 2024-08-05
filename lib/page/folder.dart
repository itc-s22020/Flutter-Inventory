import 'package:flutter/material.dart';
import 'package:inventory/navigation.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("#FolderPage"),
              OutlinedButton(
                  onPressed: toMakeFolder,
                  child: Text("toMakeFolder")
              )
            ]
        )
    );
  }
}