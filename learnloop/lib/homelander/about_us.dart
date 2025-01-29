
import 'dart:io';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}
class _AboutScreenState extends State<AboutScreen> {
  final String email = 'a1ndroiddevelopment@gmail.com';
  final String phoneNumber = '01815267528';

  final List<Map<String, String>> members = const [
    {
      'image': 'assets/moha.jpg',
      'name': 'Farzana Tasnim',
      'roll': '14',
      'email': 'farzana@gmail.com',
    },
    {
      'image': 'assets/rose.jpg',
      'name': 'Md.Abu Kawser',
      'roll': '33',
      'email': 'kawser@gmail.com'
    },
    {
      'image': 'assets/moha.jpg',
      'name': 'Amina Islam',
      'roll': '36',
      'email': 'amina@gmail.com',
    },
    {
      'image': 'assets/rose.jpg',
      'name': 'Rubaiya Tarannum Mrittika',
      'roll': '49',
      'email': 'mrittika@gmail.com',
    },
  ];

  double _averageRating = 0.0;
  int _totalFeedbacks = 0;

  Future<void> fetchAverageRating() async {
    try {
      final response = await Supabase.instance.client.from('app_feedback').select('rating');

      if (response != null && response.isNotEmpty) {
        final List data = response as List;

        if (data.isNotEmpty) {
          setState(() {
            _totalFeedbacks = data.length;
            _averageRating = data
                .map((item) => (item['rating'] as num).toDouble())
                .reduce((a, b) => a + b) /
                _totalFeedbacks;
          });
        } else {
          setState(() {
            _totalFeedbacks = 0;
            _averageRating = 0.0;
          });
        }
      }
    } catch (e) {
      print('Exception occurred while fetching average rating: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAverageRating();
  }

  Widget _buildContactCard(
      {required String title,
        required String subtitle,
        required IconData icon,
        Color iconColor = Colors.green,
        required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _launchEmail(String email) async {
    Uri emailUri;

    if (kIsWeb) {
      emailUri =
          Uri.parse('https://mail.google.com/mail/?view=cm&fs=1&to=$email');
    } else if (Platform.isAndroid || Platform.isIOS) {
      emailUri = Uri(
        scheme: 'mailto',
        path: email,
      );
    } else {
      throw 'Unsupported platform';
    }

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '          Learnloop',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.white,
                letterSpacing:
                1.5,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),
            const BlinkText(
              '        Share, learn and grow skills',
              duration: Duration(seconds: 1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily:
                'Roboto Mono',
                color: Colors.green,

                letterSpacing: 1.2,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Learnloop is a dynamic platform that facilitates skill exchanging, offers free courses, builds a community of collaborators, and offers enjoyable challenges in an effort to empower individuals. Whether you're looking to learn new skills, share your expertise with others, connect with like-minded people, or challenge yourself with exciting tasks, Learnloop is your one-stop destination for growth, learning, and fun!",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 32),

            const SizedBox(height: 8),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ExpansionTile(
                title: Row(
                  children: [

                    SizedBox(
                        width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Peer-to-peer skill swap',  style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Icon( Icons.expand_more, color: Colors.green),

                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            SizedBox(width: 8),
                            Expanded(child: Text('Can Swap Skills. You can give swap request from a person"s profile'))
                          ],
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ExpansionTile(
                title: Row(
                  children: [

                    SizedBox(
                        width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Free course for beginners.',  style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),),

                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Icon( Icons.expand_more, color: Colors.green),

                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            SizedBox(width: 8),
                            Expanded(child: Text('Beginner friendly free courses. One can read document and video to learn'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ExpansionTile(
                title: Row(
                  children: [

                    SizedBox(
                        width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Community to learn particular topics.',  style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),),

                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Icon( Icons.expand_more, color: Colors.green),

                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            SizedBox(width: 8),
                            Expanded(child: Text('Join community to learn particular topics'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ExpansionTile(
                title: Row(
                  children: [

                    SizedBox(
                        width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Real-time chat to collaborate with others.',  style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Icon( Icons.expand_more, color: Colors.green),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            SizedBox(width: 8),
                            Expanded(child: Text('One can do real time chatting. Join class option also give you to communicate real time'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ExpansionTile(
                title: Row(
                  children: [

                    SizedBox(
                        width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fun challenge for refreshment.',  style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Icon( Icons.expand_more, color: Colors.green),

                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            SizedBox(width: 8),
                            Expanded(child: Text('You can refresh yourself by playing fun challenge. Skill related challenges are there.'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ExpansionTile(
                title: Row(
                  children: [

                    SizedBox(
                        width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('Personalized user profiles with feedback integration and CV uploading facility.',  style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),),

                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Icon( Icons.expand_more, color: Colors.green),

                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            SizedBox(width: 8),
                           Expanded(child: Text('You can see the user feedback from that person"s profile.You can also give feedback to your mentor and add CV in your own profile.'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ExpansionTile(
                title: Row(
                  children: [

                    SizedBox(
                        width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Progress tracking facility.',  style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Icon( Icons.expand_more, color: Colors.green),

                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            SizedBox(width: 8),
                            Expanded(child: Text('One can keep track of their progress by the count of their swap ratio.'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ExpansionTile(
                title: Row(
                  children: [

                    SizedBox(
                        width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categorized quizzes for learning advanced topics.',  style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: Icon( Icons.expand_more, color: Colors.green),

                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            SizedBox(width: 8),
                            Expanded(child: Text('You can play quizzes. They are category based. Learn new skills!'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),



            const SizedBox(height: 32),
            const Text(
              'Developer Info:\nThis our CSE-2216 course project. Our team members are : ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            for (var member in members)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/default_image.jpg',
                          ),
                        ),
                        const SizedBox(
                            width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member['name'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon( Icons.expand_more, color: Colors.green),

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.school,
                                    size: 20, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  'Roll: ${member['roll'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.email,
                                    size: 20, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  member['email'] ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
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

            const SizedBox(height: 32),
            const Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email section
                _buildContactCard(
                  title: 'Email',
                  subtitle: email,
                  icon: Icons.email,
                  onTap: () {
                    _launchEmail(email);
                  },
                ),
                const SizedBox(height: 20),
                // Phone section
                _buildContactCard(
                  title: 'Phone',
                  subtitle: phoneNumber,
                  icon: Icons.phone,
                  onTap: () {
                    _launchPhone(phoneNumber);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
             Text(
              'Our App Rating: ${_averageRating.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Last updated: Jan 11, 2025',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Text(
              'Privacy Policy & Terms of Service',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
