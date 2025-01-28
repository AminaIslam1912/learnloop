
import 'dart:io';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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

  Widget _buildContactCard(
      {required String title,
        required String subtitle,
        required IconData icon,
        required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
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

  // Function to launch email intent
  void _launchEmail(String email) async {
    Uri emailUri;

    if (kIsWeb) {
      // Use Gmail's web URL for the web environment
      emailUri =
          Uri.parse('https://mail.google.com/mail/?view=cm&fs=1&to=$email');
    } else if (Platform.isAndroid || Platform.isIOS) {
      // Use the mailto scheme for mobile (Android/iOS)
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

  // Function to launch phone dialer intent
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
                fontSize: 30, // Increase font size for better prominence
                fontWeight: FontWeight.bold, // Bold text for emphasis
                fontFamily: 'Roboto', // Optional: Use a custom font family
                color: Colors.white, // Attractive color
                letterSpacing:
                1.5, // Slightly increase letter spacing for better readability
                height: 1.4, // Adjust height for improved line spacing
              ),
            ),

            const SizedBox(height: 20),
            const BlinkText(
              '        Share, learn and grow skills',
              duration: Duration(seconds: 1),
              style: TextStyle(
                fontSize: 18, // Slightly larger text size for better visibility
                fontWeight: FontWeight.bold, // Makes the text bold
                fontFamily:
                'Roboto Mono', // Optional: Customize font family for a more unique look
                color: Colors.green, // Change text color to blue

                letterSpacing: 1.2, // Adds some spacing between letters
                height: 1.5, // Adjusts line height for better readability
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
                        width: 16), // Space between image and text
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
                        width: 16), // Space between image and text
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
                        width: 16), // Space between image and text
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
                        width: 16), // Space between image and text
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
                        width: 16), // Space between image and text
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
                        width: 16), // Space between image and text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('Personalized user profiles with feedback integration.',  style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),),

                        ],
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            SizedBox(width: 8),
                            Text('You can see the user feedback from that person"s profile. You can also give feedback to your mentor')
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
                        width: 16), // Space between image and text
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
                          radius: 40,
                          backgroundImage: AssetImage(
                            member['image'] ?? 'assets/default_image.png',
                          ),
                        ),
                        const SizedBox(
                            width: 16), // Space between image and text
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
            const Text(
              'Our App Rating ',
              style: TextStyle(fontSize: 16),
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
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
