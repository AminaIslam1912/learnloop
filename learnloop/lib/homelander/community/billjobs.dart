import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BillJobsScreen extends StatefulWidget {
  const BillJobsScreen({super.key});

  @override
  _BillJobsScreenState createState() => _BillJobsScreenState();
}

class _BillJobsScreenState extends State<BillJobsScreen> {
  final List<Map<String, String>> communities = [
    {
      "title": "Microsoft Tech Community",
      "description":
      "Join a community of Microsoft enthusiasts sharing tech tips, coding projects, and career advice.",
      "link": "https://discord.gg/bKwpUbxqQn",
      "name": "microsoft_tech_community", // Name in the Supabase table
    },
    {
      "title": "Azure DevOps Network",
      "description": "A space for Azure DevOps users to exchange solutions, tips, and DevOps practices.",
      "link": "https://discord.gg/hDsptZNseJ",
      "name": "azure_devops_network", // Name in the Supabase table
    },
  ];

  Map<String, String> communityImages = {}; // Maps `community_name` to image URL
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCommunityImages();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Microsoft Bundle'),
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
                color: Colors.grey[850]!.withOpacity(0.7),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                        fontWeight: FontWeight.bold,
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
