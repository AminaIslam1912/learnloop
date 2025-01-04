
import 'package:flutter/material.dart';
import 'package:learnloop/request/received.dart';
import 'package:learnloop/request/sent.dart';
import 'package:learnloop/request/suggestion.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learnloop/supabase_config.dart';

import '../UserProvider.dart';
import '../person/UserProfile.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009252),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          'Request',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          indicatorColor: Colors.purple,
          tabs: [
            Tab(text: "Sent"),
            Tab(text: "Received"),
            Tab(text: "Suggested For You"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SentRequestsTab(),      // Updated Sent Requests Tab
          ReceivedRequestsTab(),  // Updated Received Requests Tab
          SuggestedForYouTab(),
        ],
      ),
    );
  }
}





