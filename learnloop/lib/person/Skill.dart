import 'package:flutter/material.dart';

import '../main.dart';
import '../supabase_config.dart';



class SkillsEditPage extends StatefulWidget {
  final List<String> skills;
  final int profileUserId;

  const SkillsEditPage({super.key, required this.skills, required this.profileUserId});

  @override
  State<SkillsEditPage> createState() => _SkillsEditPageState();
}

class _SkillsEditPageState extends State<SkillsEditPage> {
  late List<String> skills;

  @override
  void initState() {
    super.initState();
    skills = widget.skills;
  }

  Future<void> _updateSkillsInDatabase() async {
    try {
      await SupabaseConfig.client
          .from('users')
          .update({'skills': skills}) // Update database with new skills list
          .eq('id', widget.profileUserId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Skills updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating skills: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //TextEditingController skillController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Skills"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: () async {
              final newSkill = await _addSkillDialog();
              if (newSkill != null && newSkill.isNotEmpty) {
                setState(() {
                  skills.add(newSkill);
                });
                await _updateSkillsInDatabase();  // Update in database
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(skills[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        setState(() {
                          skills.removeAt(index); // Remove skill
                        });
                        await _updateSkillsInDatabase();  // Update in database
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


  Future<String?> _addSkillDialog() async {
    TextEditingController skillController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Skill"),
        content:
        // TextField(
        //   controller: skillController,
        //   decoration: const InputDecoration(hintText: "Enter new skill"),
        // ),
        TextField(
          controller: skillController,
          cursorColor: Colors.white, // Cursor color
          decoration: InputDecoration(
            hintText: "Enter new Skill",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Line color when not focused
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Line color when focused
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.red),),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, skillController.text),
            child: const Text("Add", style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
    );
  }
}


// Skills Detail Page with Search
class SkillsDetailPage extends StatefulWidget {
  final List<String> skills;
  final bool isOwner;

  const SkillsDetailPage({super.key, required this.skills, required this.isOwner});

  @override
  State<SkillsDetailPage> createState() => _SkillsDetailPageState();
}

class _SkillsDetailPageState extends State<SkillsDetailPage> {
  List<String> displayedSkills = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedSkills = widget.skills;
  }

  void _filterSkills(String query) {
    final filtered = widget.skills
        .where((skill) => skill.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      displayedSkills = filtered;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skills"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search Skills",
                labelStyle: TextStyle(color: Colors.green), // Focused hole text green hobe
                prefixIcon: Icon(Icons.search, color: Colors.green), // Icon green hobe
                border: OutlineInputBorder(), // Normal border
                focusedBorder: OutlineInputBorder( // Focused state e green border
                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                ),
              ),
              cursorColor: Colors.green, // Cursor er color green
            ),

            const SizedBox(height: 16),

            // Skills List
            Expanded(
              child: ListView.builder(
                itemCount: displayedSkills.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(displayedSkills[index]),
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