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
import 'package:supabase_flutter/supabase_flutter.dart';
import '../all_feedback/app_feedback.dart';
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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;


  String searchQuery = '';

  Map<int, String> courseImages = {};

  bool isLoading = true;

  List<Map<String, dynamic>> exactMatches = [];

  List<Map<String, dynamic>> similarCourses = [];



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

        const FunChallengeScreen();

      } else if (_tabController.index == 3) {

        const AboutScreen();

      }

    });



    _fetchCourseImages();

  }

  // final List<Map<String, dynamic>> courseSections = [
  //   {
  //     "title": "Free Courses",
  //     "courses": [
  //       {"image": "assets/Quran.jpg", "title": "Quran Recitation", "isFree": true, "id": 1},
  //       {"image": "assets/python.jpg", "title": "Python", "isFree": true,"id": 2},
  //       {"image": "assets/digitalmarketing.jpeg", "title": "Digital Marketing", "isFree": true,"id": 6},
  //     ],
  //   },
  //   {
  //     "title": "Category-wise Courses",
  //     "categories": [
  //       {
  //         "category": "Programming",
  //         "courses": [
  //           {"image": "assets/python.jpg", "title": "Python", "isFree": true,"id":2},
  //           {"image": "assets/C.jpeg", "title": "C Programming", "isFree": false,"id":null},
  //           {"image": "assets/java.jpeg", "title": "Java Programming", "isFree": true, "id": 4}
  //         ],
  //       },
  //       {
  //         "category": "Web Development",
  //         "courses": [
  //           {"image": "assets/js.jpg", "title": "Frontend Basics", "isFree": true, "id": 5},
  //           {"image": "assets/react.jpeg", "title": "ReactJS", "isFree": false,"id":null},
  //           {"image": "assets/node.png", "title": "NodeJS", "isFree": true, "id": 3},
  //         ],
  //       },
  //     ],
  //   },
  //   {
  //     "title": "Paid Courses",
  //     "courses": [
  //       {"image": "assets/gd.jpeg", "title": "Graphics Design", "isFree": false,"id":null},
  //       {"image": "assets/leadership.jpeg", "title": "Leadership", "isFree": false,"id":null},
  //       {"image": "assets/singer.jpeg", "title": "Music", "isFree": false,"id":null},
  //     ],
  //   },
  // ];


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



  // void _checkSession() async {
  //   final session = Supabase.instance.client.auth.currentSession;
  //
  //   if (session != null) {
  //     // User is logged in
  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => CommunityUI(user: session.user)),
  //     // );
  //   //  CommunityUI(user: session.user);
  //     setState(() {
  //       _tabController.index = 1;
  //       CommunityUI(user: session.user);// Navigate to Community tab
  //     });
  //   } else {
  //     // User is not logged in
  //     //SignUpPage();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const SignUpPage()),
  //     );
  //
  //   }
  // }
  //

 // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 4, vsync: this);
  //
  //   // Tab navigation listeners
  //   _tabController.addListener(() {
  //     if (_tabController.index == 1) {
  //       // if(widget.user!=null){
  //       //   CommunityUI();
  //       // }else{
  //       //   SignUpPage();
  //       // }
  //       _checkSession();
  //
  //     } else if (_tabController.index == 2) {
  //       FunChallengeScreen();
  //     } else if (_tabController.index == 3) {
  //       AboutScreen();
  //     }
  //   });
  // }

  // void _openSignUpScreen() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const SignUpPage()),
  //   );
  // }

  // Widget _openFunChallengeScreen() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const FunChallengeScreen()),
  //   );
  //  // Navigator.pushReplacementNamed(context, '/home/funChallenge');
  // }

  // void _openAboutScreen() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const AboutScreen()),
  //   );
  // }


  // final List<Map<String, dynamic>> courseSections = [
  //   {
  //     "title": "Free Courses",
  //     "courses": [
  //       {"image": "assets/Quran.jpg", "title": "Quran Recitation", "isFree": true, "id": 1},
  //       {"image": "assets/python.jpg", "title": "Python", "isFree": true, "id": 2},
  //       {"image": "assets/digitalmarketing.jpeg", "title": "Digital Marketing", "isFree": true, "id": 6},
  //     ],
  //   },
  //   {
  //     "title": "Category-wise Courses",
  //     "categories": [
  //       {
  //         "category": "Programming",
  //         "courses": [
  //           {"image": "assets/python.jpg", "title": "Python", "isFree": true, "id": 2},
  //           {"image": "assets/C.jpeg", "title": "C Programming", "isFree": false, "id": null},
  //           {"image": "assets/java.jpeg", "title": "Java Programming", "isFree": true, "id": 4},
  //         ],
  //       },
  //       {
  //         "category": "Web Development",
  //         "courses": [
  //           {"image": "assets/js.jpg", "title": "Frontend Basics", "isFree": true, "id": 5},
  //           {"image": "assets/react.jpeg", "title": "ReactJS", "isFree": false, "id": null},
  //           {"image": "assets/node.png", "title": "NodeJS", "isFree": true, "id": 3},
  //         ],
  //       },
  //     ],
  //   },
  //   {
  //     "title": "Paid Courses",
  //     "courses": [
  //       {"image": "assets/gd.jpeg", "title": "Graphics Design", "isFree": false, "id": null},
  //       {"image": "assets/leadership.jpeg", "title": "Leadership", "isFree": false, "id": null},
  //       {"image": "assets/singer.jpeg", "title": "Music", "isFree": false, "id": null},
  //     ],
  //   },
  // ];

  // Replace the _searchCourses and _processCoursesForSearch methods with these updated versions:

  List<Map<String, dynamic>> _searchCourses(String query) {
    exactMatches = [];
    similarCourses = [];

    if (query.isEmpty) return [];

    // Create sets to track unique courses by title
    final Set<String> processedTitles = {};

    for (var section in courseSections) {
      if (section.containsKey("courses")) {
        _processCoursesForSearch(section["courses"], query, processedTitles);
      } else if (section.containsKey("categories")) {
        for (var category in section["categories"]) {
          _processCoursesForSearch(category["courses"], query, processedTitles);
        }
      }
    }

    return exactMatches.isNotEmpty ? exactMatches : similarCourses;
  }

  void _processCoursesForSearch(List<dynamic> courses, String query, Set<String> processedTitles) {
    for (var course in courses) {
      String courseTitle = course["title"].toString().toLowerCase();
      String searchQuery = query.toLowerCase();

      // Skip if we've already processed this course title
      if (processedTitles.contains(courseTitle)) {
        continue;
      }

      if (courseTitle == searchQuery || courseTitle.contains(searchQuery)) {
        exactMatches.add(course);
        processedTitles.add(courseTitle);
      } else if (_isSimilar(searchQuery, courseTitle)) {
        similarCourses.add(course);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // IconButton(
          //   icon: const Icon(Icons.settings, color: Colors.white),
          //   onPressed: () {
          //     Scaffold.of(context).openDrawer();
          //   },
          // ),
        ],
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
               // _buildCourseSections(),
                searchQuery.isEmpty
                    ? _buildCourseSections()
                    : _buildSearchResults(_searchCourses(searchQuery)),
               // const Center(child: Text("Community Section", style: TextStyle(color: Colors.white))),
                const CommunityUI(),
               // const Center(child: Text("Fun Challenge Section", style: TextStyle(color: Colors.white))),
                FunChallengeScreen(),
               // const Center(child: Text("About Section", style: TextStyle(color: Colors.white))),
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
                      image: course["id"] != null && courseImages.containsKey(course["id"])
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


  // Widget _buildCourseSections() {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: [
  //         for (var section in courseSections) ...[
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //             child: Align(
  //               alignment: Alignment.centerLeft,
  //               child: Text(
  //                 section["title"],
  //                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  //               ),
  //             ),
  //           ),
  //           if (section.containsKey("categories")) ...[
  //             for (var category in section["categories"]) ...[
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //                 child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text(
  //                     category["category"],
  //                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 220,
  //                 child: ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   itemCount: category["courses"].length,
  //                   itemBuilder: (context, index) {
  //                     final course = category["courses"][index];
  //                     return CourseCard(
  //                       image: course["image"],
  //                       title: course["title"],
  //                       isFree: course["isFree"],
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ] else ...[
  //             SizedBox(
  //               height: 220,
  //               child: ListView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 itemCount: section["courses"].length,
  //                 itemBuilder: (context, index) {
  //                   final course = section["courses"][index];
  //                   return CourseCard(
  //                     image: course["image"],
  //                     title: course["title"],
  //                     isFree: course["isFree"],
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         ],
  //       ],
  //     ),
  //   );
  // }


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


  // Widget _buildSettingsDrawer() {
  //   return Drawer(
  //     child: Container(
  //       color: Colors.black.withOpacity(0.5),
  //       child: ListView(
  //         padding: EdgeInsets.zero,
  //         children: [
  //           DrawerHeader(
  //             decoration: BoxDecoration(color: Colors.green.withOpacity(0.5)),
  //             child: const Text(
  //               'Settings',
  //               style: TextStyle(color: Colors.white, fontSize: 24),
  //             ),
  //           ),
  //           // Drawer options here
  //         ],
  //       ),
  //     ),
  //   );
  // }


  Widget _buildSettingsDrawer(BuildContext context) {
   // bool isDarkMode;
    return Drawer(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.5)),
              child: const Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),





            ListTile(
              leading: Icon(Icons.lock, color: Colors.white),
              title: Text('Change Password', style: TextStyle(color: Colors.white)),
              onTap: () {
              //  Navigator.pushNamed(context, '/change-password');
              },
            ),



            ListTile(
              leading: Icon(Icons.help_outline, color: Colors.white),
              title: Text('FAQ', style: TextStyle(color: Colors.white)),
              onTap: () {
             //   Navigator.pushNamed(context, '/faq');
              },
            ),


            ListTile(
              leading: Icon(Icons.feedback, color: Colors.white),
              title: Text('Send Feedback', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Redirect to feedback form
                FeedbackFormDialog.showFeedbackForm(context);

              },
            ),

            // Logout option
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
                  // Navigate to the login page after logout
                  Navigator.pushReplacementNamed(context, '/sign_up');
                } catch (e) {
                  print('Logout exception: $e');
                  // Optionally show a toast/snackbar for logout failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to log out. Please try again.')),
                  );
                }
              },
            ),

          ],
        ),
      ),
    );
  }


}

// class CourseCard extends StatelessWidget {
//   final String image;
//   final String title;
//   final bool isFree;
//
//   const CourseCard({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.isFree,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0, right: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 100,
//             height: 120,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               image: DecorationImage(
//                 image: AssetImage(image),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: const TextStyle(color: Colors.white, fontSize: 12),
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             isFree ? "Free" : "Paid",
//             style: TextStyle(color: isFree ? Colors.green : Colors.red, fontSize: 10),
//           ),
//         ],
//       ),
//     );
//   }
// }
//


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

























// gpt code


// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../login.dart';
// import 'about_us.dart';
// import '../sign_up.dart';
// import 'community/Community_ui.dart';
// import 'fun_challenge.dart';
//
// class HomePage extends StatefulWidget {
//   final User? user;
//
//   const HomePage({Key? key, this.user}) : super(key: key);
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool isLoading = true;
//   List<dynamic> courses = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//
//     // Tab navigation listeners
//     _tabController.addListener(() {
//       if (_tabController.index == 1) {
//         _checkSession();
//       } else if (_tabController.index == 2) {
//         FunChallengeScreen();
//       } else if (_tabController.index == 3) {
//         AboutScreen();
//       }
//     });
//
//     fetchCourses();
//   }
//
//   Future<void> fetchCourses() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       final response = await Supabase.instance.client
//           .from('course')
//           .select('id, thumbnail_image, title, description, is_free')
//           .execute();
//
//       if (response.error == null) {
//         setState(() {
//           courses = response.data as List<dynamic>;
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error fetching courses: ${response.error!.message}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $e')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void _checkSession() async {
//     final session = Supabase.instance.client.auth.currentSession;
//
//     if (session != null) {
//       setState(() {
//         _tabController.index = 1;
//         CommunityUI(user: session.user);
//       });
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const SignUpPage()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 2,
//         title: const TextField(
//           decoration: InputDecoration(
//             hintText: "Search courses...",
//             hintStyle: TextStyle(color: Colors.white54),
//             border: InputBorder.none,
//           ),
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       drawer: _buildSettingsDrawer(context),
//       body: Column(
//         children: [
//           Container(
//             color: Colors.black,
//             child: TabBar(
//               controller: _tabController,
//               labelColor: Colors.green,
//               unselectedLabelColor: Colors.white,
//               indicatorColor: Colors.green,
//               tabs: const [
//                 Tab(text: "Suggested for You"),
//                 Tab(text: "Community"),
//                 Tab(text: "Fun Challenge"),
//                 Tab(text: "About"),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildCourseSections(),
//                 const CommunityUI(),
//                 FunChallengeScreen(),
//                 const AboutScreen()
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCourseSections() {
//     if (isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(color: Colors.green),
//       );
//     }
//
//     if (courses.isEmpty) {
//       return const Center(
//         child: Text("No courses available", style: TextStyle(color: Colors.white)),
//       );
//     }
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Suggested Courses",
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 220,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: courses.length,
//               itemBuilder: (context, index) {
//                 final course = courses[index];
//                 return CourseCard(
//                   image: course['thumbnail_image'] ?? 'assets/default_image.jpg',
//                   title: course['title'] ?? 'No Title',
//                   isFree: course['is_free'] ?? false,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSettingsDrawer(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: Colors.black.withOpacity(0.5),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.green.withOpacity(0.5)),
//               child: const Text(
//                 'Settings',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.white),
//               title: const Text('Logout', style: TextStyle(color: Colors.white)),
//               onTap: () async {
//                 try {
//                   await Supabase.instance.client.auth.signOut();
//                   Navigator.pushReplacementNamed(context, '/sign_up');
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Failed to log out. Please try again.')),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// extension on PostgrestFilterBuilder<PostgrestList> {
//   execute() {}
// }
//
// class CourseCard extends StatelessWidget {
//   final String image;
//   final String title;
//   final bool isFree;
//
//   const CourseCard({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.isFree,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16.0, right: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 100,
//             height: 120,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               image: DecorationImage(
//                 image: NetworkImage(image),
//                 fit: BoxFit.cover,
//                 onError: (_, __) => AssetImage('assets/default_image.jpg'),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: const TextStyle(color: Colors.white, fontSize: 12),
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             isFree ? "Free" : "Paid",
//             style: TextStyle(color: isFree ? Colors.green : Colors.red, fontSize: 10),
//           ),
//         ],
//       ),
//     );
//   }
// }
