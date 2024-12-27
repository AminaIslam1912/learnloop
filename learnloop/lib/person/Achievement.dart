import 'package:flutter/material.dart';

import '../main.dart';

class AchievementEditPage extends StatefulWidget {
  final List<String> achievements;
  final int profileUserId;

  const AchievementEditPage({super.key, required this.achievements, required this.profileUserId});

  @override
  State<AchievementEditPage> createState() => _AchievementEditPageState();
}

class _AchievementEditPageState extends State<AchievementEditPage> {
  late List<String> achievements;

  @override
  void initState() {
    super.initState();
    achievements = widget.achievements;
  }

  Future<void> _updateAchievementsInDatabase() async {
    try {
      await SupabaseConfig.client
          .from('users')
          .update({'achievements': achievements}) // Update database with new skills list
          .eq('id', widget.profileUserId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Achievements updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating achievements: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //TextEditingController acController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Achievements"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newAc = await _addAchievementsDialog();
              if (newAc != null && newAc.isNotEmpty) {
                setState(() {
                  achievements.add(newAc);
                });
                await _updateAchievementsInDatabase();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField(
            //   controller: acController,
            //   decoration: const InputDecoration(labelText: "Add Achievements"),
            //   onSubmitted: (value) {
            //     setState(() {
            //       achievements.add(value);
            //       acController.clear();
            //     });
            //   },
            // ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(achievements[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async{
                        setState(() {
                          achievements.removeAt(index); // Remove skill
                        });
                        await _updateAchievementsInDatabase();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _addAchievementsDialog() async {
    TextEditingController acController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Achievements"),
        content: TextField(
          controller: acController,
          decoration: const InputDecoration(hintText: "Enter new Achievements"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, acController.text),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

class AchievementsDetails extends StatefulWidget {

  final List<String> achievements;
  final bool isOwner;

  const AchievementsDetails({super.key, required this.achievements, required this.isOwner});

  @override
  State<AchievementsDetails> createState() => _AchievementsDetailsState();
}

class _AchievementsDetailsState extends State<AchievementsDetails> {

  List<String> displayedAchievements = [];

  @override
  void initState() {
    super.initState();
    displayedAchievements = widget.achievements;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Achievements List
            Expanded(
              child: ListView.builder(
                itemCount: displayedAchievements.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(displayedAchievements[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
