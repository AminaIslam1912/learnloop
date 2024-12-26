import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {
//               Scaffold.of(context).openDrawer(); // Opens the settings drawer
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/background_app.png'), // Background image
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: const Text(
//             'Welcome to Home Page',
//             style: TextStyle(
//               fontSize: 24,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       drawer: _buildSettingsDrawer(),
//     );
//   }
//
//   Widget _buildSettingsDrawer() {
//     return Drawer(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.black.withOpacity(0.5), // Transparent color
//         ),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue.withOpacity(0.7), // Semi-transparent header
//               ),
//               child: const Text(
//                 'Settings',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.person, color: Colors.white),
//               title: const Text('Personal Details', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 // Handle Personal Details navigation
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.group, color: Colors.white),
//               title: const Text('Community', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 // Handle Community navigation
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.notifications, color: Colors.white),
//               title: const Text('Notifications', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 // Handle Notifications navigation
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.schedule, color: Colors.white),
//               title: const Text('Time Table', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 // Handle Time Table navigation
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.history, color: Colors.white),
//               title: const Text('History', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 // Handle History navigation
//               },
//             ),
//             SwitchListTile(
//               title: const Text('Theme', style: TextStyle(color: Colors.white)),
//               value: false,
//               onChanged: (value) {
//                 // Handle theme toggle
//               },
//               activeColor: Colors.white,
//             ),
//             const Divider(color: Colors.white), // Divider color adjusted for visibility
//             ListTile(
//               leading: const Icon(Icons.help, color: Colors.white),
//               title: const Text('Help and Feedback', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 // Handle Help navigation
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.white),
//               title: const Text('Log Out', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 // Handle Log Out
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'about_us.dart';
import '../sign_up.dart';
import 'fun_challenge.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> courseSections = [
    {
      "title": "Free Courses",
      "courses": [
        {"image": "assets/Quran.jpg", "title": "Quran Recitation", "isFree": true},
        {"image": "assets/python.jpg", "title": "Python", "isFree": true},
        {"image": "assets/digitalmarketing.jpeg", "title": "Digital Marketing", "isFree": true},
      ],
    },
    {
      "title": "Category-wise Courses",
      "categories": [
        {
          "category": "Programming",
          "courses": [
            {"image": "assets/python.jpg", "title": "Python", "isFree": true},
            {"image": "assets/C.jpeg", "title": "C Programming", "isFree": false},
            {"image": "assets/java.jpeg", "title": "Java Programming", "isFree": true}
          ],
        },
        {
          "category": "Web Development",
          "courses": [
            {"image": "assets/js.jpg", "title": "Frontend Basics", "isFree": true},
            {"image": "assets/react.jpeg", "title": "ReactJS", "isFree": false},
            {"image": "assets/node.png", "title": "NodeJS", "isFree": false},
          ],
        },
      ],
    },
    {
      "title": "Paid Courses",
      "courses": [
        {"image": "assets/gd.jpeg", "title": "Graphics Design", "isFree": false},
        {"image": "assets/leadership.jpeg", "title": "Leadership", "isFree": false},
        {"image": "assets/singer.jpeg", "title": "Music", "isFree": false},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Tab navigation listeners
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        _openSignUpScreen();
      } else if (_tabController.index == 2) {
        _openFunChallengeScreen();
      } else if (_tabController.index == 3) {
        _openAboutScreen();
      }
    });
  }

  void _openSignUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  void _openFunChallengeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FunChallengeScreen()),
    );
  }

  void _openAboutScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: const TextField(
          decoration: InputDecoration(
            hintText: "Search courses...",
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      drawer: _buildSettingsDrawer(),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.green,
              tabs: const [
                Tab(text: "Suggested for You"),
                Tab(text: "Community"),
                Tab(text: "Fun Challenge"),
                Tab(text: "About"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCourseSections(),
                const Center(child: Text("Community Section", style: TextStyle(color: Colors.white))),
                const Center(child: Text("Fun Challenge Section", style: TextStyle(color: Colors.white))),
                const Center(child: Text("About Section", style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseSections() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var section in courseSections) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  section["title"],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            if (section.containsKey("categories")) ...[
              for (var category in section["categories"]) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      category["category"],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: category["courses"].length,
                    itemBuilder: (context, index) {
                      final course = category["courses"][index];
                      return CourseCard(
                        image: course["image"],
                        title: course["title"],
                        isFree: course["isFree"],
                      );
                    },
                  ),
                ),
              ],
            ] else ...[
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: section["courses"].length,
                  itemBuilder: (context, index) {
                    final course = section["courses"][index];
                    return CourseCard(
                      image: course["image"],
                      title: course["title"],
                      isFree: course["isFree"],
                    );
                  },
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsDrawer() {
    return Drawer(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.7)),
              child: const Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            // Drawer options here
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isFree;

  const CourseCard({
    super.key,
    required this.image,
    required this.title,
    required this.isFree,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            isFree ? "Free" : "Paid",
            style: TextStyle(color: isFree ? Colors.green : Colors.red, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
