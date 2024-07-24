import 'package:flutter/material.dart';
import 'package:inventory/getx/navigation.dart';

class AddInventoryPage extends StatelessWidget {
  const AddInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("#AddInventoryPage"),
                  OutlinedButton(
                      onPressed: toInventory,
                      child: Text("toInventory")
                  )
                ]
            )
        )
    );
  }
}