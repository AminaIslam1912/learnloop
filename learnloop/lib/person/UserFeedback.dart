import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'UserProfile.dart';


class UserFeedback extends StatefulWidget {
  final int profileUserId;

  const UserFeedback({super.key, required this.profileUserId});

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredFeedback = [];
  List<Map<String, dynamic>> feedbackData = [];
  bool isLoading = true;
  String profilePicture =  "https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";//"assets/moha.jpg";


  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }


  void _filterFeedback(String query) {
    setState(() {
      filteredFeedback = feedbackData
          .where((feedback) => feedback['topic']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchFeedback() async {
    try {
      final response = await supabase
          .from('users')
          .select('userFeedback')
          .eq('id', widget.profileUserId)
          .single();

      if (response != null && response['userFeedback'] != null) {
        List<dynamic> userFeedbacks = response['userFeedback'];

        for (var feedbackItem in userFeedbacks) {
          final feedbackId = feedbackItem['id'];
          final userResponse = await supabase
              .from('users')
              .select('name, profile_picture')
              .eq('id', feedbackId)
              .single();


          feedbackItem['name'] = userResponse['name'];
          feedbackItem['profile_picture'] = userResponse['profile_picture'];
        }

        setState(() {
          feedbackData = userFeedbacks.cast<Map<String, dynamic>>();
          filteredFeedback = feedbackData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToUserProfile(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfile(
          loggedInUserId: widget.profileUserId,
          profileUserId: userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        //backgroundColor:const Color(0xFF009252),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : feedbackData.isEmpty
          ? const Center(child: Text('No feedback available'))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search Feedback on Topics",
                labelStyle: const TextStyle(
                  color: Colors.green,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.green),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterFeedback,
            ),

          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredFeedback.length,
              itemBuilder: (context, index) {
                final feedback = filteredFeedback[index];
                return GestureDetector(
                  onTap: () {
                    navigateToUserProfile(feedback['id']);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: feedback['profile_picture'] != null
                                ? NetworkImage(feedback['profile_picture'])
                                :  NetworkImage(profilePicture) ,
                            radius: 30,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feedback['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      feedback['rating']?.toString() ?? '0.0',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(Icons.star, color: Colors.yellow[700], size: 16),
                                  ],
                                ),
                                Text(
                                  feedback['topic'] ?? 'No topic',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(feedback['description'] ?? 'No description'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}