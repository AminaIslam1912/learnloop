import 'package:flutter/material.dart';
import 'MainPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the main page after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color of the splash screen
      body: Container(
         decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_app.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Writing practice.png', // Path to your splash screen image
                height: 200, // Adjust the height as needed
              ),
              const SizedBox(height: 20),
              Text(
                'LearnLoop',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF264E70), // Customize text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}