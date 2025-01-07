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
import '../login.dart';
import 'about_us.dart';
import '../sign_up.dart';
import 'community/Community_ui.dart';
import 'fun_challenge.dart';


import 'package:flutter/material.dart';

// void showFeedbackForm(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           double _rating = 0;
//           TextEditingController _feedbackController = TextEditingController();
//
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Feedback Form",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     "Rate Us",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       return IconButton(
//                         icon: Icon(
//                           index < _rating ? Icons.star : Icons.star_border,
//                           color: Colors.amber,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _rating = index + 1.0;
//                           });
//                         },
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _feedbackController,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       hintText: "Write your feedback here...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                     ),
//                     onPressed: () {
//                       String feedback = _feedbackController.text.trim();
//                       print("Rating: $_rating");
//                       print("Feedback: $feedback");
//
//                       Navigator.pop(context); // Close the dialog
//                     },
//                     child: const Text("Submit"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }

//add this
void showFeedbackForm(BuildContext context) {
  double _rating = 0; // Declare _rating outside of StatefulBuilder
  TextEditingController _feedbackController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Feedback Our App",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Rate Us",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1.0; // Update rating on click
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Write your feedback here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      String feedback = _feedbackController.text.trim();
                      print("Rating: $_rating");
                      print("Feedback: $feedback");

                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
//end



class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({Key? key, this.user}) : super(key: key);
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


  void _checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // User is logged in
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => CommunityUI(user: session.user)),
      // );
    //  CommunityUI(user: session.user);
      setState(() {
        _tabController.index = 1;
        CommunityUI(user: session.user);// Navigate to Community tab
      });
    } else {
      // User is not logged in
      //SignUpPage();
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

    // Tab navigation listeners
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        // if(widget.user!=null){
        //   CommunityUI();
        // }else{
        //   SignUpPage();
        // }
        _checkSession();

      } else if (_tabController.index == 2) {
        FunChallengeScreen();
      } else if (_tabController.index == 3) {
        AboutScreen();
      }
    });
  }

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
                _buildCourseSections(),
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
                showFeedbackForm(context);
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
