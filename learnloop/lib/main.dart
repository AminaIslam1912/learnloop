import 'package:flutter/material.dart';
import 'package:learnloop/landing_page.dart';
import 'request_sent.dart';
import 'MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     // home: MainPage(),
      home: SplashScreen(),
    );
  }
}





