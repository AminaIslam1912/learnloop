// import 'package:flutter/material.dart';
// import 'request_sent.dart';
// import 'homelander/home_page.dart';
//
// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     // Center(child: Text('Home Page')), // Home page placeholder
//     HomePage(),
//     RequestPage(),                    // Requests page
//     Center(child: Text('Messages')),  // Messages page placeholder
//     Center(child: Text('Profile')),   // Profile page placeholder
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.black,
//
//         // decoration: const BoxDecoration(
//         //   image: DecorationImage(
//         //     image: AssetImage('assets/background_app.png'), // Background image
//         //     fit: BoxFit.cover,
//         //   ),
//         // ),
//         child: _pages[_currentIndex],
//       ),
//       // bottomNavigationBar: Container(
//       //   color: Color(0xFF264E70), // Background color for all icons
//       //   child: BottomNavigationBar(
//       //     currentIndex: _currentIndex,
//       //     onTap: (index) {
//       //       setState(() {
//       //         _currentIndex = index;
//       //       });
//       //     },
//       //     items: [
//       //       BottomNavigationBarItem(
//       //         icon: _buildIcon(Icons.home, isSelected: _currentIndex == 0),
//       //         label: "Home",
//       //       ),
//       //       BottomNavigationBarItem(
//       //         icon: _buildIcon(Icons.people, isSelected: _currentIndex == 1),
//       //         label: "Swap",
//       //       ),
//       //       BottomNavigationBarItem(
//       //         icon: _buildIcon(Icons.message, isSelected: _currentIndex == 2),
//       //         label: "Chat",
//       //       ),
//       //       BottomNavigationBarItem(
//       //         icon: _buildIcon(Icons.person, isSelected: _currentIndex == 3),
//       //         label: "Profile",
//       //       ),
//       //     ],
//       //     showSelectedLabels: false,
//       //     showUnselectedLabels: false,
//       //     backgroundColor: Color(0xFF264E70),
//       //   ),
//       // ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.white,
//
//     child: BottomNavigationBar(
//       currentIndex: _currentIndex,
//       onTap: (index) {
//         setState(() {
//           _currentIndex = index;
//         });
//       },
//       items: const [
//         BottomNavigationBarItem(
//         icon: Icon(Icons.home), label: "Home"
//         ),
//         BottomNavigationBarItem(
//         icon: Icon(Icons.group), label: "Group"
//         ),
//         BottomNavigationBarItem(
//         icon: Icon(Icons.chat), label: "Chat"
//         ),
//         BottomNavigationBarItem(
//         icon: Icon(Icons.person), label: "Profile"
//         ),
//       ],
//
//       // items: const [
//       //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//       //   BottomNavigationBarItem(icon: Icon(Icons.group), label: "Group"),
//       //   BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
//       //   BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       // ],
//     ),
//     );
//   }
//
// //   Widget _buildIcon(IconData iconData, {required bool isSelected}) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         shape: BoxShape.rectangle,
// //         color: isSelected ? Colors.white : Color(0xFF264E70), // Background color for selected icon
// //       ),
// //       padding: EdgeInsets.all(8),
// //       child: Icon(
// //         iconData,
// //         color: isSelected ? Color(0xFF264E70) : Colors.white, // Icon color
// //         size: 28,
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'request_sent.dart';
// import 'homelander/home_page.dart';
//
// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     HomePage(),                     // Home page
//     RequestPage(),                  // Requests page
//     Center(child: Text('Messages')), // Messages placeholder
//     Center(child: Text('Profile')),  // Profile placeholder
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.black,
//         child: _pages[_currentIndex],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.white,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.group), label: "Request"),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'request_sent.dart';
// import 'homelander/home_page.dart';
// import 'homelander/community/Community_ui.dart'; // Your community page
//
// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   int _currentIndex = 0;
//
//   final Map<int, String> _routes = {
//     0: '/home',
//     1: '/request',
//     2: '/chat',
//     3: '/profile',
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Navigator(
//         onGenerateRoute: (settings) {
//           Widget page;
//           switch (_currentIndex) {
//             case 0:
//               page = HomePage();
//               break;
//             case 1:
//               page = RequestPage(); // Group or community UI page
//               break;
//             case 2:
//               page = Center(child: Text('Messages')); // Messages page placeholder
//               break;
//             case 3:
//               page = Center(child: Text('Profile')); // Profile page placeholder
//               break;
//             default:
//               page = HomePage();
//           }
//           return MaterialPageRoute(builder: (_) => page);
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.white,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.group), label: "Group"),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'request_sent.dart';
import 'homelander/home_page.dart';
import 'homelander/community/Community_ui.dart'; // Your community page

class MainPage extends StatefulWidget {
  final User?user;
  const MainPage({Key? key, this.user}) : super(key: key);

  //const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomePage(),
          RequestPage(),
          Center(child: Text('Messages')), // Messages page placeholder
          Center(child: Text('Profile')),  // Profile page placeholder
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Group"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}