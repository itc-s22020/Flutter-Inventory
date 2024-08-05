import 'package:flutter/material.dart';
import 'package:inventory/getx/navigation.dart';

class MakeFolderPage extends StatelessWidget {
  const MakeFolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("#MakeFolderPage"),
                  OutlinedButton(
                      onPressed: toBack,
                      child: Text("toFolder")
                  )
                ]
            )
        )
    );
  }
}