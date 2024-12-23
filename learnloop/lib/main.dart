import 'package:flutter/material.dart';
import 'package:learnloop/homelander/course_ui.dart';  void main() {   runApp(const MyApp()); }
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override   Widget build(BuildContext context) {     return MaterialApp(       debugShowCheckedModeBanner: false,       theme: ThemeData.dark(),       home: const SplashScreen(),     );   } }  class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState(); }

class _SplashScreenState extends State<SplashScreen> {   @override   void initState() {     super.initState();     Future.delayed(const Duration(seconds: 3), () {       Navigator.pushReplacement(         context,         MaterialPageRoute(builder: (context) => const CourseUI()),       );     });   }    @override   Widget build(BuildContext context) {     return const Scaffold(       backgroundColor: Colors.black,       body: Center(         child: CircularProgressIndicator(           color: Colors.green,         ),       ),     );   } }