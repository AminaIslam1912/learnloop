import 'package:flutter/material.dart';
import 'package:learnloop/homelander/faq_screen.dart';
import 'package:marquee/marquee.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../all_feedback/app_feedback.dart';
import '../all_feedback/progress_tracker.dart';
import 'about_us.dart';
import '../sign_up.dart';
import 'community/Community_ui.dart';
import 'fun_challenge.dart';
import 'dynamic_screen.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({Key? key, this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int? _userId;

  String searchQuery = '';

  Map<int, String> courseImages = {};

  bool isLoading = true;

  List<Map<String, dynamic>> exactMatches = [];

  List<Map<String, dynamic>> similarCourses = [];

  List<Map<String, dynamic>> savedCourses = [];

  Widget _buildSavedCourses() {
    if (savedCourses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No saved courses yet.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: savedCourses.length,
      itemBuilder: (context, index) {
        final course = savedCourses[index];
        return Dismissible(
          key: Key(course["id"].toString()),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) async {
            final user = Supabase.instance.client.auth.currentUser;
            if (user != null) {
              try {
                // Fetch current saved courses from Supabase
                final response = await Supabase.instance.client
                    .from('users')
                    .select('saved_courses')
                    .eq('id', user.id)
                    .single();

                if (response != null && response['saved_courses'] != null) {
                  List<int> currentSavedCourses = List<int>.from(response['saved_courses']);
                  currentSavedCourses.remove(course["id"]);

                  // Update saved_courses in Supabase
                  await Supabase.instance.client
                      .from('users')
                      .update({'saved_courses': currentSavedCourses.cast<int>()})
                      .eq('id', user.id);

                  setState(() {
                    savedCourses.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${course["title"]} deleted successfully."),
                      backgroundColor: Colors.white,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (error) {
                debugPrint('Error removing course: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error removing course. Please try again.'),
                    backgroundColor: Colors.green
                    ,
                  ),
                );
              }
            }
          },
          child: InkWell(
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
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundImage: course["id"] != null && courseImages.containsKey(course["id"])
                      ? NetworkImage(courseImages[course["id"]]!)
                      : AssetImage(course["image"]) as ImageProvider,
                ),
                title: Text(
                  course["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  course["isFree"] ? "Free" : "Paid",
                  style: TextStyle(
                    color: course["isFree"] ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Future<bool> _isUserLoggedIn() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null;
  }

  void _handleSaveCourse(BuildContext context, Map<String, dynamic> course) async {
    if (await _isUserLoggedIn()) {
      // Check if the course is already saved locally
      if (!savedCourses.any((savedCourse) => savedCourse["id"] == course["id"])) {
        setState(() {
          savedCourses.add(course); // Add course to the local list
        });
      } else {
        // Notify the user if the course is already saved
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${course["title"]} is already saved!')),
        );
      }
    } else {
      // If the user is not logged in, prompt them to log in
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Login Required',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'You need to log in to save courses. Would you like to log in now?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushReplacementNamed(context, '/login').then((value) async {
                    // Check if the user is logged in after returning from the login page
                    if (await _isUserLoggedIn()) {
                      _handleSaveCourse(context, course); // Retry saving the course
                    }
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }
  Future<void> _fetchSavedCourses() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('users')
            .select('saved_courses')
            .eq('sup_id', user.id)
            .single();

        if (response != null && response['saved_courses'] != null) {
          final savedCourseIds = List<int>.from(response['saved_courses']);

          // Fetch course details for each saved course ID
          final coursesResponse = await Supabase.instance.client
              .from('course')
              .select('*')
              .inFilter('id', savedCourseIds);

          setState(() {
            savedCourses = List<Map<String, dynamic>>.from(coursesResponse);
          });
        }
      }
    } catch (error) {
      debugPrint('Error fetching saved courses: $error');
    }
  }

  Future<void> onSaveAndWatchLater(int courseId, String courseTitle) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select('saved_courses')
            .eq('sup_id', user.id)
            .single();

        List<int> currentSavedCourses = [];
        if (response != null && response['saved_courses'] != null) {
          currentSavedCourses = List<int>.from(response['saved_courses']);
        }

        if (!currentSavedCourses.contains(courseId)) {
          currentSavedCourses.add(courseId);

          await Supabase.instance.client
              .from('users')
              .update({'saved_courses': currentSavedCourses})
              .eq('sup_id', user.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$courseTitle saved successfully!')),
          );
          debugPrint("Course ID: $courseId saved successfully!");
          _fetchSavedCourses(); // Refresh saved courses list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$courseTitle is already saved!')),
          );
        }
      } catch (error) {
       // debugPrint('');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course saved successfully!')),
        );
      }
    }
  }


   Future<void> _fetchCourseImages() async {

    try {

      final data = await Supabase.instance.client

          .from('course')

          .select('id, course_image');



      setState(() {

        for (final course in data) {
           
               
               
          courseImages[course['id']] = course['course_image'];
        }

        isLoading = false;
      });
    } catch (error) {
      debugPrint("Error fetching courses: $error");

      setState(() {
        isLoading = false;
      });
    }
  }

  void _checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      setState(() {
        _tabController.index = 1;

        CommunityUI(user: session.user);
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);


    _tabController.addListener(() {
      if (_tabController.index == 1) {
        _checkSession();
      } else if (_tabController.index == 2) {
        final session = Supabase.instance.client.auth.currentSession;
        if(session!=null)
          FunChallengeScreen();
        else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignUpPage()),
          );
        }
      } else if (_tabController.index == 3) {
        const AboutScreen();
      }
    });

    _fetchSavedCourses();

    _fetchCourseImages();
  }

  final List<Map<String, dynamic>> courseSections = [
    {
      "title": "Free Courses",
      "courses": [
        {
          "image": "assets/Quran.jpg",
          "title": "Quran Recitation",
          "isFree": true,
          "id": 1
        },
        {
          "image": "assets/python.jpg",
          "title": "Python",
          "isFree": true,
          "id": 2
        },
        {
          "image": "assets/digitalmarketing.jpeg",
          "title": "Digital Marketing",
          "isFree": true,
          "id": 6
        },
        {"title": "Cooking", "isFree": true, "id": 12},
        {"title": "Swimming", "isFree": true, "id": 16},
        {"title": "Problem Solving", "isFree": true, "id": 17},
      ],
    },
    {
      "title": "Category-wise Courses",
      "categories": [
        {
          "category": "Programming",
          "courses": [
            {
              "image": "assets/python.jpg",
              "title": "Python",
              "isFree": true,
              "id": 2
            },
            {
              "image": "assets/C.jpeg",
              "title": "C Programming",
              "isFree": false,
              "id": 7
            },
            {
              "image": "assets/java.jpeg",
              "title": "Java Programming",
              "isFree": true,
              "id": 4
            },
            {"title": "Assembly Language", "isFree": true, "id": 13},
            {"title": "Ruby", "isFree": true, "id": 18},
            {"title": "Rust", "isFree": true, "id": 19},
          ],
        },
        {
          "category": "Web Development",
          "courses": [
            {
              "image": "assets/js.jpg",
              "title": "Frontend Basics",
              "isFree": true,
              "id": 5
            },
            {
              "image": "assets/react.jpeg",
              "title": "ReactJS",
              "isFree": false,
              "id": 8
            },
            {
              "image": "assets/node.png",
              "title": "NodeJS",
              "isFree": true,
              "id": 3
            },
            {"title": "MongoDB", "isFree": true, "id": 14},
            {"title": "Javascipt DOM", "isFree": true, "id": 20},
            {"title": "PHP With Laravel", "isFree": true, "id": 21},
          ],
        },
      ],
    },
    {
      "title": "Paid Courses",
      "courses": [
        {
          "image": "assets/gd.jpeg",
          "title": "Graphics Design",
          "isFree": false,
          "id": 9
        },
        {
          "image": "assets/leadership.jpeg",
          "title": "Leadership",
          "isFree": false,
          "id": 10
        },
        {
          "image": "assets/singer.jpeg",
          "title": "Music",
          "isFree": false,
          "id": 11
        },
        {"title": "Microsoft Bundle", "isFree": false, "id": 15},
        {"title": "Time Management", "isFree": false, "id": 22},
        {"title": "Communication", "isFree": false, "id": 23},
      ],
    },
  ];

  List<Map<String, dynamic>> _searchCourses(String query) {
    exactMatches = [];
    similarCourses = [];

    if (query.isEmpty) return [];

    final Set<String> processedTitles = {};

    for (var section in courseSections) {
      if (section.containsKey("courses")) {
        _processCoursesForSearch(
            section["courses"] as List<dynamic>, query, processedTitles);
      } else if (section.containsKey("categories")) {
        for (var category in section["categories"] as List<dynamic>) {
          _processCoursesForSearch(
              category["courses"] as List<dynamic>, query, processedTitles);
        }
      }
    }
    if (exactMatches.isNotEmpty) {
      return exactMatches;
    } else if (similarCourses.isNotEmpty) {
      return similarCourses;
    } else {
      return _getSuggestedCourses();
    }
  }

  void _processCoursesForSearch(
      List<dynamic> courses, String query, Set<String> processedTitles) {
    for (var course in courses) {
      String courseTitle = course["title"].toString().toLowerCase();
      String searchQuery = query.toLowerCase();
      if (processedTitles.contains(courseTitle)) {
        continue;
      }

      if (courseTitle == searchQuery || courseTitle.contains(searchQuery)) {
        exactMatches.add(Map<String, dynamic>.from(course));
        processedTitles.add(courseTitle);
      } else if (_isSimilar(searchQuery, courseTitle)) {
        similarCourses.add(Map<String, dynamic>.from(course));
        processedTitles.add(courseTitle);
      }
    }
  }

  bool _isSimilar(String query, String title) {
    int distance = _levenshteinDistance(query, title);
    return distance <= query.length ~/ 2;
  }

  int _levenshteinDistance(String s1, String s2) {
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<List<int>> matrix = List.generate(
      s1.length + 1,
      (i) => List.generate(s2.length + 1, (j) => 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((curr, next) => curr < next ? curr : next);
      }
    }

    return matrix[s1.length][s2.length];
  }

  List<Map<String, dynamic>> _getSuggestedCourses() {
    return [
      {"title": "Introduction to Programming", "id": 1},
      {"title": "Data Structures and Algorithms", "id": 2},
      {"title": "Machine Learning Basics", "id": 3},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: TextField(
          decoration: const InputDecoration(
            labelText: "Search courses...",
            labelStyle: const TextStyle(
              color: Colors.green,
            ),
            prefixIcon: const Icon(Icons.search,
                color: Colors.green),

            hintStyle: TextStyle(color: Colors.green),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          cursorColor: Colors.green,
        ),
        actions: [],
      ),
      drawer: _buildSettingsDrawer(context),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.green,
              tabs: [
                Tab(
                  child: Marquee(
                    blankSpace: 25,
                    text: "Suggested for You",
                    style: TextStyle(color: Colors.green), // Text style
                    velocity: 15,
                    pauseAfterRound:
                        Duration(seconds: 2),
                  ),
                ),
                Tab(
                  child: Marquee(
                    text: "Community",
                    blankSpace: 72,
                    style: TextStyle(color: Colors.green),
                    velocity: 15,
                    pauseAfterRound: Duration(seconds: 2),
                  ),
                ),
                Tab(
                  child: Marquee(
                    text: "Fun Challenge",
                    blankSpace: 72,
                    style: const TextStyle(color: Colors.green),
                    velocity: 15,
                    pauseAfterRound: Duration(seconds: 2),
                  ),
                ),
                Tab(
                  child: Marquee(
                    text: "About",
                    blankSpace: 72,
                    style: TextStyle(color: Colors.green),
                    velocity: 15,
                    pauseAfterRound: Duration(seconds: 4),
                    // scrollAxis: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                searchQuery.isEmpty
                    ? _buildCourseSections()
                    : _buildSearchResults(_searchCourses(searchQuery)),
                const CommunityUI(),
                FunChallengeScreen(),
                const AboutScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No courses found',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (exactMatches.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Exact Matches',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ..._buildCourseList(exactMatches),
          ],
          if (similarCourses.isNotEmpty && exactMatches.isEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Similar Courses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ..._buildCourseList(similarCourses),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildCourseList(List<Map<String, dynamic>> courses) {
    return courses.map((course) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: InkWell(
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    image: DecorationImage(
                      image: course["id"] != null &&
                              courseImages.containsKey(course["id"])
                          ? NetworkImage(courseImages[course["id"]]!)
                          : AssetImage(course["image"]) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course["title"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course["isFree"] ? "Free" : "Paid",
                          style: TextStyle(
                            color: course["isFree"] ? Colors.green : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildCourseSections() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var section in courseSections) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  section["title"],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            if (section.containsKey("categories")) ...[
              for (var category in section["categories"]) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      category["category"],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
                                builder: (context) =>
                                    DynamicScreen(courseId: course["id"]!),
                              ),
                            );
                          }
                        },
                        child: CourseCard(
                          image: course["id"] != null &&
                                  courseImages.containsKey(course["id"])
                              ? courseImages[course["id"]]!
                              : course["image"],
                          title: course["title"],
                          isFree: course["isFree"],
                          useNetworkImage: course["id"] != null &&
                              courseImages.containsKey(course["id"]),
                          course: course,
                         onSaveAndWatchLater: () {
                              onSaveAndWatchLater(course["id"], course["title"]);
                              _handleSaveCourse(context, course);
                            },
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
                              builder: (context) =>
                                  DynamicScreen(courseId: course["id"]!),
                            ),
                          );
                        }
                      },
                      child: CourseCard(
                        image: course["id"] != null &&
                                courseImages.containsKey(course["id"])
                            ? courseImages[course["id"]]!
                            : course["image"],
                        title: course["title"],
                        isFree: course["isFree"],
                        useNetworkImage: course["id"] != null &&
                            courseImages.containsKey(course["id"]),
                        course: course,
                       onSaveAndWatchLater: () {
                          onSaveAndWatchLater(course["id"], course["title"]);
                          _handleSaveCourse(context, course);
                        },
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

  Widget _buildSettingsDrawer(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 120,
                child: DrawerHeader(
                  decoration:
                      BoxDecoration(color: Colors.green.withOpacity(0.5)),
                  child: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.developer_board, color: Colors.white),
                title: Text('Progress Tracker',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProgressTracker(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: Colors.white),
                title: Text('FAQ', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.feedback, color: Colors.white),
                title: Text('Send Feedback',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  FeedbackFormDialog.showFeedbackForm(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark, color: Colors.white),
                title: const Text('Saved Courses',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) => _buildSavedCourses(),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  try {
                    await Supabase.instance.client.auth.signOut();
                    print('Logged out successfully');
                     Navigator.pushReplacementNamed(context, '/sign_up');
                  } catch (e) {
                    print('Logout exception: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Failed to log out. Please try again.')),
                    );
                  }
                },
              ),
            ],
          ),
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
  final VoidCallback onSaveAndWatchLater;
  final Map<String, dynamic> course;

  const CourseCard({
    super.key,
    required this.image,
    required this.title,
    required this.isFree,
    this.useNetworkImage = false,
    required this.onSaveAndWatchLater,
    required this.course,
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
                image: useNetworkImage
                    ? NetworkImage(image)
                    : AssetImage(image) as ImageProvider,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                isFree ? "Free" : "Paid",
                style: TextStyle(
                  color: isFree ? Colors.green : Colors.red,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 55),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Save and Watch Later') {
                    onSaveAndWatchLater();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Save and Watch Later',
                    child: Text('Save and Watch Later'),
                  ),
                ],
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

