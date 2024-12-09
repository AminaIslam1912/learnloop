import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'EditProfile.dart';
import 'FullScreenImage.dart';
import 'Skill.dart';
import 'UserFeedback.dart';

/*
class UserProfile extends StatefulWidget {
  final String loggedInUserId; // Pass the authenticated user's ID
  final String profileUserId; // The profile's owner ID

  const UserProfile({super.key, required this.loggedInUserId, required this.profileUserId});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = "Jack Sparrow";
  String email = "mrittikasaigal@gmail.com";
  String profilePicture = "assets/moha.jpg";
  bool isEditMode = false;
  bool isLoading = false;
  bool get isOwner => widget.loggedInUserId == widget.profileUserId; // Check ownership
  String bio = "Passionate Learner";

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch email client.")),
      );
    }
  }
  double rating = 4.0; // Default rating
  List<String> skills = ["Dart", "Flutter","React", "UI/UX Design", "Python", "Java"]; // Default skills

  // Navigate to the skills edit page
  void _editSkills() async {
    final updatedSkills = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillsEditPage(skills: List<String>.from(skills)),
      ),
    );

    if (updatedSkills != null) {
      setState(() {
        skills = updatedSkills;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: Colors.blue,
      ),
      body:


        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center, // Align children to the left

            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imagePath: profilePicture,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(profilePicture),

                      ),
                    ),
                  ),


                  Column(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                              icon: Icon(
                                index < rating ? Icons.star : Icons.star_border,
                                color: Colors.yellow[700],
                              ),
                              onPressed: null // Only owner can change rating
                          );
                        }),
                      ),
                      Text(bio),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16),

              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton.icon(
                        icon: const Icon(Icons.swap_vert_circle),
                        label: const Text(
                          'Swap',
                          style: TextStyle(color: Colors.black, fontSize: 13.0),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(150, 40),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextButton.icon(
                        icon: Icon(Icons.message),
                        label: const Text(
                          'Message',
                          style: TextStyle(color: Colors.black, fontSize: 13.0),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(150, 40),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 10),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 1, child: Text("Profile")),
                        const PopupMenuItem(value: 2, child: Text("Account")),
                        const PopupMenuItem(value: 3, child: Text("Settings")),
                        const PopupMenuItem(value: 4, child: Text("About GFG")),
                        const PopupMenuItem(value: 5, child: Text("Go Premium")),
                        const PopupMenuItem(value: 6, child: Text("Logout")),
                      ],
                    ),
                  ],
                ),


              GestureDetector(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: email));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email copied to clipboard!")),
                  );
                },
                onTap: () => _launchEmail(email),
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          email,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),



              //if(!isEditMode)

              const SizedBox(height: 16),

              // Skills Section
              const Text(
                "Skills",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
                children: [
                  Wrap(
                    spacing: 5,
                    runSpacing: 5, // Add spacing between rows of chips
                    children: skills
                        .take(3) // Show a preview of the first 3 skills
                        .map(
                          (skill) => Chip(
                        label: Text(skill),
                        backgroundColor: Colors.greenAccent[100],
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: 10), // Add some space between chips and the button
                  Align(
                    alignment: Alignment.centerLeft, // Align the button to the start of the column
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SkillsDetailPage(
                              skills: List<String>.from(skills),
                              isOwner: isOwner,
                            ),
                          ),
                        );
                      },
                      child: const Text("View All Skills"),
                    ),
                  ),
                ],
              ),


              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserFeedback(

                            ),
                          ),
                        );
                      },
                      child: Text("Feedback"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    //);
  }
}

 */

class UserProfile extends StatefulWidget {
  final String loggedInUserId; // Pass the authenticated user's ID
  final String profileUserId; // The profile's owner ID

  const UserProfile(
      {super.key, required this.loggedInUserId, required this.profileUserId});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  String name = "Jack Sparrow";
  String email = "mrittikasaigal@gmail.com";
  String profilePicture = "assets/moha.jpg";
  bool isEditMode = false;
  bool isLoading = false;
  bool get isOwner =>
      widget.loggedInUserId == widget.profileUserId; // Check ownership
  String bio = "Passionate Learner";
  double rating = 4.0; // Default rating
  String occupation = "Teacher";
  String location = "Bangladesh";
  List<String> achievements = ["Master at Codechef", "Top Scorer at Hackathon"];
  List<String> skills = [
    "Dart",
    "Flutter",
    "React",
    "UI/UX Design",
    "Python",
    "Java",
    "Cooking",
    "Reciting"
  ]; // Default skills

  // Animation controller for slide-in effect
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch email client.")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: Colors.blue,
      ),
      body: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: 1, // Make entire profile fade-in
          child: SingleChildScrollView(
            child: Container(
              color:
                  Colors.black12, // You can change this to any color you prefer
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture and Rating Section
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullScreenImage(imagePath: profilePicture),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(profilePicture),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.yellow[700],
                                  ),
                                  onPressed:
                                      null, // Only owner can change rating
                                );
                              }),
                            ),
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  bio,
                                  textStyle: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                              totalRepeatCount: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // User Name Section
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Buttons: Swap, Message, Popup Menu
                    Row(
                      children: [
                        // Expanded(
                        //   child: InkWell(
                        //     onTap: () {},
                        //     child: Container(
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 10, horizontal: 20),
                        //       decoration: BoxDecoration(
                        //         color: Colors.blue,
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //       child: const Text(
                        //         'Swap',
                        //         style: TextStyle(
                        //             color: Colors.white, fontSize: 13.0),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: InkWell(
                            onTap: isOwner // Only allow navigation to EditProfile if the user is the owner
                                ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditProfile(
                                    loggedInUserId: 'user123', // Replace with the actual logged-in user ID
                                    profileUserId: 'user123',
                                  ),
                                ),
                              );
                            }
                                : () {}, // Do nothing if not the owner
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isOwner ? 'Edit' : 'Swap', // Change the label if owner
                                style: const TextStyle(color: Colors.white, fontSize: 13.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Message',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: 1, child: Text("Copy Profile Link")),
                            // const PopupMenuItem(
                            //     value: 2, child: Text("Account")),
                            // const PopupMenuItem(
                            //     value: 3, child: Text("Settings")),
                            // const PopupMenuItem(
                            //     value: 4, child: Text("About GFG")),
                            // const PopupMenuItem(
                            //     value: 5, child: Text("Go Premium")),
                            // const PopupMenuItem(
                            //     value: 6, child: Text("Logout")),
                          ],
                        ),
                      ],
                    ),

                    // Email Section with Clipboard functionality
                    GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(text: email));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Email copied to clipboard!")),
                        );
                      },
                      onTap: () => _launchEmail(email),
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.email, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                email,
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.work, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: isEditMode
                              ? DropdownButtonFormField<String>(
                                  value: occupation,
                                  decoration: const InputDecoration(
                                      labelText: "Select Occupation"),
                                  items: [
                                    "Teacher",
                                    "Engineer",
                                    "Designer",
                                    "Developer",
                                    "Other"
                                  ]
                                      .map((occupation) => DropdownMenuItem(
                                            value: occupation,
                                            child: Text(occupation),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      occupation = value ?? "Other";
                                    });
                                  },
                                )
                              : Text(
                                  occupation,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis),
                                ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Achievements Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Achievements",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Wrap(
                        //   spacing: 5,
                        //   runSpacing: 5,
                        //   children: achievements.map((achievement) {
                        //     return Chip(
                        //       label: Text(achievement),
                        //       backgroundColor: Colors.orangeAccent[100],
                        //     );
                        //   }).toList(),
                        // ),
                        Align(
                          alignment: Alignment.centerLeft, // Align the content to the left
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: achievements.map((achievement) {
                              return Chip(
                                label: Text(achievement),
                                backgroundColor: Colors.orangeAccent[100],
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // if (isOwner)
                        //   Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: ElevatedButton(
                        //       onPressed: () async {
                        //         // Navigate to AchievementEditPage to edit the list
                        //         final updatedAchievements = await Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => AchievementEditPage(achievements: List<String>.from(achievements)),
                        //           ),
                        //         );
                        //         if (updatedAchievements != null) {
                        //           setState(() {
                        //             achievements = updatedAchievements;
                        //           });
                        //         }
                        //       },
                        //       child: const Text("Edit Achievements"),
                        //     ),
                        //   ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_city, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child:
                              // isEditMode
                              //     ? TypeAheadFormField<String>(
                              //   textFieldConfiguration: TextFieldConfiguration(
                              //     controller: TextEditingController(text: location),
                              //     decoration: const InputDecoration(labelText: "Enter Location"),
                              //   ),
                              //   suggestionsCallback: (pattern) async {
                              //     // Return a list of suggested locations
                              //     return ["Dhaka", "Chittagong", "Sylhet", "Khulna", "Rajshahi"]
                              //         .where((city) => city.toLowerCase().contains(pattern.toLowerCase()))
                              //         .toList();
                              //   },
                              //   itemBuilder: (context, suggestion) {
                              //     return ListTile(title: Text(suggestion));
                              //   },
                              //   onSuggestionSelected: (suggestion) {
                              //     setState(() {
                              //       location = suggestion;
                              //     });
                              //   },
                              // )
                              //     :
                              Text(
                            location,
                            style: const TextStyle(
                                fontSize: 16, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),

                    // Skills Section with Slide-in effect
                    const SizedBox(height: 16),
                    SlideTransition(
                      position: _offsetAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Skills",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: skills.take(3).map((skill) {
                              return Chip(
                                label: Text(skill),
                                backgroundColor: Colors.greenAccent[100],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SkillsDetailPage(
                                      skills: List<String>.from(skills),
                                      isOwner: isOwner,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("View All Skills"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Feedback Button with Hero Animation
                    const SizedBox(height: 8),
                    Hero(
                      tag: 'feedbackButton',
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserFeedback(),
                            ),
                          );
                        },
                        child: const Text("Feedback"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
