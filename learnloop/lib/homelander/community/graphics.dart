// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class GraphicDesignerScreen extends StatelessWidget {
//   final List<Map<String, String>> communities = [
//     {
//       "title": "DesignConnect",
//       "description": "Join a thriving community where inspiration flows.",
//       "link": "https://discord.gg/cNm2rj4Q"
//     },
//   ];
//
//   GraphicDesignerScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text('Graphic Designer'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         color: Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[850],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.green, width: 2),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Graphic Era",
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Unleash your creativity and join our vibrant community of graphic designers, where ideas ignite and talents flourish.",
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     GestureDetector(
//                       onTap: () async {
//                         const url = "https://discord.gg/6dmuHmVg";
//                         if (await canLaunch(url)) {
//                           await launch(url);
//                         } else {
//                           throw 'Could not launch $url';
//                         }
//                       },
//                       child: const Text(
//                         "Discord Server Link",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 16,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 "Other Communities",
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: communities.length,
//                   itemBuilder: (context, index) {
//                     final community = communities[index];
//                     return _communityBox(
//                       title: community["title"]!,
//                       description: community["description"]!,
//                       link: community["link"]!,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.white,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.group), label: "Group"),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
//
//   Widget _communityBox({required String title, required String description, required String link}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[850],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.green,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             description,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: () async {
//               if (await canLaunch(link)) {
//                 await launch(link);
//               } else {
//                 throw 'Could not launch $link';
//               }
//             },
//             child: const Text(
//               "Discord Server Link",
//               style: TextStyle(
//                 color: Colors.blue,
//                 fontSize: 14,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GraphicDesignerScreen extends StatefulWidget {
  const GraphicDesignerScreen({super.key});

  @override
  _GraphicDesignerScreenState createState() => _GraphicDesignerScreenState();
}

class _GraphicDesignerScreenState extends State<GraphicDesignerScreen> {
  final List<Map<String, String>> communities = [
    {
      "title": "Graphic Era",
      "description":
      "Unleash your creativity and join our vibrant community of graphic designers, where ideas ignite and talents flourish.",
      "link": "https://discord.gg/6dmuHmVg",
      "name": "graphic_era", // Name in the Supabase table
    },
    {
      "title": "DesignConnect",
      "description": "Join a thriving community where inspiration flows.",
      "link": "https://discord.gg/cNm2rj4Q",
      "name": "design_connect", // Name in the Supabase table
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
        title: const Text('Graphic Designer'),
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
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.black,
      //   selectedItemColor: Colors.green,
      //   unselectedItemColor: Colors.white,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.group), label: "Group"),
      //     BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      // ),
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
                      color: Colors.green,
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
