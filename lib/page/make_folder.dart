import 'package:flutter/material.dart';
import 'package:inventory/navigation.dart';

class MakeFolderPage extends StatelessWidget {
  const MakeFolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("#MakeFolderPage"),
                  OutlinedButton(
                      onPressed: () => toBack(context),
                      child: const Text("toFolder")
                  )
                ]
            )
        )
    );
  }
}