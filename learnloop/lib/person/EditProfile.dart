import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase_config.dart';
import 'Achievement.dart';
import 'FullScreenImage.dart';
import 'Skill.dart';

class EditProfile extends StatefulWidget {
  final int loggedInUserId;
  final int profileUserId;

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
      widget.loggedInUserId == widget.profileUserId;
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

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }


  Future<void> saveProfile() async {

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


      setState(() {
        name = _nameController.text;
        email = _emailController.text;
        bio = _bioController.text;
        occupation = _occupationController.text;
        location = _locationController.text;
      });

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
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SkillsEditPage(skills: List<String>.from(skills), profileUserId: widget.profileUserId,),
        ),
      );


    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving skills to the database: $e")),
      );
    }
  }



  void _editAchievement() async {
    try {

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AchievementEditPage(achievements: List<String>.from(achievements), profileUserId: widget.profileUserId,),
        ),
      );

    } catch (e) {
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
        if (profilePicture != "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg" && profilePicture.startsWith('https://')) {
          final fileName = profilePicture.split('/').last;
          await Supabase.instance.client.storage
              .from('profile_picture')
              .remove([fileName]);
        }
        final fileName = '${widget.profileUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        File file = File(pickedFile.path);


        final response = await Supabase.instance.client.storage
            .from('profile_picture')
            .upload(fileName, file);

        if (response.error != null) {
          throw response.error!.message;
        }


        final publicUrl = Supabase.instance.client.storage
            .from('profile_picture')
            .getPublicUrl(fileName);


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

      if (profilePicture.startsWith('https://')) {
        final fileName = profilePicture.split('/').last;
        await Supabase.instance.client.storage
            .from('profile_picture')
            .remove([fileName]);
      }

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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => isLoading = true);

      try {

        final fileName = '${widget.profileUserId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        File file = File(pickedFile.path);

        final response = await Supabase.instance.client.storage
            .from('cv_bucket')
            .upload(fileName, file);

        if (response.error != null) {
          throw response.error!.message;
        }

        final publicUrl = Supabase.instance.client.storage
            .from('cv_bucket')
            .getPublicUrl(fileName);

        // Update the user's CV URL in the database
        await Supabase.instance.client
            .from('users')
            .update({'cv_url': publicUrl})
            .eq('id', widget.profileUserId);

        setState(() {
          cvUrl = publicUrl;
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

  // Update the deleteCv function to handle the case when no CV exists
  Future<void> deleteCv() async {
    if (!cvUrl.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No CV to delete")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Remove CV from storage
      final fileName = cvUrl.split('/').last;
      await Supabase.instance.client.storage
          .from('cv_bucket')
          .remove([fileName]);

      // Update the database
      await Supabase.instance.client
          .from('users')
          .update({'cv_url': null})
          .eq('id', widget.profileUserId);

      setState(() {
        cvUrl = "";
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
    bool canDeleteCv = cvUrl.isNotEmpty;
    print("can Delete $canDeleteCv");



    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile",style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF009252),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: isLoading
                ? null
                : saveProfile,
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
                      alignment: Alignment.bottomRight,
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
                                            uploadProfilePicture();
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Opacity(
                                          opacity: canDeletePic ? 1.0 : 0.5,
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


              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 1.0,         // Border width
                  ),

                  borderRadius: BorderRadius.circular(8),

                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upload CV",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.upload_file, color: Colors.green),
                          onPressed: () async {
                            await uploadCv();
                          },
                        ),
                        const SizedBox(width: 16),
                        Opacity(
                          opacity: canDeleteCv ? 1.0 : 0.5,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: canDeleteCv
                                ? () async {
                              await deleteCv();
                            }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Achievements",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _editAchievement,
                          icon: const Icon(Icons.add, color: Colors.white),
                          tooltip: "Edit Achievements",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: achievements.take(3).map((achievement) {
                        return Chip(
                          label: Text(
                            achievement,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.black,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Skills",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _editSkills,
                          icon: const Icon(Icons.add, color: Colors.white),
                          tooltip: "Edit Skills",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: skills.take(3).map((skill) {
                        return Chip(
                          label: Text(
                            skill,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.black,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenCV extends StatelessWidget {
  final String filePath;

  const FullScreenCV({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View CV", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF009252),
      ),
      body: Center(
        child: _buildViewer(),
      ),
    );
  }

  Widget _buildViewer() {
    if (filePath.endsWith(".jpg") || filePath.endsWith(".png")) {
      return Image.network(filePath);
    } else {
      return const Text("Unsupported file type.");
    }
  }
}

extension on String {
  get error => null;
}
