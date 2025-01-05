import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../login.dart';
import 'about_us.dart';
import '../sign_up.dart';
import 'community/Community_ui.dart';
import 'fun_challenge.dart';
import 'dynamic_screen.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({Key? key, this.user}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';
  Map<int, String> courseImages = {};
  bool isLoading = true;

  Future<void> _fetchCourseImages() async {
    try {
      final data = await Supabase.instance.client
          .from('course')
          .select('id, course_image');

      if (mounted) {
        setState(() {
          for (final course in data) {
            courseImages[course['id']] = course['course_image'];
          }
          isLoading = false;
        });
      }
    } catch (error) {
      debugPrint("Error fetching courses: $error");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _checkSession() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;

      if (session != null) {
        if (mounted) {
          setState(() {
            _tabController.index = 1;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommunityUI(user: session.user),
            ),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      }
    } catch (e) {
      debugPrint("Error checking session: $e");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    }
  }

  final List<Map<String, dynamic>> courseSections = [
    {
      "title": "Free Courses",
      "courses": [
        {"image": "assets/Quran.jpg", "title": "Quran Recitation", "isFree": true, "id": 1},
        {"image": "assets/python.jpg", "title": "Python", "isFree": true, "id": 2},
        {"image": "assets/digitalmarketing.jpeg", "title": "Digital Marketing", "isFree": true, "id": 6},
      ],
    },
    {
      "title": "Category-wise Courses",
      "categories": [
        {
          "category": "Programming",
          "courses": [
            {"image": "assets/python.jpg", "title": "Python", "isFree": true, "id": 2},
            {"image": "assets/C.jpeg", "title": "C Programming", "isFree": false, "id": null},
            {"image": "assets/java.jpeg", "title": "Java Programming", "isFree": true, "id": 4},
          ],
        },
        {
          "category": "Web Development",
          "courses": [
            {"image": "assets/js.jpg", "title": "Frontend Basics", "isFree": true, "id": 5},
            {"image": "assets/react.jpeg", "title": "ReactJS", "isFree": false, "id": null},
            {"image": "assets/node.png", "title": "NodeJS", "isFree": true, "id": 3},
          ],
        },
      ],
    },
    {
      "title": "Paid Courses",
      "courses": [
        {"image": "assets/gd.jpeg", "title": "Graphics Design", "isFree": false, "id": null},
        {"image": "assets/leadership.jpeg", "title": "Leadership", "isFree": false, "id": null},
        {"image": "assets/singer.jpeg", "title": "Music", "isFree": false, "id": null},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchCourseImages();

    _tabController.addListener(() {
      if (_tabController.index == 1) {
        _checkSession();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _searchCourses(String query) {
    List<Map<String, dynamic>> matchingCourses = [];
    List<Map<String, dynamic>> relevantCourses = [];

    for (var section in courseSections) {
      if (section.containsKey("categories")) {
        for (var category in section["categories"]) {
          for (var course in category["courses"]) {
            if (course["title"].toLowerCase().contains(query.toLowerCase())) {
              matchingCourses.add(course);
            } else if (query.isNotEmpty) {
              relevantCourses.add(course);
            }
          }
        }
      } else {
        for (var course in section["courses"]) {
          if (course["title"].toLowerCase().contains(query.toLowerCase())) {
            matchingCourses.add(course);
          } else if (query.isNotEmpty) {
            relevantCourses.add(course);
          }
        }
      }
    }

    return matchingCourses.isNotEmpty ? matchingCourses : relevantCourses;
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = _searchCourses(searchQuery);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Search courses...",
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
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
      body: searchQuery.isNotEmpty
          ? _buildSearchResults(searchResults)
          : Column(
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
                const CommunityUI(),
                FunChallengeScreen(),
                const AboutScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    return SingleChildScrollView(
      child: Column(
        children: results.map((course) {
          return InkWell(
            onTap: () {
              if (course["id"] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DynamicScreen(courseId: course["id"]!),
                  ),
                );
              }
            },
            child: CourseCard(
              image: course["id"] != null && courseImages.containsKey(course["id"])
                  ? courseImages[course["id"]]!
                  : course["image"],
              title: course["title"],
              isFree: course["isFree"],
              useNetworkImage: course["id"] != null && courseImages.containsKey(course["id"]),
            ),
          );
        }).toList(),
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
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
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
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
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
                      return InkWell(
                        onTap: () {
                          if (course["id"] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DynamicScreen(courseId: course["id"]!),
                              ),
                            );
                          }
                        },
                        child: CourseCard(
                          image: course["id"] != null && courseImages.containsKey(course["id"])
                              ? courseImages[course["id"]]!
                              : course["image"],
                          title: course["title"],
                          isFree: course["isFree"],
                          useNetworkImage: course["id"] != null && courseImages.containsKey(course["id"]),
                        ),
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
                    return InkWell(
                      onTap: () {
                        if (course["id"] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DynamicScreen(courseId: course["id"]!),
                            ),
                          );
                        }
                      },
                      child: CourseCard(
                        image: course["id"] != null && courseImages.containsKey(course["id"])
                            ? courseImages[course["id"]]!
                            : course["image"],
                        title: course["title"],
                        isFree: course["isFree"],
                        useNetworkImage: course["id"] != null && courseImages.containsKey(course["id"]),
                      ),
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
  final bool useNetworkImage;

  const CourseCard({
    super.key,
    required this.image,
    required this.title,
    required this.isFree,
    this.useNetworkImage = false,
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
                image: useNetworkImage ? NetworkImage(image) : AssetImage(image) as ImageProvider,
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  debugPrint('Error loading image: $exception');
                },
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