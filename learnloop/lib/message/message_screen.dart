// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// //import 'chat_screen.dart';
// class MessageScreen extends StatefulWidget {
//   @override
//   _MessageScreenState createState() => _MessageScreenState();
// }
//
// class _MessageScreenState extends State<MessageScreen> {
//   List<Map<String, dynamic>> users = [];
//   //<int> requestReceivedIds = [];
//   List<int> friendIds = [];
//   bool isLoading = true;
//   String userIdFromLogin ;
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserRequests();
//   }
//
//   Future<void> fetchUserRequests() async {
//     final url = Uri.parse('https://fnzulmmhahivejgonepd.supabase.co/rest/v1/users?id=eq.$userIdFromLogin');
//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZuenVsbW1oYWhpdmVqZ29uZXBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUxODc2NDEsImV4cCI6MjA1MDc2MzY0MX0.IO9WN7cAVMDvzbXY_EWpOAvpLQcFDjqrWxpmxS3Mp8E',
//         'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZuenVsbW1oYWhpdmVqZ29uZXBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUxODc2NDEsImV4cCI6MjA1MDc2MzY0MX0.IO9WN7cAVMDvzbXY_EWpOAvpLQcFDjqrWxpmxS3Mp8E',
//         'Accept': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       if (data.isNotEmpty) {
//         // requestReceivedIds = List<int>.from(data[0]['request_received'] ?? []);
//         // Extract the 'id' values from the list of objects and create a list of integers
//         // requestReceivedIds = List<int>.from(data.map((item) => item['id'] as int));
//         // Check if the 'request_received' field exists and is a List
//         //var requestReceivedData = data[0]['request_received'];
//         var friendsData = data[0]['friends'];
//
//         // If request_received is a list of objects, extract the 'id' values as integers
//         if (friendsData is List) {
//           friendIds = List<int>.from(friendsData.map((item) => item['id'] as int));
//         } else {
//           print("request_received is not in the expected format");
//         }
//
//         print('Request Received IDs: $friendIds');
//         fetchUsersByRequestIds();
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         print('No user found with ID: $userIdFromLogin');
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error fetching user requests: ${response.body}');
//     }
//   }
//
//   Future<void> fetchUsersByRequestIds() async {
//     if (friendIds.isEmpty) {
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }
//
//     final ids = friendIds.join(',');
//     final url = Uri.parse('https://fnzulmmhahivejgonepd.supabase.co/rest/v1/users?id=in.($ids)');
//
//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZuenVsbW1oYWhpdmVqZ29uZXBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUxODc2NDEsImV4cCI6MjA1MDc2MzY0MX0.IO9WN7cAVMDvzbXY_EWpOAvpLQcFDjqrWxpmxS3Mp8E',
//         'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZuenVsbW1oYWhpdmVqZ29uZXBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUxODc2NDEsImV4cCI6MjA1MDc2MzY0MX0.IO9WN7cAVMDvzbXY_EWpOAvpLQcFDjqrWxpmxS3Mp8E',
//         'Accept': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       setState(() {
//         users = data.map<Map<String, dynamic>>((item) => {
//           'name': item['name'] ?? 'Unknown',
//         }).toList();
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error fetching users by request IDs: ${response.body}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF3D3D75),
//         leading: Icon(Icons.arrow_back, color: Colors.white),
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.grey,
//               radius: 16,
//               child: Icon(Icons.person, color: Colors.white),
//             ),
//             SizedBox(width: 12),
//             Text('Messages', style: TextStyle(color: Colors.white)),
//           ],
//         ),
//         actions: [
//           Icon(Icons.search, color: Colors.white),
//           SizedBox(width: 16),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : users.isEmpty
//           ? Center(child: Text('No users available'))
//           : ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           final userName = users[index]['name'];
//           return _buildUserTile(context, userName);
//         },
//       ),
//       bottomNavigationBar: BottomNavBar(),
//     );
//   }
//
//   Widget _buildUserTile(BuildContext context, String userName) {
//     return ListTile(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(name: userName, userIdFromLogin: userIdFromLogin,))),
//       leading: CircleAvatar(child: Icon(Icons.person, color: Colors.white)),
//       title: Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
//     );
//   }
//
//   BottomNavBar() {}
// }
//
