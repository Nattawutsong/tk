import 'package:flutter/material.dart';
import 'About_page.dart';
import 'HomePage.dart';
import 'logout_page.dart'; // Import HomePage


class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ImageClassificationPage(), // Navigate to HomePage here
    AboutPage(),
    LogoutPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      // Simulate logout logic if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged out! Returning to login screen...')),
      );
      Future.delayed(Duration(seconds: 3), () {
        // Perform logout action or navigate to login page
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.green),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info, color: Colors.orange),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.red),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
