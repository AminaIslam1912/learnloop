import 'package:flutter/material.dart';

import '../main.dart';
import 'Achievement.dart';
import 'FullScreenImage.dart';
import 'Skill.dart';

class EditProfile extends StatefulWidget {
  final int loggedInUserId; // Authenticated user's ID
  final int profileUserId; // Profile owner's ID

  const EditProfile({
    super.key,
    required this.loggedInUserId,
    required this.profileUserId,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = "";
  String email = "";
  String profilePicture = "assets/moha.jpg";
  bool isLoading = false;
  bool get isOwner =>
      widget.loggedInUserId == widget.profileUserId; // Check ownership
  String bio = "";
  String occupation = "";
  String location = "";
  List<String> achievements = [];
  List<String> skills = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Future<void> fetchUserData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     final response = await SupabaseConfig.client
  //         .from('users')
  //         .select()
  //         .eq('id', widget.profileUserId)
  //         .single();
  //
  //     if (response != null) {
  //       setState(() {
  //         name = response['name'] ?? "";
  //         email = response['email'] ?? "";
  //         bio = response['bio'] ?? "";
  //         occupation = response['occupation'] ?? "";
  //         location = response['location'] ?? "";
  //         profilePicture = response['profile_picture'] ?? "assets/moha.jpg";
  //         achievements = List<String>.from(response['achievements'] ?? []);
  //         skills = List<String>.from(response['skills'] ?? []);
  //       });
  //
  //       // Set the initial values for controllers
  //       _nameController.text = name;
  //       _emailController.text = email;
  //       _bioController.text = bio;
  //       _occupationController.text = occupation;
  //       _locationController.text = location;
  //
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error fetching data: $e")),
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }


  Future<void> saveProfile() async {
    //print("Before saving: $skills");

    setState(() {
      isLoading = true;
    });

    try {
      final payload = {
        'name': _nameController.text,
        'email': _emailController.text,
        'bio': _bioController.text,
        'occupation': _occupationController.text,
        'location': _locationController.text,

      };


      await SupabaseConfig.client
          .from('users')
          .update(payload)
          .eq('id', widget.profileUserId);
      //print("After saving: $skills");

      setState(() {
        name = _nameController.text;
        email = _emailController.text;
        bio = _bioController.text;
        occupation = _occupationController.text;
        location = _locationController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }




  void _editSkills() async {
    try {
      // Navigate to the SkillsEditPage and wait for the updated skills
      //final updatedSkills =
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SkillsEditPage(skills: List<String>.from(skills), profileUserId: widget.profileUserId,),
        ),
      );

      // if (updatedSkills != null) {
      //   //print("Updated skills: $updatedSkills"); // Debugging
      //
      //   // Update the skills in the database
      //   await SupabaseConfig.client
      //       .from('users')
      //       .update({'skills': updatedSkills}) // Directly update without jsonEncode
      //       .eq('id', widget.profileUserId);
      //
      //   // Update the local state to reflect the changes
      //   setState(() {
      //     skills = updatedSkills;
      //   });
      //
      //   //await fetchUserData();
      //
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Skills updated successfully in the database!")),
      //   );
      // }
    } catch (e) {
      //print("Error saving updated skills to the database: $e"); // Log error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving skills to the database: $e")),
      );
    }
  }



  void _editAchievement() async {
    try {
      // Navigate to the SkillsEditPage and wait for the updated skills
      //final updatedAchievements =
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AchievementEditPage(achievements: List<String>.from(achievements), profileUserId: widget.profileUserId,),
        ),
      );

      // if (updatedAchievements != null) {
      //
      //
      //   // Update the skills in the database
      //   await SupabaseConfig.client
      //       .from('users')
      //       .update({'achievements': updatedAchievements}) // Directly update without jsonEncode
      //       .eq('id', widget.profileUserId);
      //
      //   // Update the local state to reflect the changes
      //   setState(() {
      //     achievements = updatedAchievements;
      //   });
      //
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Achievements updated successfully in the database!")),
      //   );
      // }
    } catch (e) {
      //print("Error saving updated achievements to the database: $e"); // Log error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving achievements to the database: $e")),
      );
    }
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await SupabaseConfig.client
          .from('users')
          .select()
          .eq('id', widget.profileUserId)
          .single();

      if (response != null) {
        setState(() {
          name = response['name'] ?? "";
          email = response['email'] ?? "";
          bio = response['bio'] ?? "";
          occupation = response['occupation'] ?? "";
          location = response['location'] ?? "";
          profilePicture = response['profile_picture'] ?? "assets/moha.jpg";
          achievements = List<String>.from(response['achievements'] ?? []);
          skills = List<String>.from(response['skills'] ?? []);
        });

        // Set the initial values for controllers
        _nameController.text = name;
        _emailController.text = email;
        _bioController.text = bio;
        _occupationController.text = occupation;
        _locationController.text = location;

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: isLoading
                ? null
                : saveProfile, // Save button to save changes to the database
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(profilePicture),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _bioController,
                        maxLength: 20,
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
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _occupationController,
                decoration: const InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Achievements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: achievements.take(3).map((achievement) {
                  return Chip(
                    label: Text(achievement),
                    backgroundColor: Colors.orangeAccent[100],
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _editAchievement,
                child: const Text("Edit Achievements"),
              ),
              const SizedBox(height: 16),
              const Text(
                "Skills",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
              ElevatedButton(
                onPressed: _editSkills,
                child: const Text("Edit Skills"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
