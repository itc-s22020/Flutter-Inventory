import 'package:flutter/material.dart';
import 'package:inventory/getx/navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("#HomePage"),
                  OutlinedButton(
                      onPressed: toInventory,
                      child: Text("toInventory")
                  ),
                  OutlinedButton(
                      onPressed: toMakeFolder, 
                      child: Text("toMakeFolder")
                  )
                ]
            )
        )
    );
  }
}