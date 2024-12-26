
import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF264E70),
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
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SentRequestsTab(),      // Updated Sent Requests Tab
          ReceivedRequestsTab(),  // Updated Received Requests Tab
        ],
      ),
    );
  }
}

class SentRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_app.png'), // Background image
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          buildSentCard(
              name: "Robbie Harrison",
              role: "Musician",
              experience: "5 years",
              stats: {"likes": "3k+", "followers": "65+"},
              //  imageUrl: "https://via.placeholder.com/150", // Replace with actual image
              backImage:"assets/PICforREGISTRATION.jpg"
          ),
          SizedBox(height: 16),
          buildSentCard(
              name: "James Smith",
              role: "Musician",
              experience: "5 years",
              stats: {"likes": "5k+", "followers": "60+"},
              //imageUrl: "https://via.placeholder.com/150", // Replace with actual image
              backImage:"assets/PICforREGISTRATION.jpg"

          ),
        ],
      ),
    );
  }

  Widget buildSentCard({
    required String name,
    required String role,
    required String experience,
    required Map<String, String> stats,
    // required String imageUrl,
    required String backImage
  }) {
    return Card(
      color: Colors.black.withOpacity(0.5), // Transparent color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(backImage),
              radius: 30,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
                  Text('Experience: $experience', style: TextStyle(color: Color(0xE1DADAFF))),
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text(stats['likes']!, style: TextStyle(color: Colors.white)),
                      SizedBox(width: 16),
                      Icon(Icons.flash_on, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(stats['followers']!, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                // Handle menu selection
              },
              itemBuilder: (BuildContext context) {
                // return ['Seen', 'Accepted', 'Declined']
                //     .map((choice) => PopupMenuItem<String>(
                //   value: choice,
                //   child: Text(choice),
                // ))
                //     .toList();
                return [
                  PopupMenuItem<String>(
                    value: 'Seen',
                    child: Text('Seen'),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'Accepted',
                    child: Text('Accepted'),
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'Declined',
                    child: Text('Declined'),
                  ),



                ];
              },
              icon: Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ReceivedRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_app.png'), // Background image
          fit: BoxFit.cover,
        ),
      ),
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          buildReceivedCard(
            name: "Robbie Harrison",
            role: "Musician",
            experience: "5 years",
            stats: {"likes": "3k+", "followers": "65+"},
            actionButtons: ["Accept", "Delete"],
          ),
          SizedBox(height: 16),
          buildReceivedCard(
            name: "Jessamine Mumtaz",
            role: "Designer",
            experience: "4 years",
            stats: {"likes": "258", "followers": "23"},
            actionButtons: ["Accept", "Delete"],
          ),
        ],
      ),
    );
  }

  Widget buildReceivedCard({
    required String name,
    required String role,
    required String experience,
    required Map<String, String> stats,
    required List<String> actionButtons,
  }) {
    return Card(
      color: Colors.black.withOpacity(0.5), // Transparent color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  // backgroundImage: NetworkImage("https://via.placeholder.com/150"),
                  backgroundImage: AssetImage('assets/PICforREGISTRATION.jpg'),
                  radius: 30,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(role, style: TextStyle(color: Color(0xE1DADAFF))),
                      Text('Experience: $experience', style: TextStyle(color: Color(0xE1DADAFF))),
                      Row(
                        children: [
                          Icon(Icons.favorite, size: 16, color: Colors.red),
                          SizedBox(width: 4),
                          Text(stats['likes']!, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: actionButtons.map((btn) {
                return Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btn == "Delete" ? Color(0xFFFDA89C) : Color(0xFF679186),
                      foregroundColor: btn == "Delete" ? Colors.black : Colors.white,
                    ),
                    child: Text(btn),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}