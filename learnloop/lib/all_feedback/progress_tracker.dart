
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
  int? _intId;
  int taughtThemCount = 0;
  int taughtMeCount = 0;
  bool _isLoading = true;
  String? _errorMessage;

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


  Future<void> _fetchUserIntId() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('id, userFeedback, friends')
          .eq('email', _user!.email as Object)
          .single();

      final intId = response['id'] as int;

      final userFeedback = response['userFeedback'] != null && response['userFeedback'] is String
          ? jsonDecode(response['userFeedback']) as List
          : response['userFeedback'] as List? ?? [];

      final friends = response['friends'] != null && response['friends'] is String
          ? jsonDecode(response['friends']) as List
          : response['friends'] as List? ?? [];

      int taughtThem = userFeedback.length;

      print("id is $intId");
      print("them $taughtThem");

      int taughtMe = 0;
      for (var friend in friends) {
        final friendResponse = await Supabase.instance.client
            .from('users')
            .select('userFeedback')
            .eq('id', friend['id'])
            .single();

        final friendFeedback = friendResponse['userFeedback'] != null && friendResponse['userFeedback'] is String
            ? jsonDecode(friendResponse['userFeedback']) as List
            : friendResponse['userFeedback'] as List? ?? [];

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
            ?
        (() {
          print('Error: $_errorMessage');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Something went wrong'),
                backgroundColor: Colors.white,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          });
          return Container();
        })()
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
              colorList: const [
                Colors.green,
                Colors.white,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
