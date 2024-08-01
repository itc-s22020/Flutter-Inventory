import 'package:flutter/material.dart';
import 'package:inventory/navigation.dart';

class AddInventoryPage extends StatelessWidget {
  const AddInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("#AddInventoryPage"),
                  OutlinedButton(
                      onPressed: () => toInventory(context),
                      child: const Text("toInventory")
                  )
                ]
            )
        )
    );
  }
}