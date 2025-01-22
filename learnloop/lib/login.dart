import 'package:learnloop/homelander/community/Community_ui.dart';
import 'package:learnloop/homelander/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'home_page.dart'; // Replace with your actual home page or dashboard after login
import 'MainPage.dart';
import 'UserProvider.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Perform login using Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        setState(() {
          _errorMessage =
          'Login failed: ${response.session?.error?.message ?? "Unknown error"}';
        });
        return;
      }else{
        // Login is successful
        final user = response.user; // Get the user info
        //  Print all user info
        //   print('User Info:');
        //   print('ID: ${user?.id}');
        //   print('Email: ${user?.email}');
        //   print('Created At: ${user?.createdAt}');
        //   print('Updated At: ${user?.updatedAt}');
        //  print('User Metadata: ${user?.userMetadata}');
        //   print('App Metadata: ${user?.appMetadata}');
        // Set the user in the provider
        context.read<UserProvider>().setUser(user!);
        print("loooooooooogin success");

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context)=>MainPage(user:user),// Pass user info to MainPage
        //   ),
        // );

        // Navigate to the main page
        Navigator.pushReplacementNamed(context, '/main');
      }

      //  Navigate to the home page (or any page after successful login)
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) =>  const CommunityUI()),
      // );
      //   Navigator.pop(context);


      print("login successful");
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Text('Email', style: TextStyle(color: Colors.white70)),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Enter Email',
                    filled:true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF009252)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF009252), width: 2),
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),

                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                const Text('Password', style: TextStyle(color: Colors.white70)),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration:InputDecoration(hintText: 'Enter Password',
                    filled: true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF009252)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF009252), width: 2),
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009252),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
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
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Google SignIn Placeholder
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Continue with ",
                            style: TextStyle(color: Colors.white70)),
                        Icon(Icons.g_translate, size: 24, color: Color(0xFF009252)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on Session? {
  get error => null;
}