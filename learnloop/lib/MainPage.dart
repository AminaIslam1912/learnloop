import 'package:flutter/material.dart';
import 'request_sent.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
   // Center(child: Text('Home Page')), // Home page placeholder
    HomePage(),
    RequestPage(),                    // Requests page
    Center(child: Text('Messages')),  // Messages page placeholder
    Center(child: Text('Profile')),   // Profile page placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_app.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF264E70), // Background color for all icons
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home, isSelected: _currentIndex == 0),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.people, isSelected: _currentIndex == 1),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.message, isSelected: _currentIndex == 2),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person, isSelected: _currentIndex == 3),
              label: "",
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Color(0xFF264E70),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData iconData, {required bool isSelected}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: isSelected ? Colors.white : Color(0xFF264E70), // Background color for selected icon
      ),
      padding: EdgeInsets.all(8),
      child: Icon(
        iconData,
        color: isSelected ? Color(0xFF264E70) : Colors.white, // Icon color
        size: 28,
      ),
    );
  }
}
