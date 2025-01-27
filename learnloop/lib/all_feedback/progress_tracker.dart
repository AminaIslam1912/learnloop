// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class ProgressTracker extends StatefulWidget {
//   const ProgressTracker({super.key});
//
//   @override
//   State<ProgressTracker> createState() => _ProgressTrackerState();
// }
//
// class _ProgressTrackerState extends State<ProgressTracker> {
//   late User? _user;
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch the current user when the widget initializes
//     _user = Supabase.instance.client.auth.currentUser;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Progress Tracker'),
//       ),
//       body: Center(
//         child: _user != null
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "User Information",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "User ID: ${_user!.id}",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "Email: ${_user!.email ?? "No email available"}",
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         )
//             : const Text(
//           "No user is logged in",
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
//
// class ProgressTracker extends StatefulWidget {
//   const ProgressTracker({super.key});
//
//   @override
//   State<ProgressTracker> createState() => _ProgressTrackerState();
// }
//
// class _ProgressTrackerState extends State<ProgressTracker> {
//   late User? _user;
//   int? _intId; // To store the integer ID from the database
//   bool _isLoading = true; // Loading state
//   String? _errorMessage; // To store any error message
//
//   @override
//   void initState() {
//     super.initState();
//     _user = Supabase.instance.client.auth.currentUser;
//     if (_user != null) {
//       _fetchUserIntId(); // Fetch the integer ID
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _fetchUserIntId() async {
//     try {
//       // Query the Supabase database
//       final response = await Supabase.instance.client
//           .from('users') // Table name
//           .select('id') // Select the integer ID column
//           .eq('email', _user!.email as Object) // Match the email with the logged-in user's email
//           .single(); // Expect a single result
//
//       setState(() {
//         _intId = response['id'] as int; // Extract the integer ID
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to fetch data: $e';
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Progress Tracker'),
//       ),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : _errorMessage != null
//             ? Text(
//           _errorMessage!,
//           style: const TextStyle(color: Colors.red),
//         )
//             : _user != null
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "User Information",
//               style: TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "User ID (UUID): ${_user!.id}",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "Email: ${_user!.email ?? "No email available"}",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "Int ID: ${_intId ?? "Not available"}",
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         )
//             : const Text(
//           "No user is logged in",
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
//
//



import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class ProgressTracker extends StatefulWidget {
  const ProgressTracker({super.key});

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  late User? _user;
  int? _intId; // Logged-in user's integer ID
  int taughtThemCount = 0; // Number of people taught
  int taughtMeCount = 0; // Number of times taught by others
  bool _isLoading = true; // Loading state
  String? _errorMessage; // Error message

  @override
  void initState() {
    super.initState();
    _user = Supabase.instance.client.auth.currentUser;
    if (_user != null) {
      _fetchUserIntId();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _fetchUserIntId() async {
  //   try {
  //     // Fetch the logged-in user's integer ID and data
  //     final response = await Supabase.instance.client
  //         .from('users')
  //         .select('id, userFeedback, friends')
  //         .eq('email', _user!.email as Object)
  //         .single();
  //
  //     final intId = response['id'] as int;
  //
  //     // Parse userFeedback and friends safely
  //     final userFeedback = response['userFeedback'] is String
  //         ? jsonDecode(response['userFeedback']) as List
  //         : response['userFeedback'] as List;
  //
  //     final friends = response['friends'] is String
  //         ? jsonDecode(response['friends']) as List
  //         : response['friends'] as List;
  //
  //     int taughtThem = userFeedback.length;
  //
  //     print("id is $intId");
  //     print("them $taughtThem");
  //
  //     int taughtMe = 0;
  //     for (var friend in friends) {
  //       // Fetch each friend's userFeedback
  //       final friendResponse = await Supabase.instance.client
  //           .from('users')
  //           .select('userFeedback')
  //           .eq('id', friend['id'])
  //           .single();
  //
  //       final friendFeedback = friendResponse['userFeedback'] is String
  //           ? jsonDecode(friendResponse['userFeedback']) as List
  //           : friendResponse['userFeedback'] as List;
  //
  //       // Count occurrences of the logged-in user's int ID in the friend's feedback
  //       taughtMe += friendFeedback.where((feedback) => feedback['id'] == intId).length;
  //     }
  //
  //     print("me $taughtMe");
  //
  //     setState(() {
  //       _intId = intId;
  //       taughtThemCount = taughtThem;
  //       taughtMeCount = taughtMe;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'Failed to fetch data: $e';
  //       _isLoading = false;
  //     });
  //   }
  // }


  Future<void> _fetchUserIntId() async {
    try {
      // Fetch the logged-in user's integer ID and data
      final response = await Supabase.instance.client
          .from('users')
          .select('id, userFeedback, friends')
          .eq('email', _user!.email as Object)
          .single();

      final intId = response['id'] as int;

      // Check if userFeedback is not null and safely parse it
      final userFeedback = response['userFeedback'] != null && response['userFeedback'] is String
          ? jsonDecode(response['userFeedback']) as List
          : response['userFeedback'] as List? ?? [];

      // Check if friends is not null and safely parse it
      final friends = response['friends'] != null && response['friends'] is String
          ? jsonDecode(response['friends']) as List
          : response['friends'] as List? ?? [];

      int taughtThem = userFeedback.length;

      print("id is $intId");
      print("them $taughtThem");

      int taughtMe = 0;
      for (var friend in friends) {
        // Fetch each friend's userFeedback
        final friendResponse = await Supabase.instance.client
            .from('users')
            .select('userFeedback')
            .eq('id', friend['id'])
            .single();

        final friendFeedback = friendResponse['userFeedback'] != null && friendResponse['userFeedback'] is String
            ? jsonDecode(friendResponse['userFeedback']) as List
            : friendResponse['userFeedback'] as List? ?? [];

        // Count occurrences of the logged-in user's int ID in the friend's feedback
        taughtMe += friendFeedback.where((feedback) => feedback['id'] == intId).length;
      }

      print("me $taughtMe");

      setState(() {
        _intId = intId;
        taughtThemCount = taughtThem;
        taughtMeCount = taughtMe;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracker'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Progress Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Guided Others: $taughtThemCount",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Received Guidance: $taughtMeCount",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            PieChart(
              dataMap: {
                "Guided Others": taughtThemCount.toDouble(),
                "Received Guidance": taughtMeCount.toDouble(),
              },
              chartType: ChartType.disc,
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
              ),
              legendOptions: const LegendOptions(
                showLegends: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
