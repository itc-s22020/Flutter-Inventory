import 'package:flutter/material.dart';
import 'package:inventory/pref/last_used_folder.dart';
import '../ui/custom_app_bar.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getLastUsedFolder(),
      builder: (context, snapshot) {
        final folderName = snapshot.data ?? '';
        return Scaffold(
          appBar: CustomAppBar(title: folderName, page: 1),
          body: _buildBody(snapshot),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              //TODO:あとで
            },
            heroTag: 'inventory',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<String?> snapshot) {
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
  }
}