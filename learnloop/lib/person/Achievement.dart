import 'package:flutter/material.dart';

class AchievementEditPage extends StatefulWidget {
  final List<String> achievements;

  const AchievementEditPage({super.key, required this.achievements});

  @override
  State<AchievementEditPage> createState() => _AchievementEditPageState();
}

class _AchievementEditPageState extends State<AchievementEditPage> {
  late List<String> achievements;

  List<String> displayedAc = [];



  @override
  void initState() {
    super.initState();
    achievements = widget.achievements;
    displayedAc = widget.achievements;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController acController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Achievements"),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.check),
          //   onPressed: () => Navigator.pop(context, skills), // Save and return
          // ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newAc = await _addAchievementsDialog();
              if (newAc != null && newAc.isNotEmpty) {
                setState(() {
                  widget.achievements.add(newAc);
                  displayedAc = widget.achievements;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: acController,
              decoration: const InputDecoration(labelText: "Add Achievements"),
              onSubmitted: (value) {
                setState(() {
                  achievements.add(value);
                  acController.clear();
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(achievements[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          achievements.removeAt(index); // Remove skill
                        });
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
