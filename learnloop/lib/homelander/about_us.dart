import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "About",
          style: TextStyle(
            fontFamily: 'PlayfairDisplay', // Beautiful Flutter font
            fontSize: 24,
            color: Colors.green,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "LearnLoop is an app designed to facilitate peer-to-peer skill sharing, enabling users to connect, share talents, and gain knowledge from one another. The app allows users to schedule lessons with peers, chat to arrange sessions, and submit and receive skill-swap requests.\n\n"
                  "Key features include personal profiles, a community area, access to both free and paid courses, and tools to monitor learning progress. LearnLoop aims to create a cooperative learning environment that fosters skill development and personal growth.\n\n"
                  "Additionally, the app features a “Fun Challenge” which offers tailored options based on skill level: users without skills can start with the “Learn” (free or paid) option, while users with existing skills can use the “Swap” (free) option to further enhance their abilities.",
              style: TextStyle(
                fontFamily: 'PlayfairDisplay', // Built-in elegant font
                fontSize: 18,
                color: Colors.white,
                height: 1.5, // Adjust line height for readability
              ),
              textAlign: TextAlign
                  .justify, // Justify the text for better appearance
            ),
          ),
        ),
      ),
    );
  }
}