import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProblemSolversScreen extends StatefulWidget {
  const ProblemSolversScreen({super.key});

  @override
  _ProblemSolversScreenState createState() => _ProblemSolversScreenState();
}

class _ProblemSolversScreenState extends State<ProblemSolversScreen> {
  final List<Map<String, String>> communities = [
    {
      "title": "Problem Solvers Community",
      "description":
      "Join a network of brilliant minds solving real-world challenges collaboratively.",
      "link": "https://discord.gg/7J5KkmXGcN",
      "name": "problem_solvers_community",
    },
    {
      "title": "Critical Thinkers",
      "description": "Sharpen your thinking and problem-solving skills.",
      "link": "https://discord.gg/ma9fbccVTC",
      "name": "critical_thinkers",
    },
  ];

  Map<String, String> communityImages = {}; // Maps `community_name` to image URL
  bool isLoading = true;
  String searchQuery = "";
  List<Map<String, String>> filteredCommunities = [];
  @override
  void initState() {
    super.initState();
    _fetchCommunityImages();
    filteredCommunities = communities;
  }

  Future<void> _fetchCommunityImages() async {
    try {
      // Fetch all images and community names from the Supabase table
      final data = await Supabase.instance.client
          .from('community')
          .select('community_name, image');

      setState(() {
        for (var item in data) {
          communityImages[item['community_name'] as String] =
          item['image'] as String;
        }
        isLoading = false;
      });
    } catch (error) {
      debugPrint("Error fetching community images: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredCommunities = communities
          .where((community) => community["title"]!
          .toLowerCase()
          .contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Problem Solving'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: _updateSearchQuery,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search communities...',
                  hintStyle: const TextStyle(color: Colors.green),
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCommunities.length,
                  itemBuilder: (context, index) {
                    final community = filteredCommunities[index];
                    return _communityBox(
                      name: community["name"]!,
                      title: community["title"]!,
                      description: community["description"]!,
                      link: community["link"]!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _communityBox({
    required String name,
    required String title,
    required String description,
    required String link,
  }) {
    final backgroundImage = communityImages[name]; // Fetch based on `community_name`
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            if (backgroundImage != null)
              Positioned.fill(
                child: Image.network(
                  backgroundImage,
                  fit: BoxFit.cover,
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[850]!.withOpacity(0.8), // Ensure visibility
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      if (await canLaunch(link)) {
                        await launch(link);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    child: const Text(
                      "Discord Server Link",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
