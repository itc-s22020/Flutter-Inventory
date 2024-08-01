import 'package:flutter/material.dart';
import 'package:inventory/page/add_inventory.dart';
import 'package:inventory/page/inventory.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'folder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final pages = [
      const FolderPage(),
      const InventoryPage(),
    ];

    return  Scaffold(
      body: PersistentTabView(
        context,
        screens: pages,
        navBarStyle: NavBarStyle.style1,
        items: [
          PersistentBottomNavBarItem(
              icon: const Icon(Icons.folder_open),
              inactiveIcon: const Icon(Icons.folder),
              title: "Folder",
              activeColorPrimary: Theme.of(context).primaryColor,
              inactiveColorPrimary: Theme.of(context).disabledColor
          ),
          PersistentBottomNavBarItem(
              icon: const Icon(Icons.widgets),
              inactiveIcon: const Icon(Icons.inventory),
              title: "Inventory",
              activeColorPrimary: Theme.of(context).primaryColor,
              inactiveColorPrimary: Theme.of(context).disabledColor
          ),
        ],
      )
    );
  }
}