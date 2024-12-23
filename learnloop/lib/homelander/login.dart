import 'package:flutter/material.dart';
import 'community_ui.dart'; // Import the CommunityUI screen
import 'Signup_page.dart'; // Import the SignUpPage screen
import 'course_ui.dart'; // Import the CourseUI screen

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return WillPopScope(
      onWillPop: () async {
        // When back button is pressed, navigate to CourseUI screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CourseUI()),
        );
        return false; // Prevent default back button action
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Navigate to CourseUI screen when the back button is pressed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CourseUI()),
              );
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text('Username', style: TextStyle(color: Colors.white70)),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Username',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF1C1C1C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Password', style: TextStyle(color: Colors.white70)),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF1C1C1C),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // Validation logic for login
                      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
                        _showDialog(context, 'You have to enter all the fields');
                      } else {
                        // Navigate to the Community UI screen after successful login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const CommunityUI()),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color(0xFF009252)),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate to the SignUp screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? SignUp",
                      style: TextStyle(color: Color(0xFF009252)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFF009252)),
              ),
            ),
          ],
        );
      },
    );
  }
}
