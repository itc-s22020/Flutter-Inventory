import 'package:flutter/material.dart';
import 'package:inventory/navigation.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("#InventoryPage"),
                  OutlinedButton(
                      onPressed: toAddInventory,
                      child: Text("toAddInventory")
                  )
                ]
            )
        ),
    );
  }
}