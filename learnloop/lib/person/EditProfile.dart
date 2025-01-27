
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import '../supabase_config.dart';
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
  String profilePicture = "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";
  bool isLoading = false;
  bool get isOwner =>
      widget.loggedInUserId == widget.profileUserId; // Check ownership
  String bio = "";
  String occupation = "";
  String location = "";
  List<String> achievements = [];
  List<String> skills = [];
  String cvUrl = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final picker = ImagePicker();

  get uploadedCVName => null;

  get cvFilePath => null;




  @override
  void initState() {
    super.initState();
    fetchUserData();
  }




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

      // Pass updated data back to the previous screen
      Navigator.pop(context, {
        'name': _nameController.text,
        'email': _emailController.text,
        'bio': _bioController.text,
        'occupation': _occupationController.text,
        'location': _locationController.text,
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


    } catch (e) {
      //print("Error saving updated achievements to the database: $e"); // Log error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving achievements to the database: $e")),
      );
    }
  }

  Future<void> uploadProfilePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => isLoading = true);

      try {

        // Check if there's already a profile picture and delete it if it exists
        if (profilePicture != "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg" && profilePicture.startsWith('https://')) {
          final fileName = profilePicture.split('/').last; // Extract file name
          await Supabase.instance.client.storage
              .from('profile_picture')
              .remove([fileName]);
        }
        // File name for the uploaded image
        final fileName = '${widget.profileUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Convert the file path string to a File object
        File file = File(pickedFile.path);

        // Upload the image to Supabase Storage
        final response = await Supabase.instance.client.storage
            .from('profile_picture') // Bucket name
            .upload(fileName, file); // Pass the File object

        if (response.error != null) {
          throw response.error!.message;
        }

        // Get the public URL of the uploaded image
        final publicUrl = Supabase.instance.client.storage
            .from('profile_picture')
            .getPublicUrl(fileName);

        // Update the user's profile picture URL in the database
        await Supabase.instance.client
            .from('users')
            .update({'profile_picture': publicUrl})
            .eq('id', widget.profileUserId);

        setState(() {
          profilePicture = publicUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture updated!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading picture: $e")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }



  Future<void> deleteProfilePicture() async {
    setState(() => isLoading = true);

    try {
      // Remove profile picture from storage (if previously uploaded)
      if (profilePicture.startsWith('https://')) {
        final fileName = profilePicture.split('/').last; // Extract file name
        await Supabase.instance.client.storage
            .from('profile_picture')
            .remove([fileName]);
      }

      // Update the database to set profile picture to default
      await Supabase.instance.client
          .from('users')
          .update({'profile_picture': null})
          .eq('id', widget.profileUserId);

      setState(() {
        profilePicture = "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg"; // Reset to default
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture deleted!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting picture: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> uploadCv() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // You can change this to a file picker if needed

    if (pickedFile != null) {
      setState(() => isLoading = true);

      try {
        // Upload logic similar to profile picture upload
        final fileName = '${widget.profileUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        File file = File(pickedFile.path);

        // Upload CV to Supabase storage
        final response = await Supabase.instance.client.storage
            .from('cv_bucket')
            .upload(fileName, file);

        if (response.error != null) {
          throw response.error!.message;
        }

        // Get the public URL of the uploaded CV
        final publicUrl = Supabase.instance.client.storage
            .from('cv_bucket')
            .getPublicUrl(fileName);

        // Update the user's CV URL in the database
        await Supabase.instance.client
            .from('users')
            .update({'cv_url': publicUrl})
            .eq('id', widget.profileUserId);

        setState(() {
          cvUrl = publicUrl; // Update CV URL
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("CV uploaded successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading CV: $e")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> deleteCv() async {
    setState(() => isLoading = true);

    try {
      // Remove CV from storage (if previously uploaded)
      if (cvUrl.isNotEmpty) {
        final fileName = cvUrl.split('/').last; // Extract file name
        await Supabase.instance.client.storage
            .from('cv_bucket') // Your CV files bucket
            .remove([fileName]);
      }

      // Update the database to set CV URL to null
      await Supabase.instance.client
          .from('users')
          .update({'cv_url': null})
          .eq('id', widget.profileUserId);

      setState(() {
        cvUrl = ""; // Reset CV URL
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CV deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting CV: $e")),
      );
    } finally {
      setState(() => isLoading = false);
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

      setState(() {
        name = response['name'] ?? "";
        email = response['email'] ?? "";
        bio = response['bio'] ?? "";
        occupation = response['occupation'] ?? "";
        location = response['location'] ?? "";
        profilePicture = response['profile_picture'] ?? profilePicture;
        achievements = List<String>.from(response['achievements'] ?? []);
        skills = List<String>.from(response['skills'] ?? []);
        cvUrl = response['cv_url'] ?? "";

      });
      //print(cvUrl);
      // Set the initial values for controllers
      _nameController.text = name;
      _emailController.text = email;
      _bioController.text = bio;
      _occupationController.text = occupation;
      _locationController.text = location;

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


    bool canDeletePic = profilePicture != "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";



    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile",style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF009252),
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
        padding: const EdgeInsets.all(8.0),
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
                            isNetworkImage: profilePicture.startsWith('https://'), filePath: '',
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight, // Position the edit icon at the bottom right
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profilePicture.startsWith('https://')
                              ? NetworkImage(profilePicture)
                              : AssetImage(profilePicture) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Show options for update and delete
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text('Update'),
                                          onTap: () {
                                            // Handle the update action here
                                            uploadProfilePicture();
                                            Navigator.pop(context); // Close the bottom sheet
                                          },
                                        ),
                                        Opacity(
                                          opacity: canDeletePic ? 1.0 : 0.5, // Change opacity here
                                          child: ListTile(
                                            leading: const Icon(Icons.delete),
                                            title: const Text('Delete'),
                                            onTap: canDeletePic ? () {
                                              deleteProfilePicture();
                                              Navigator.pop(context);
                                            } : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.edit, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
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
                        // onChanged: (value) {
                        //   userProfileProvider.bio = value; // Update the bio
                        // },
                      ),
                    ),
                  ),
                ],
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

              // CV Upload Section
              /*const Text(
                "Upload CV",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: uploadedCVName != null
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenCV(
                              filePath: cvFilePath,
                            ),
                          ),
                        );
                      }
                          : null,
                      child: Text(
                        uploadedCVName ?? "No CV uploaded",
                        style: const TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.upload_file, color: Colors.green),
                    onPressed: uploadCv, // Function to upload CV
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: uploadedCVName != null ? Colors.red : Colors.grey),
                    onPressed: uploadedCVName != null ? deleteCv : null, // Function to delete CV
                  ),
                ],
              ),*/

              const Text(
                "Upload CV",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: uploadedCVName != null
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenCV(
                              filePath: cvFilePath, // Pass the uploaded CV's file path
                            ),
                          ),
                        );
                      }
                          : null,
                      child: Container(
                        height: 120, // Rectangle height
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200], // Background color for the default state
                          image: uploadedCVName != null
                              ? DecorationImage(
                            image: NetworkImage(cvFilePath), // Show uploaded CV image
                            fit: BoxFit.cover, // Cover the entire rectangle
                          )
                              : null,
                        ),
                        child: uploadedCVName == null
                            ? const Center(
                          child: Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
                        )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.upload_file, color: Colors.green),
                          onPressed: uploadCv, // Function to upload CV
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: uploadedCVName != null ? Colors.red : Colors.grey),
                          onPressed: uploadedCVName != null ? deleteCv : null, // Function to delete CV
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text(
                "Achievements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: achievements.take(3).map((achievement) {
                  return Chip(
                    label: Text(achievement),
                    backgroundColor: Colors.black,

                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _editAchievement,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009252), // Set the button color
                ),
                child: const Text("Edit Achievements",style: TextStyle(color: Colors.white)),

              ),
              const SizedBox(height: 16),
              const Text(
                "Skills",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: skills.take(3).map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: Colors.black,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009252), // Set the button color
                ),
                onPressed: _editSkills,
                child: const Text("Edit Skills",style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Full Screen CV Viewer
class FullScreenCV extends StatelessWidget {
  final String filePath;

  const FullScreenCV({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View CV", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF009252),
      ),
      body: Center(
        child: filePath.endsWith(".pdf")
            ? Text("Display PDF Viewer Here") // Use a PDF viewer package (e.g., `flutter_pdfview`)
            : const Text("Unsupported file type"),
      ),
    );
  }
}

extension on String {
  get error => null;
}