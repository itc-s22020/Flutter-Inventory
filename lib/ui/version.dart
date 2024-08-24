import 'package:flutter/material.dart';

class Version extends StatelessWidget {
  const Version({super.key});
  @override
  Widget build(BuildContext context) {

    const version = "1.0.0";
    const date = "2024/08/24";

    return const Text(
      "Version-$version@$date",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey
      ),
    );
  }
}