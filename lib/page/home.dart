import 'package:flutter/material.dart';

import 'folder.dart';
import 'inventory.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, required this.initialIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages = [
      FolderPage(),
      InventoryPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _pages[1] = InventoryPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            activeIcon: Icon(Icons.folder_open),
            label: 'Folder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            activeIcon: Icon(Icons.widgets),
            label: 'Inventory',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).disabledColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
