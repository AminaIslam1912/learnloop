import 'package:flutter/material.dart';
import 'package:learnloop/request/received.dart';
import 'package:learnloop/request/sent.dart';
import 'package:learnloop/request/suggestion.dart';
import 'package:learnloop/request/swapped.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../UserProvider.dart';
import '../sign_up.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  get Fluttertoast => null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _checkSession();
  }


  void _checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null && session.user != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(session.user!);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUserLoggedIn = Provider.of<UserProvider>(context).isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 2,
        title: Text(
          'Request',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
     // isUserLoggedIn?
      Column(
        children: [
          Container(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.green,
              tabs:  [
              Tab(
                child: Marquee(
                  blankSpace: 72,
                  text: "Sent",
                  style: const TextStyle(color: Colors.green),
                  velocity: 15,
                   pauseAfterRound: Duration(seconds: 2),
                ),
              ),
              Tab(
                child: Marquee(
                  text: "Received",
                  blankSpace: 40,
                  style: const TextStyle(color: Colors.green),
                  velocity: 15,
                   pauseAfterRound: Duration(seconds: 2),
                ),
              ),
              Tab(
                child: Marquee(
                  text: "Swapped",
                  blankSpace: 40,
                  style: const TextStyle(color: Colors.green),
                  velocity: 15,
                   pauseAfterRound: Duration(seconds: 2),
                ),
              ),
              Tab(
                child: Marquee(

                  text: "Suggested for you",
                  blankSpace: 25,
                  style: const TextStyle(color: Colors.green),
                  velocity: 15,
                   pauseAfterRound: Duration(seconds: 2),
                ),
              ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SentRequestsTab(),
                ReceivedRequestsTab(),
                Swapped(),
                SuggestedForYouTab(),
              ],
            ),
          ),
        ],
      )
    );
  }
}




