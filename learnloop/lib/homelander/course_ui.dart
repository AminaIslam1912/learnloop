import 'package:flutter/material.dart';
import 'Signup_page.dart';
import 'about.dart'; // Import the About screen
import 'funchallenge.dart'; // Import the Fun Challenge screen
// Import the Login screen

class CourseUI extends StatefulWidget {
  const CourseUI({super.key});

  @override
  _CourseUIState createState() => _CourseUIState();
}

class _CourseUIState extends State<CourseUI> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Add listener to detect tab changes
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: const Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search courses...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
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

class CourseCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isFree;

  const CourseCard({super.key,
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
