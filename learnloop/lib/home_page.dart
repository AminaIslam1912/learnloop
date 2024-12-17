import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        // title: Text(
        //   'Home Page',
        //   style: TextStyle(color: Colors.black),
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Opens the settings drawer
            },
          ),
        ],
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(50),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.grey[200],
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       child: TextField(
        //         decoration: InputDecoration(
        //           hintText: 'Search...',
        //           prefixIcon: Icon(Icons.search, color: Colors.grey),
        //           border: InputBorder.none,
        //           contentPadding: EdgeInsets.symmetric(horizontal: 16),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
      body: Container(
          decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_app.png'), // Background image
          fit: BoxFit.cover,
        ),
      )),
      drawer: _buildSettingsDrawer(),
    );
  }

//   Widget _buildSettingsDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: Text(
//               'Settings',
//               style: TextStyle(color: Colors.white, fontSize: 24),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text('Personal Details'),
//             onTap: () {
//               // Handle Personal Details navigation
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.group),
//             title: Text('Community'),
//             onTap: () {
//               // Handle Community navigation
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.notifications),
//             title: Text('Notifications'),
//             onTap: () {
//               // Handle Notifications navigation
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.schedule),
//             title: Text('Time Table'),
//             onTap: () {
//               // Handle Time Table navigation
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.history),
//             title: Text('History'),
//             onTap: () {
//               // Handle History navigation
//             },
//           ),
//           SwitchListTile(
//             title: Text('Theme'),
//             value: false,
//             onChanged: (value) {
//               // Handle theme toggle
//             },
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.help),
//             title: Text('Help and Feedback'),
//             onTap: () {
//               // Handle Help navigation
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text('Log Out'),
//             onTap: () {
//               // Handle Log Out
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

  Widget _buildSettingsDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
       //   color: Colors.black.withOpacity(0.5), // Semi-transparent background
          color: Colors.black.withOpacity(0.5), // Transparent color

        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7), // Semi-transparent header
              ),
              child: const Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Personal Details', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle Personal Details navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.white),
              title: const Text('Community', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle Community navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text('Notifications', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle Notifications navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.white),
              title: const Text('Time Table', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle Time Table navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white),
              title: const Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle History navigation
              },
            ),
            SwitchListTile(
              title: const Text('Theme', style: TextStyle(color: Colors.white)),
              value: false,
              onChanged: (value) {
                // Handle theme toggle
              },
              activeColor: Colors.white,
            ),
            const Divider(color: Colors.white), // Divider color adjusted for visibility
            ListTile(
              leading: const Icon(Icons.help, color: Colors.white),
              title: const Text('Help and Feedback', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle Help navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Log Out', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Handle Log Out
              },
            ),
          ],
        ),
      ),
    );
  }
}
