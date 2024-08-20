import 'package:flutter/material.dart';

class Version extends StatelessWidget {
  const Version({super.key});
  @override
  Widget build(BuildContext context) {
    const version = "0.1.1";
    return const Text(
      "Version-$version@2024/08/20",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey
      ),
    );
  }

}