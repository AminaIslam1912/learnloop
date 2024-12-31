import 'package:learnloop/homelander/community/problemsolvers.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'graphics.dart';
//import 'problemsolvers.dart'; // Import the new screen
import '../../MainPage.dart';
import 'graphics.dart';
import '../home_page.dart'; // Import the CourseUI screen

class CommunityUI extends StatefulWidget {
  final User? user;
  //const CommunityUI({super.key});
  const CommunityUI({Key? key, this.user}) : super(key: key);


  @override
  _CommunityUIState createState() => _CommunityUIState();
}

class _CommunityUIState extends State<CommunityUI> {
  String? selectedCommunity;

  void _selectCommunity(String community) {
    setState(() {
      selectedCommunity = community;
    });
    if (community == "Graphic Designer") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GraphicDesignerScreen()),
      );
    } else if (community == "Problem Solvers") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProblemSolversScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the CourseUI screen when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
        return false; // Prevent default back button action
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Community'),
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search community',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white54),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _communityBox('Graphic Designer', Colors.green),
                    _communityBox('Problem Solvers', Colors.orange),
                  ],
                ),
              ),
            ],
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
      ),
    );
  }

  Widget _communityBox(String community, Color color) {
    bool isSelected = selectedCommunity == community;

    return GestureDetector(
      onTap: () {
        _selectCommunity(community);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.8) : color.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              community,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}