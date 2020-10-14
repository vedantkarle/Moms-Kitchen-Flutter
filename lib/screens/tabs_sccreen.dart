import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/add_recipe_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {
        'page': MealsScreen(),
        "title": 'Moms Kitchen',
      },
      {
        'page': AddRecipeScreen(),
        'title': 'AddNewRecipe',
      }
    ];
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            backgroundColor: Theme.of(context).primaryColor,
            title: Text('Recipes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            title: Text('Add New'),
            backgroundColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
