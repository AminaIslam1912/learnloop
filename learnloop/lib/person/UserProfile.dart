import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality
import 'package:learnloop/all_feedback/swap_feedback.dart';
import 'package:url_launcher/url_launcher.dart';
import '../supabase_config.dart';
import 'Achievement.dart';
import 'EditProfile.dart';
import 'FullScreenImage.dart';
import 'Skill.dart';
import 'UserFeedback.dart';

class UserProfile extends StatefulWidget {
  final int loggedInUserId; // Pass the authenticated user's ID
  final int profileUserId; // The profile's owner ID

  const UserProfile(
      {super.key, required this.loggedInUserId, required this.profileUserId});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  String name = "";
  String email = "";
  String profilePicture =
      "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg"; //"assets/moha.jpg";
  bool isEditMode = false;
  bool isLoading = false;
  bool get isOwner =>
      widget.loggedInUserId == widget.profileUserId; // Check ownership
  String bio = "";
  double rating = 0; // Default rating
  String occupation = "";
  String location = "";
  List<String> achievements = [];
  List<String> skills = []; // Default skills
  bool isFriend = false;
  String cvUrl = "";

  Future<void> checkFriend(int loggedId, int userId) async {
    try {
      final response = await SupabaseConfig.client
          .from('users')
          .select('friends')
          .eq('id', loggedId) // Get the specific user's record
          .single();

      List<dynamic> friendsList = response['friends'] as List;
      print("firends are $friendsList");
      List<int> friendIds =
          friendsList.map((friend) => friend['id'] as int).toList();
      print("firends are $friendIds");

      setState(() {
        isFriend = friendIds.contains(userId);
      });
    } catch (e) {
      print('Error updating friend status: $e');
      setState(() {
        isFriend = false;
      });
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

      print("RESPONSE $response");

      if (response != null) {
        setState(() {
          name = response['name'] ?? name;
          email = response['email'] ?? email;
          bio = response['bio'] ?? bio;
          //print("Bio: $bio");

          occupation = response['occupation'] ?? occupation;
          location = response['location'] ?? location;
          // profilePicture = response['profile_picture'] ?? profilePicture;
          profilePicture = (response['profile_picture'] != null &&
                  response['profile_picture'].isNotEmpty)
              ? response['profile_picture']
              : profilePicture;
          achievements = List<String>.from(response['achievements'] ?? []);
          //print("achievements: $achievements");
          skills = List<String>.from(response['skills'] ?? []);
          cvUrl = response['cv_url'] ?? "";
        });
      }

      // Calculate average rating from user feedback
      final feedbackResponse = await SupabaseConfig.client
          .from('users')
          .select('userFeedback')
          .eq('id', widget.profileUserId)
          .single();

      if (feedbackResponse != null &&
          feedbackResponse['userFeedback'] != null) {
        List<dynamic> userFeedbacks = feedbackResponse['userFeedback'];
        double totalRating = 0;
        int feedbackCount = 0;

        for (var feedbackItem in userFeedbacks) {
          if (feedbackItem['rating'] != null) {
            totalRating += feedbackItem['rating'];
            print("rating : $feedbackItem['rating']");
            feedbackCount++;
          }
        }
        print("total $totalRating");

        double calculatedRating =
            feedbackCount > 0 ? totalRating / feedbackCount : 0;

        // Update rating in the database
        await SupabaseConfig.client.from('users').update(
            {'rating': calculatedRating}).eq('id', widget.profileUserId);

        setState(() {
          rating = calculatedRating;
        });
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
  void initState() {
    super.initState();
    fetchUserData();
    checkFriend(widget.loggedInUserId, widget.profileUserId);
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
          backgroundColor: const Color(0xFF009252),
          actions: [
            if (isOwner)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(
                        loggedInUserId: widget.loggedInUserId,
                        profileUserId: widget.profileUserId,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  color: Colors
                      .black12, // You can change this to any color you prefer
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture and Rating Section
                        // Row(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             // builder: (context) =>
                        //             //     FullScreenImage(imagePath: profilePicture),
                        //             builder: (context) => FullScreenImage(
                        //               imagePath: profilePicture,
                        //               isNetworkImage: profilePicture.startsWith('https://'), filePath: '',
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //       child: Padding(
                        //           padding: const EdgeInsets.all(1.0),
                        //           // child: CircleAvatar(
                        //           //   radius: 50,
                        //           //   backgroundImage: AssetImage(profilePicture),
                        //           // ),
                        //           child: CircleAvatar(
                        //             radius: 50,
                        //             backgroundImage: profilePicture.startsWith('https://')
                        //                 ? NetworkImage(profilePicture)
                        //                 : AssetImage(profilePicture) as ImageProvider,
                        //           )
                        //       ),
                        //     ),
                        //     Column(
                        //         children: [
                        //           Row(
                        //             children: List.generate(5, (index) {
                        //               return IconButton(
                        //                 icon: Icon(
                        //                   index < rating
                        //                       ? Icons.star
                        //                       : Icons.star_border,
                        //                   color: Colors.yellow[700],
                        //                 ),
                        //                 onPressed:
                        //                 null, // Only owner can change rating
                        //               );
                        //             }),
                        //           ),
                        //           Text(
                        //             bio.isNotEmpty ? bio : "",
                        //             style: const TextStyle(
                        //                 fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.white),
                        //           ),
                        //
                        //         ],
                        //       ),
                        //
                        //   ],
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(
                                      imagePath: profilePicture,
                                      isNetworkImage:
                                          profilePicture.startsWith('https://'),
                                      filePath: '',
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      profilePicture.startsWith('https://')
                                          ? NetworkImage(profilePicture)
                                          : AssetImage(profilePicture)
                                              as ImageProvider,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
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
                                  ),
                                  if (bio.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        bio,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       name,
                        //       style: const TextStyle(
                        //           fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        //     ),
                        //     const SizedBox(height: 20,),
                        //     //const SizedBox(width: 8),  // Adds some space between the name and the popup button
                        //     Expanded(child: Container()),  // Fills remaining space to push the popup button to the right
                        //     PopupMenuButton(
                        //       itemBuilder: (context) => [
                        //         PopupMenuItem(
                        //           value: 1,
                        //           child: Opacity(
                        //             opacity: isOwner ? 0.5 : (isFriend ? 1.0 : 0.5),  // Update opacity based on both conditions
                        //             child: const Text(
                        //               "Give Feedback",
                        //               style: TextStyle(color: Colors.white, fontSize: 13.0),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //       onSelected: (value) {
                        //         if (value == 1) {
                        //           print("id  $isFriend");
                        //           isOwner
                        //               ? print("Owner, no feedback")
                        //               : (isFriend
                        //               ? showDialog(
                        //             context: context,
                        //             builder: (BuildContext context) {
                        //               return SwapFeedback(
                        //                 loggedInUserId: widget.loggedInUserId,
                        //                 profileUserId: widget.profileUserId,
                        //               );
                        //             },
                        //           )
                        //               : ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(content: Text("You must be friends to give feedback")),
                        //           ));
                        //         }
                        //       },
                        //     ),
                        //   ],
                        // ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                                child:
                                    Container()), // Fills remaining space to push the icon to the right
                            // IconButton(
                            //   icon: const Icon(
                            //     Icons.rate_review,  // Feedback icon
                            //     color: Colors.white,  // Icon color
                            //     size: 30,  // Icon size
                            //   ),
                            //   onPressed: () {
                            //     print("id  $isFriend");
                            //     isOwner
                            //         ? print("Owner, no feedback")
                            //         : (isFriend
                            //         ? showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return SwapFeedback(
                            //           loggedInUserId: widget.loggedInUserId,
                            //           profileUserId: widget.profileUserId,
                            //         );
                            //       },
                            //     )
                            //         : ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(content: Text("You must be friends to give feedback")),
                            //     ));
                            //   },
                            // ),
                            IconButton(
                              icon: const Icon(
                                Icons.rate_review, // Feedback icon
                                color: Colors.white, // Icon color
                                size: 30, // Icon size
                              ),
                              onPressed: () {
                                if (isOwner) {
                                  // Show message for the owner
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "You can't give mentor feedback to yourself"),
                                    ),
                                  );
                                } else if (isFriend) {
                                  // Show feedback dialog for friends
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SwapFeedback(
                                        loggedInUserId: widget.loggedInUserId,
                                        profileUserId: widget.profileUserId,
                                      );
                                    },
                                  );
                                } else {
                                  // Show message for non-friends
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "You must be friends to give feedback"),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),

                        // Fills remaining space to push the popup button to the right

                        const SizedBox(height: 16),
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
                                const Icon(Icons.email,
                                    color: Color(0xFF009252)),
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
                            const Icon(Icons.work, color: Color(0xFF009252)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                //occupation,
                                occupation.isNotEmpty ? occupation : "N/A",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.picture_in_picture,
                                color: Color(0xFF009252)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: cvUrl != null && cvUrl.isNotEmpty
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FullScreenCV(
                                              filePath: cvUrl,
                                            ),
                                          ),
                                        );
                                      }
                                    : null, // Disable onTap if no CV is uploaded
                                child: Text(
                                  cvUrl != null && cvUrl.isNotEmpty
                                      ? 'View CV'
                                      : 'No CV uploaded',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: cvUrl != null && cvUrl.isNotEmpty
                                        ? Colors.blue
                                        : Colors.red,
                                    decoration:
                                        cvUrl != null && cvUrl.isNotEmpty
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // CV Section
                        // if (cvUrl != null && cvUrl.isNotEmpty) ...[
                        //   const SizedBox(height: 16),
                        //   Row(
                        //     children: [
                        //       const Icon(Icons.picture_in_picture, color: Color(0xFF009252)),
                        //       const SizedBox(width: 8),
                        //       Expanded(
                        //         child: GestureDetector(
                        //           onTap: () {
                        //             Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (context) => FullScreenCV(
                        //                   filePath: cvUrl,
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //           child: Text(
                        //             'View CV',
                        //             style: TextStyle(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.blue,
                        //               decoration: TextDecoration.underline,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ] else ...[
                        //   const SizedBox(height: 16),
                        //   Text(
                        //     textAlign: TextAlign.left,
                        //     'No CV uploaded',
                        //     style: TextStyle(fontSize: 16, color: Colors.red),
                        //   ),
                        // ],

                        const SizedBox(height: 16),

                        Row(
                          children: [
                            const Icon(Icons.location_city,
                                color: Color(0xFF009252)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                //location,
                                location.isNotEmpty ? location : "N/A",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Text(
                        //       "Achievements",
                        //       style: TextStyle(
                        //           fontSize: 18, fontWeight: FontWeight.bold),
                        //     ),
                        //     const SizedBox(height: 8),
                        //     Wrap(
                        //       spacing: 5,
                        //       runSpacing: 5,
                        //       children: achievements.take(3).map((skill) {
                        //         return Chip(
                        //           label: Text(skill),
                        //           backgroundColor: Colors.black,
                        //         );
                        //       }).toList(),
                        //     ),
                        //     const SizedBox(height: 10),
                        //     Align(
                        //       alignment: Alignment.centerLeft,
                        //       child: ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //           backgroundColor: const Color(0xFF009252), // Set the button color
                        //         ),
                        //         onPressed: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => AchievementsDetails(
                        //                 achievements: List<String>.from(achievements),
                        //                 isOwner: isOwner,
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //         child: const Text("View All Achievements", style: TextStyle(color: Colors.white)),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        Container(
                          decoration: BoxDecoration(
                            //color: Colors.white, // Background color for the box
                            border: Border.all(
                              color: Colors.grey, // Border color
                              width: 1.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(
                                8.0), // Rounded corners for the border
                          ),
                          padding: const EdgeInsets.all(
                              16.0), // Padding inside the box
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0), // Margin around the box
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Achievements",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: achievements.take(3).map((skill) {
                                  return Chip(
                                    label: Text(skill),
                                    backgroundColor: Colors.black,
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor: const Color(0xFF009252), // Set the button color
                              //     ),
                              //     onPressed: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => AchievementsDetails(
                              //             achievements: List<String>.from(achievements),
                              //             isOwner: isOwner,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     child: const Text(
                              //       "View All Achievements",
                              //      // style: TextStyle(color: Colors.white),
                              //     ),
                              //   ),
                              // ),
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor: const Color(0xFF009252), // Button background color
                              //     ),
                              //     onPressed: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => SkillsDetailPage(
                              //             skills: List<String>.from(skills),
                              //             isOwner: isOwner,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     child: const Icon(
                              //       Icons.arrow_forward, // Better icon choice for navigation
                              //       color: Colors.white, // Icon color
                              //     ),
                              //   ),
                              // ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward, // Icon for navigation
                                    color: Colors.white, // Icon color
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AchievementsDetails(
                                          achievements:
                                              List<String>.from(achievements),
                                          isOwner: isOwner,
                                        ),
                                      ),
                                    );
                                  },
                                  iconSize:
                                      30, // Adjust the icon size as needed
                                  padding: const EdgeInsets.all(
                                      10), // Add padding around the icon
                                  constraints:
                                      BoxConstraints(), // Remove the default constraints to adjust the size
                                ),
                              )
                            ],
                          ),
                        ),

                        // Skills Section with Slide-in effect
                        const SizedBox(height: 16),

                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Text(
                        //       "Skills",
                        //       style: TextStyle(
                        //           fontSize: 18, fontWeight: FontWeight.bold),
                        //     ),
                        //     const SizedBox(height: 8),
                        //     Wrap(
                        //       spacing: 5,
                        //       runSpacing: 5,
                        //       children: skills.take(3).map((skill) {
                        //         return Chip(
                        //           label: Text(skill),
                        //           backgroundColor: Colors.black,
                        //         );
                        //       }).toList(),
                        //     ),
                        //     const SizedBox(height: 10),
                        //     Align(
                        //       alignment: Alignment.centerLeft,
                        //       child: ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //           backgroundColor: const Color(0xFF009252), // Set the button color
                        //         ),
                        //         onPressed: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (context) => SkillsDetailPage(
                        //                 skills: List<String>.from(skills),
                        //                 isOwner: isOwner,
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //         child: const Text("View All Skills",style: TextStyle(color: Colors.white)),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black, // Background color for the box
                            border: Border.all(
                              color: Colors.grey, // Border color
                              width: 1.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(
                                8.0), // Rounded corners for the border
                          ),
                          padding: const EdgeInsets.all(
                              16.0), // Padding inside the box
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0), // Margin around the box
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Skills",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: skills.take(3).map((skill) {
                                  return Chip(
                                    label: Text(skill),
                                    backgroundColor: Colors.black,
                                    //labelStyle: const TextStyle(color: Colors.white), // Ensures text is visible
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor: const Color(0xFF009252), // Button background color
                              //     ),
                              //     onPressed: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => SkillsDetailPage(
                              //             skills: List<String>.from(skills),
                              //             isOwner: isOwner,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     child: const Text(
                              //       "View All Skills",
                              //       //style: TextStyle(color: Colors.white), // Button text color
                              //     ),
                              //   ),
                              // ),
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor:  Colors.white, // Button background color
                              //     ),
                              //     onPressed: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //           builder: (context) => SkillsDetailPage(
                              //             skills: List<String>.from(skills),
                              //             isOwner: isOwner,
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     child: const Icon(
                              //       Icons.arrow_forward, // Better icon choice for navigation
                              //       color: Colors.white, // Icon color
                              //     ),
                              //   ),
                              // ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward, // Icon for navigation
                                    color: Colors.white, // Icon color
                                  ),
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
                                  iconSize:
                                      30, // Adjust the icon size as needed
                                  padding: const EdgeInsets.all(
                                      10), // Add padding around the icon
                                  constraints:
                                      BoxConstraints(), // Remove the default constraints to adjust the size
                                ),
                              )
                            ],
                          ),
                        ),

                        // Feedback Button with Hero Animation
                        const SizedBox(height: 8),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: const Color(0xFF009252), // Set the button color
                        //     ),
                        //     onPressed: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) =>  UserFeedback(profileUserId : widget.profileUserId),
                        //         ),
                        //       );
                        //     },
                        //     child: const Text("Feedback",style: TextStyle(color: Colors.white)),
                        //   ),
                        // ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Border color
                                width: 2, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10), // Padding inside the button
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserFeedback(
                                        profileUserId: widget.profileUserId),
                                  ),
                                );
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Ensures the button doesn't expand unnecessarily
                                children: [
                                  Icon(
                                    Icons.feedback, // Feedback icon
                                    color: Colors.white, // Icon color
                                  ),
                                  SizedBox(
                                      width:
                                          8), // Add spacing between icon and text
                                  Text(
                                    "Feedback",
                                    style: TextStyle(
                                        color: Colors.white), // Text color
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
