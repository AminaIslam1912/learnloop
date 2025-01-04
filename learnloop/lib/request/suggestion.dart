import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../UserProvider.dart';
import '../person/UserProfile.dart';

class SuggestedForYouTab extends StatefulWidget {
  @override
  _SuggestedForYouTabState createState() => _SuggestedForYouTabState();
}

class _SuggestedForYouTabState extends State<SuggestedForYouTab> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> profiles = [];
  bool isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    fetchProfiles();
    fetchUserId(); // Fetch user ID on initialization
  }

  Future<void> fetchUserId() async {
    final user =
        context.read<UserProvider>().user; // Get the user from Provider

    if (user == null) return;

    try {
      // Query the `users` table for the user with the corresponding email
      final response = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('email', user.email as Object)
          .single(); // `.single()` fetches a single row

      if (response != null && response['id'] is int) {
        setState(() {
          _userId = response['id']; // Store the fetched ID
        });
        print('Fetched User ID: $_userId');
      } else {
        print('No user found with email ${user.email}');
      }
    } catch (error) {
      print('Error fetching user ID: $error');
    }
  }

  Future<void> fetchProfiles() async {
    try {
      final response = await supabase.from('users').select();

      setState(() {
        profiles = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching profiles: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) => filterProfiles(value),
            decoration: InputDecoration(
              hintText: "Search Profiles",
              prefixIcon: Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        Expanded(
          child: Container(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return Column(
                          children: [
                            buildSuggestedCard(
                              userId: profile['id'], // Pass the user's ID
                              name: profile['name'] ?? 'Unknown',
                              ratings: profile['ratings']?.toString() ?? 'N/A',
                              profileImageUrl: profile['profile_picture'] ??
                                  'https://via.placeholder.com/150',
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    )),
        ),
      ],
    );
  }

  void filterProfiles(String query) {
    setState(() {
      profiles = profiles
          .where((profile) =>
              profile['name']?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    });
  }

  Widget buildSuggestedCard({
    required int userId,
    required String name,
    required String ratings,
    required String profileImageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        navigateToUserProfile(userId);
      },
      child: Card(
        color: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
                radius: 30,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Ratings: $ratings',
                      style: TextStyle(color: Color(0xE1DADAFF)),
                    ),
                    SizedBox(height: 8), // Space between text and buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed:  () async {
                             await handleSwap(userId); // Call the function to handle swapping
      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF679186),
                          ),
                          child: Text("Swap"),
                        ),
                        SizedBox(width: 8), // Space between buttons
                        ElevatedButton(
                          onPressed: () {
                            // Add remove logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFDA89C),
                          ),
                          child: Text("Remove"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToUserProfile(int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            // UserProfile(
            //   loggedInUserId: _userId!, // Replace with appropriate logged-in user ID
            //   profileUserId: userId,
            // ),
            _userId == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  ) // Show a loading indicator while fetching
                : UserProfile(
                    loggedInUserId: _userId!,
                    profileUserId: userId,
                  ),
      ),
    );
  }

  Future<void> handleSwap(int profileId) async {
    try {
      // Get the logged-in user from UserProvider
      final user = context.read<UserProvider>().user;

      if (user == null) {
        print('No logged-in user found.');
        return;
      }

      // Fetch the current `request_sent` column value
      final response = await supabase
          .from('users')
          .select('request_sent')
          .eq('id', _userId as Object)
          .single();

      if (response == null) {
        print('Error fetching request_sent: Response is null');
        return;
      }

      List<dynamic> requestSent = response['request_sent'] ?? [];

      // Add the new profile ID to the `request_sent` list
      requestSent.add({'id': profileId});

      // Update the `request_sent` column in the Supabase database
      final updateResponse = await supabase
          .from('users')
          .update({'request_sent': requestSent})
          .eq('id', _userId as Object);

      // Check for errors in the updateResponse
      if (updateResponse.error != null) {
        print('Error updating request_sent: ${updateResponse.error!.message}');
        return;
      }

      print('Profile added to request_sent: $profileId');

      // Remove the profile from the local list and refresh the UI
      setState(() {
        profiles.removeWhere((profile) => profile['id'] == profileId);
      });
    } catch (error) {
      print('Error handling swap: $error');
    }
  }


}

extension on PostgrestFilterBuilder<PostgrestList> {
  execute() {}
}

