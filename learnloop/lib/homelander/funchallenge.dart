import 'package:flutter/material.dart';

class FunChallengeScreen extends StatelessWidget {
  const FunChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Fun Challenge",
          style: TextStyle(color: Colors.green, fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the Course UI
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose your challenge",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total Score:",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 challenges per row
                    mainAxisSpacing: 16, // Space between rows
                    crossAxisSpacing: 16, // Space between columns
                  ),
                  itemCount: challenges.length,
                  itemBuilder: (context, index) {
                    final challenge = challenges[index];
                    return _buildChallengeCard(challenge);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Group"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    return GestureDetector(
      onTap: () {
        // Action when challenge is selected
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green, // Green background consistent with the theme
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              challenge.icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              challenge.name,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class Challenge {
  final String name;
  final IconData icon;

  Challenge({required this.name, required this.icon});
}

final List<Challenge> challenges = [
  Challenge(name: "Photography", icon: Icons.camera_alt),
  Challenge(name: "Coding", icon: Icons.code),
  Challenge(name: "Music", icon: Icons.music_note),
  Challenge(name: "Cooking", icon: Icons.restaurant),
  Challenge(name: "Communication", icon: Icons.person),
  Challenge(name: "Time Management", icon: Icons.timelapse),
];
