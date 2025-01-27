import 'package:flutter/material.dart';
import 'package:learnloop/person/UserProfile.dart';
import 'package:learnloop/sign_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'UserProvider.dart';
import 'chat/screen/ChatPage.dart';
import 'request/request_sent.dart';
import 'homelander/home_page.dart';
import 'homelander/community/Community_ui.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  int? _userId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeUserState();
  }

  Future<void> initializeUserState() async {
    // Get the current session
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null && !_isInitialized) {
      // Get the current user from the session
      final currentUser = session.user;

      // Update the UserProvider with the current user
      if (context.mounted) {
        context.read<UserProvider>().setUser(currentUser);
      }

      // Fetch and set the user ID
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select('id')
            .eq('email', currentUser.email as Object)
            .single();

        if (response != null && response['id'] is int && mounted) {
          setState(() {
            _userId = response['id'];
            _isInitialized = true;
          });
          print('Fetched User ID: $_userId');
        }
      } catch (error) {
        print('Error fetching user ID: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          const HomePage(),

          if (_userId == null)
            const Center(
              child: SignUpPage(),
            )
          else
            RequestPage(),
          //const Center(child: Text('Messages')),

          if (_userId == null)
            const Center(
              child: SignUpPage(),
            )
          else
            ChatPage(),
          if (_userId == null)
            const Center(
              child: SignUpPage(),
            )
          else
            UserProfile(
              loggedInUserId: _userId!,
              profileUserId: _userId!,
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Request"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
