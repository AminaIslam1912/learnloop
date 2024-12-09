import 'package:flutter/material.dart';


class SkillsEditPage extends StatefulWidget {
  final List<String> skills;

  const SkillsEditPage({super.key, required this.skills});

  @override
  _SkillsEditPageState createState() => _SkillsEditPageState();
}

class _SkillsEditPageState extends State<SkillsEditPage> {
  late List<String> skills;

  List<String> displayedSkills = [];



  @override
  void initState() {
    super.initState();
    skills = widget.skills;
    displayedSkills = widget.skills;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController skillController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Skills"),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.check),
          //   onPressed: () => Navigator.pop(context, skills), // Save and return
          // ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newSkill = await _addSkillDialog();
              if (newSkill != null && newSkill.isNotEmpty) {
                setState(() {
                  widget.skills.add(newSkill);
                  displayedSkills = widget.skills;
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
              controller: skillController,
              decoration: const InputDecoration(labelText: "Add Skill"),
              onSubmitted: (value) {
                setState(() {
                  skills.add(value);
                  skillController.clear();
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: skills.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(skills[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          skills.removeAt(index); // Remove skill
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

  Future<String?> _addSkillDialog() async {
    TextEditingController skillController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Skill"),
        content: TextField(
          controller: skillController,
          decoration: const InputDecoration(hintText: "Enter new skill"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, skillController.text),
            child: const Text("Add"),
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
  _SkillsDetailPageState createState() => _SkillsDetailPageState();
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
        // actions: widget.isOwner
        //     ? [
        //   IconButton(
        //     icon: Icon(Icons.add),
        //     onPressed: () async {
        //       final newSkill = await _addSkillDialog();
        //       if (newSkill != null && newSkill.isNotEmpty) {
        //         setState(() {
        //           widget.skills.add(newSkill);
        //           displayedSkills = widget.skills;
        //         });
        //       }
        //     },
        //   ),
        // ]
        // : null,
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterSkills,
            ),
            const SizedBox(height: 16),

            // Skills List
            Expanded(
              child: ListView.builder(
                itemCount: displayedSkills.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(displayedSkills[index]),
                    // trailing: widget.isOwner
                    //     ? IconButton(
                    //   icon: const Icon(Icons.delete),
                    //   onPressed: () {
                    //     setState(() {
                    //       widget.skills.remove(displayedSkills[index]);
                    //       displayedSkills = widget.skills;
                    //     });
                    //   },
                    // )
                    //     : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<String?> _addSkillDialog() async {
  //   TextEditingController skillController = TextEditingController();
  //   return showDialog<String>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Add Skill"),
  //       content: TextField(
  //         controller: skillController,
  //         decoration: const InputDecoration(hintText: "Enter new skill"),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Cancel"),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, skillController.text),
  //           child: const Text("Add"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
