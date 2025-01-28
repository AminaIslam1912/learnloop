
import 'package:flutter/material.dart';
import 'package:learnloop/homelander/community/problemsolvers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';
import '../../MainPage.dart';
import 'graphics.dart';
import '../home_page.dart';
import 'kekaferdousi.dart';
import 'billjobs.dart';
class CommunityUI extends StatefulWidget {
  final User? user;
  const CommunityUI({super.key, this.user});

  @override
  _CommunityUIState createState() => _CommunityUIState();
}

class _CommunityUIState extends State<CommunityUI> {
  String? selectedCommunity;
  Map<int, String> communityImages = {};
  bool isLoading = true;
  String searchQuery = "";

  // Predefined list of community titles and their IDs
  final List<Map<String, dynamic>> communities = [
    {'id': 1, 'name': 'Graphic Design'},
    {'id': 2, 'name': 'Problem Solvers'},
    {'id': 8, 'name': 'Cooking'},
    {'id': 9, 'name': 'Microsoft Bundle'},
  ];

  List<Map<String, dynamic>> filteredCommunities = [];

  @override
  void initState() {
    super.initState();
    filteredCommunities = List.from(communities); // Initialize with all communities
    _fetchCommunityImages();
  }

  Future<void> _fetchCommunityImages() async {
    try {
      // Fetch images corresponding to the community IDs from Supabase
      final data = await Supabase.instance.client
          .from('community')
          .select('id, image');

      setState(() {
        for (final image in data) {
          communityImages[image['id']] = image['image'];
        }
        isLoading = false;
      });
    } catch (error) {
      debugPrint("Error fetching community images: $error");

      // Stop the loading spinner even if an error occurs
      setState(() {
        isLoading = false;
      });
    }
  }

  void _selectCommunity(String community) {
    setState(() {
      selectedCommunity = community;
    });
    if (community == "Graphic Design") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GraphicDesignerScreen()),
      );
    } else if (community == "Problem Solvers") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProblemSolversScreen()),
      );
    }
    else if (community == "Cooking") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CookingScreen()),
      );
    }
    else if (community == "Microsoft Bundle") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BillJobsScreen()),
      );
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredCommunities = communities
          .where((community) =>
          community['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Community'),
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  onChanged: _updateSearchQuery,
                  cursorColor: Colors.green, // Set cursor color to green
                  decoration: InputDecoration(
                    labelText: 'Search community',
                    labelStyle: const TextStyle(
                      color: Colors.green, // Green label text
                    ),
                   // hintStyle: const TextStyle(color: Colors.white54),
                   // prefixIcon: const Icon(Icons.search, color: Colors.green), // Green prefix icon

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                     // borderSide: const BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      borderSide: const BorderSide(
                        color: Colors.green, // Green border on focus
                        width: 2.0, // Thickness of the border
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    prefixIcon: const Icon(Icons.search, color: Colors.green),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: filteredCommunities.length,
                  itemBuilder: (context, index) {
                    final community = filteredCommunities[index];
                    final communityId = community['id'];
                    final communityName = community['name'];
                    final backgroundImage = communityImages[communityId];
                    return _communityBox(communityName, backgroundImage);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _communityBox(String community, String? backgroundImage) {
    bool isSelected = selectedCommunity == community;

    return GestureDetector(
      onTap: () {
        _selectCommunity(community);
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          image: backgroundImage != null
              ? DecorationImage(
            image: NetworkImage(backgroundImage),
            fit: BoxFit.cover,
          )
              : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (backgroundImage != null)
                Positioned.fill(
                  child: Image.network(
                    backgroundImage,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.8),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            community,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Join the discussion',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
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
}
