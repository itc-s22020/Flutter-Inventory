import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  Future<String?> _getLastUsedFolder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_used_folder');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: FutureBuilder<String?>(
        future: _getLastUsedFolder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No folder found'));
          } else {
            final folderName = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Inventory of $folderName"),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO:あとで
        },
        heroTag: 'inventory',
        child: const Icon(Icons.add),
      ),
    );
  }
}
