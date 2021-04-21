import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:zaanassh/screens/daily_record_screen.dart';
import 'package:zaanassh/screens/home_screen.dart';
import 'package:zaanassh/screens/record_screen.dart';
import 'package:zaanassh/screens/save_activity.dart';
import 'package:zaanassh/screens/us_screen.dart';

class NavigationBarScreen extends StatefulWidget {
  @override
  _NavigationBarScreenState createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  ShapeBorder bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(55)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(12);

  int _selectedItemPosition = 2;
  SnakeShape snakeShape = SnakeShape.circle;

  bool showSelectedLabels = true;
  bool showUnselectedLabels = true;

  Color selectedColor = Colors.black;
  Gradient selectedGradient =
      const LinearGradient(colors: [Colors.red, Colors.amber]);

  Color unselectedColor = Colors.blueGrey;
  Gradient unselectedGradient =
      const LinearGradient(colors: [Colors.red, Colors.blueGrey]);

  List<Widget> screens = [
    HomeScreen(),
    RecordScreen(
      showMap: false,
    ),
    UsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedItemPosition],
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      bottomNavigationBar: SnakeNavigationBar.color(
        height: MediaQuery.of(context).size.height / 12.0,
        backgroundColor: Colors.white.withOpacity(0.1),
        behaviour: snakeBarStyle,
        snakeShape: snakeShape,
        shape: bottomBarShape,
        padding: padding,
        elevation: 1.0,

        ///configuration for SnakeNavigationBar.color
        snakeViewColor: Colors.orange[600],
        selectedItemColor:
            snakeShape == SnakeShape.indicator ? selectedColor : null,
        unselectedItemColor: Colors.blueGrey,

        ///configuration for SnakeNavigationBar.gradient
        // snakeViewGradient: selectedGradient,
        // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
        // unselectedItemGradient: unselectedGradient,

        showUnselectedLabels: showUnselectedLabels,
        showSelectedLabels: showSelectedLabels,

        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.fiber_smart_record), label: 'Record'),
          const BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Us')
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
    );
  }
}
