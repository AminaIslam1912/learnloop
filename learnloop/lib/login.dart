

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';
import 'MainPage.dart';
import 'UserProvider.dart';
import 'homelander/community/Community_ui.dart';
import 'sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _isPasswordVisible = false;

  Future<void> _handleGoogleSignIn(BuildContext context, Function(String) showSnackBar) async {
    try {
      // Trigger Google Sign-In using Firebase
      final UserCredential userCredential = await signInWithGoogle();

      // Show a snackbar on error
      if (userCredential.user == null) {
        showSnackBar("Error signing in with Google");
        return;
      }

      // Extract user details
      final String fire_id = userCredential.user?.uid ?? '';
      final String email = userCredential.user?.email ?? '';
      // final String displayName = userCredential.user?.displayName ?? '';
      // final String photoUrl = userCredential.user?.photoURL ?? '';

      // Insert or update user in the Supabase users table
      final supabase = Supabase.instance.client;
      final response = await supabase.from('users').upsert({
        'id': fire_id, // Firebase UID as the unique identifier
        'email': email,
        // 'full_name': displayName,
        // 'photo_url': photoUrl,
      });

      // Navigate to the main screen on successful login
      if (fire_id.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } catch (e) {
      // Handle errors and show a snackbar
      print(e);
      showSnackBar("Error signing in with Google: ${e.toString()}");
    }
  }

  /// This function handles Google Sign-In and returns a [UserCredential].
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Create a GoogleSignIn instance
      final GoogleSignIn googleSignIn = GoogleSignIn.standard();

      // Sign out any existing user to prompt the account selection dialog
      await googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Check if the sign-in was successful
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle sign-in errors
      throw Exception('Failed to sign in with Google: $e');
    }
  }


  // Future<void> _login() async {
  //   final email = _emailController.text;
  //   final password = _passwordController.text;
  //
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = '';
  //   });
  //
  //   try {
  //     // Login with Supabase
  //     final supabaseResponse = await Supabase.instance.client.auth.signInWithPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     if (supabaseResponse.session == null) {
  //       setState(() {
  //         _errorMessage =
  //         'Supabase login failed: ${supabaseResponse.session?.error?.message ?? "Unknown error"}';
  //         return;
  //       });
  //     }
  //
  //     // Login with Firebase
  //     try {
  //       final firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );
  //
  //       print("Firebase login successful: ${firebaseUser.user?.email}");
  //     } catch (firebaseError) {
  //       print('Firebase login failed: $firebaseError');
  //       throw Exception('Firebase login failed: $firebaseError');
  //     }
  //
  //     // If both logins succeed, proceed to the main page
  //     final user = supabaseResponse.user;
  //     context.read<UserProvider>().setUser(user!);
  //
  //     // Navigate to the main page
  //     Navigator.pushReplacementNamed(context, '/main');
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'An unexpected error occurred: $e';
  //     });
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Check if inputs are empty
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill up all the inputs'),
          backgroundColor: Colors.white,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Login with Supabase
      final supabaseResponse = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Check if Supabase login fails
      if (supabaseResponse.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials, Try again!!'),
            backgroundColor: Colors.white,
          ),
        );
        return;
      }

      // Login with Firebase
      try {
        final firebaseUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        print("Firebase login successful: ${firebaseUser.user?.email}");
      } catch (firebaseError) {
        print('Firebase login failed: $firebaseError');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials, Try again!!'),
            backgroundColor: Colors.white,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully logged in.'),
          backgroundColor: Colors.white,
        ),
      );

      // If both logins succeed, proceed to the main page
      final user = supabaseResponse.user;
      context.read<UserProvider>().setUser(user!);

      // Navigate to the main page
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      print('Error occurred: $e'); // Log error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials, Try again!!'),
          backgroundColor: Colors.white,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _showForgotPasswordDialog() async {
    final TextEditingController emailController = TextEditingController();
    String dialogErrorMessage = '';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Forgot Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      errorText: dialogErrorMessage.isEmpty ? null : dialogErrorMessage,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text;
                    if (email.isEmpty || !email.contains('@')) {
                      setState(() {
                        dialogErrorMessage = 'Please enter a valid email address.';
                      });
                      return;
                    }

                    final otp = _generateOTP();
                    final result = await _sendOTPToEmail(email, otp);
                    if (result) {
                      Navigator.pop(context);
                      await _showEnterOTPDialog(email, otp);
                    } else {
                      setState(() {
                        dialogErrorMessage = 'Failed to send OTP. Try again later.';
                      });
                    }
                  },
                  child: const Text('Send OTP'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEnterOTPDialog(String email, int sentOtp) async {
    final TextEditingController otpController = TextEditingController();
    String otpErrorMessage = '';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Enter OTP'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: otpController,
                    decoration: InputDecoration(
                      hintText: 'Enter 6-digit OTP',
                      errorText: otpErrorMessage.isEmpty ? null : otpErrorMessage,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final enteredOtp = int.tryParse(otpController.text);
                    if (enteredOtp == null || enteredOtp != sentOtp) {
                      setState(() {
                        otpErrorMessage = 'Invalid OTP. Please try again.';
                      });
                    } else {
                      Navigator.pop(context);
                      _fetchCurrentPassword(email);
                    }
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _sendOTPToEmail(String email, int otp) async {
    const String senderEmail = 'kawserabu11mini@gmail.com';
    const String senderName = 'learnloop';
    const String apiKey = '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';

    final smtpServer = SmtpServer(
      'smtp.sendgrid.net',
      port: 587,
      username: 'apikey',
      password: apiKey,
    );

    final message = Message()
      ..from = const Address(senderEmail, senderName)
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP is: $otp. It will expire in 5 minutes.';

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('OTP sent: $sendReport');
      return true;
    } catch (e) {
      debugPrint('Error sending OTP: $e');
      return false;
    }
  }

  int _generateOTP() {
    final random = Random();
    return 100000 + random.nextInt(900000);
  }

  Future<void> _fetchCurrentPassword(String email) async {
    try {
      // First check if the user exists
      final response = await Supabase.instance.client
          .from('profiles')
          .select()  // Remove 'password' to select all columns
          .eq('email', email)
          .single();  // Get a single record

      if (response != null && response.containsKey('password')) {
        final currentPassword = response['password'] as String;
        _showCurrentPasswordDialog(currentPassword);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found with this email.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error fetching password: $e'); // For debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching password: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCurrentPasswordDialog(String currentPassword) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must click button
      builder: (context) {
        return AlertDialog(
          title: const Text('Your Current Password'),
          content: SelectableText(currentPassword), // Makes password copyable
          actions: [
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: currentPassword)); // Copy to clipboard
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar( // Show toast
                  const SnackBar(
                    content: Text('Password copied to clipboard!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009252),
              ),
              child: const Text('Copy'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Set a background color for the AppBar
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
           // Navigator.pop(context); // Navigate back to the previous screen
          //  Navigator.pushReplacement(context, "")
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Add the image widget here
                const Center(
                  child: Image(
                    image: AssetImage('assets/login_logo-removebg-preview.png'), // Replace with your image path
                    height: 100, // Adjust the height as needed
                    width: 100, // Adjust the width as needed
                  ),
                ),
                const SizedBox(height: 10), // Add spacing between the image and the text
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
                //const Text('Email', style: TextStyle(color: Colors.white70)),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    filled: true,
                    fillColor: Colors.grey[850],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF009252)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF009252),
                        width: 2,
                      ),
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 20),
                // const Text('Password', style: TextStyle(color: Colors.white70)),
                TextField(
                  controller: _passwordController,
                  obscureText:  !_isPasswordVisible,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009252),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 20),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                    // Add spacing between the two texts
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage()),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(
                            color: Color(0xFF009252),
                            fontSize: 14, // Standard font size for this text
                          ),
                        ),
                      ),
                     // const SizedBox(width:1),
                      TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 8, // Smaller font size for "Forgot Password"
                          ),
                        ),
                      ),
                    ],
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