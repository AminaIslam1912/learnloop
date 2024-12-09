import 'package:flutter/material.dart';

import 'Achievement.dart';
import 'FullScreenImage.dart';
import 'Skill.dart';

class EditProfile extends StatefulWidget {
  final String loggedInUserId; // Pass the authenticated user's ID
  final String profileUserId; // The profile's owner ID

  const EditProfile(
      {super.key, required this.loggedInUserId, required this.profileUserId});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //const EditProfile({super.key});
  String name = "Jack Sparrow";
  String email = "mrittikasaigal@gmail.com";
  String profilePicture = "assets/moha.jpg";
  bool isEditMode = false;
  bool isLoading = false;
  bool get isOwner =>
      widget.loggedInUserId == widget.profileUserId; // Check ownership
  String bio = "Passionate Learner";
  String occupation = "Teacher";
  String location = "Bangladesh";
  List<String> achievements = ["Master at Codechef", "Top Scorer at Hackathon"];

  double rating = 4.0; // Default rating
  List<String> skills = [
    "Dart",
    "Flutter",
    "React",
    "UI/UX Design",
    "Python",
    "Java"
  ]; // Default skills

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

  void _editAchievement() async {
    final updatedAc = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementEditPage(achievements: List<String>.from(achievements)),
      ),
    );

    if (updatedAc != null) {
      setState(() {
        achievements = updatedAc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Align children to the left

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
                    Expanded(
                      // Use Expanded to let the TextField scale based on available space
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: TextEditingController(text: bio),
                          onChanged: (newValue) {
                            // Update the bio value here as needed
                          },
                          maxLength: 60, // Limit to 60 characters
                          decoration: const InputDecoration(
                            labelText: 'Edit Bio',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: TextEditingController(text: email),
                    onChanged: (newValue) {
                      // Update the bio value here as needed
                    },

                    decoration: const InputDecoration(
                      labelText: 'Edit Mail',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: TextEditingController(text: occupation),
                    onChanged: (newValue) {
                      // Update the bio value here as needed
                    },

                    decoration: const InputDecoration(
                      labelText: 'Edit Occupation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Achievements",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      alignment:
                          Alignment.centerLeft, // Align the content to the left
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: achievements.map((achievement) {
                              return Chip(
                                label: Text(achievement),
                                backgroundColor: Colors.orangeAccent[100],
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                              height:
                              10), // Add some space between chips and the button
                          Align(
                            alignment: Alignment
                                .centerLeft, // Align the button to the start of the column
                            child: ElevatedButton(
                              onPressed: _editAchievement,
                              child: const Text("Edit Achievement"),
                            ),

                          ),
                        ],
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

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: TextEditingController(text: location),
                    onChanged: (newValue) {
                      // Update the bio value here as needed
                    },

                    decoration: const InputDecoration(
                      labelText: 'Edit Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                // Skills Section
                const Text(
                  "Skills",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align items to the start
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
                    const SizedBox(
                        height:
                            10), // Add some space between chips and the button
                    Align(
                      alignment: Alignment
                          .centerLeft, // Align the button to the start of the column
                      child: ElevatedButton(
                        onPressed: _editSkills,
                        child: const Text("Edit Skills"),
                      ),

                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
