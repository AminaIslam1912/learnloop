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

  Map<String, String> communityImages = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCommunityImages();
  }

  Future<void> _fetchCommunityImages() async {
    try {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Problem Solvers'),
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
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: communities.length,
                  itemBuilder: (context, index) {
                    final community = communities[index];
                    return _communityBox(
                      name: community["name"]!,
                      title: community["title"]!,
                      description: community["description"]!,
                      discordLink: community["link"]!,
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
    required String discordLink,
  }) {
    final backgroundImage = communityImages[name];
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
                color: Colors.grey[850]!.withOpacity(0.8),
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
                      if (await canLaunch(discordLink)) {
                        await launch(discordLink);
                      } else {
                        throw 'Could not launch $discordLink';
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
