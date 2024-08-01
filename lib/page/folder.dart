import 'package:flutter/material.dart';
import 'package:inventory/navigation.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("#FolderPage"),
                OutlinedButton(
                    onPressed: () => toMakeFolder(context),
                    child: const Text("toMakeFolder")
                )
              ]
          )
      ),
    );

  }
}