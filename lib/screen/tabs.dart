import 'package:flutter/material.dart';

import 'package:favorite_places/screen/maps_screen.dart';
import 'package:favorite_places/screen/places.dart';
import 'package:favorite_places/screen/add_place.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    super.key,
  });
  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int idx) {
    setState(() {
      _selectedPageIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? activePage = const PlacesScreen();

    if (_selectedPageIndex == 1) {
      activePage = const MapsScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
      ),
      floatingActionButton: _selectedPageIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const AddPlaceScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Places',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Map',
          ),
        ],
      ),
    );
  }
}
