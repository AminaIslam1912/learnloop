//
// import 'package:flutter/material.dart';
// import 'package:learnloop/request/received.dart';
// import 'package:learnloop/request/sent.dart';
// import 'package:learnloop/request/suggestion.dart';
// import 'package:learnloop/request/swapped.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:learnloop/supabase_config.dart';
//
// import '../UserProvider.dart';
// import '../person/UserProfile.dart';
//
// class RequestPage extends StatefulWidget {
//   @override
//   _RequestPageState createState() => _RequestPageState();
// }
//
// class _RequestPageState extends State<RequestPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }
//
//   @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       backgroundColor: Colors.black,
//   //       elevation: 2,
//   //       // leading: IconButton(
//   //       //   icon: Icon(Icons.arrow_back, color: Colors.black),
//   //       //   onPressed: () {},
//   //       // ),
//   //       title: Text(
//   //         'Request',
//   //         style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//   //       ),
//   //       centerTitle: true,
//   //       actions: [
//   //         // IconButton(
//   //         //   icon: Icon(Icons.search, color: Colors.black),
//   //         //   onPressed: () {},
//   //         // ),
//   //       ],
//   //       bottom: TabBar(
//   //         controller: _tabController,
//   //         labelColor: Colors.white,
//   //         unselectedLabelColor: Colors.grey,
//   //         labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//   //         indicatorColor: Colors.purple,
//   //         tabs: [
//   //           Tab(text: "Sent"),
//   //           Tab(text: "Received"),
//   //           Tab(text: "Suggested For You"),
//   //         ],
//   //       ),
//   //     ),
//   //
//   //
//   //     body: TabBarView(
//   //       controller: _tabController,
//   //       children: [
//   //         SentRequestsTab(),      // Updated Sent Requests Tab
//   //         ReceivedRequestsTab(),  // Updated Received Requests Tab
//   //         SuggestedForYouTab(),
//   //       ],
//   //     ),
//   //   );
//   // }
//   //
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 2,
//         title:  Text(
//                 'Request',
//                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//                centerTitle: true,
//
//          ),
//        //  actions: [
//        //    IconButton(
//        //      icon: const Icon(Icons.settings, color: Colors.white),
//        //      onPressed: () {
//        //        Scaffold.of(context).openDrawer();
//        //      },
//        //    ),
//        // ],
//     //  ),
//      //drawer: _buildSettingsDrawer(context),
//      body: Column(
//         children: [
//           Container(
//             color: Colors.black,
//             child: TabBar(
//               controller: _tabController,
//               labelColor: Colors.green,
//               //labelColor:Colors.green,
//               unselectedLabelColor: Colors.white,
//               indicatorColor: Colors.green,
//               tabs: const [
//                 Tab(text: "Sent"),
//                 Tab(text: "Received"),
//                 Tab(text: "Swapped"),
//                 Tab(text: "Suggested for you"),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 SentRequestsTab(),      // Updated Sent Requests Tab
//                 ReceivedRequestsTab(),  // Updated Received Requests Tab
//                 Swapped(),
//                 SuggestedForYouTab()
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
// }
//
//
//
//
//


import 'package:flutter/material.dart';
import 'package:learnloop/request/received.dart';
import 'package:learnloop/request/sent.dart';
import 'package:learnloop/request/suggestion.dart';
import 'package:learnloop/request/swapped.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    _checkSession(); // Check the session on page load
  }


  void _checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null && session.user != null) {
      // User is logged in
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(session.user!); // Update the user in the provider
    } else {
      // User is not logged in, redirect to SignUpPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access user login status
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
      body: isUserLoggedIn
          ? Column(
        children: [
          Container(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.green,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.green,
              tabs: const [
                Tab(text: "Sent"),
                Tab(text: "Received"),
                Tab(text: "Swapped"),
                Tab(text: "Suggested for you"),
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
          : Center(
        child: ElevatedButton(
          onPressed: () {
            Fluttertoast.showToast(
              msg: "Please login first",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          child: Text("Please Login to Access Requests"),
        ),
      ),
    );
  }
}




