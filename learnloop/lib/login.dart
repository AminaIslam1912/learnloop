
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';
import 'MainPage.dart';
import 'UserProvider.dart';
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
      final UserCredential userCredential = await signInWithGoogle();
      if (userCredential.user == null) {
        showSnackBar("Error signing in with Google");
        return;
      }

      final String fire_id = userCredential.user?.uid ?? '';
      final String email = userCredential.user?.email ?? '';
      final supabase = Supabase.instance.client;
      final response = await supabase.from('users').upsert({
        'id': fire_id,
        'email': email,
      });

      if (fire_id.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } catch (e) {
      print(e);
      showSnackBar("Error signing in with Google: ${e.toString()}");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.standard();
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

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
      final supabaseResponse = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (supabaseResponse.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials, Try again!!'),
            backgroundColor: Colors.white,
          ),
        );
        return;
      }
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
      final user = supabaseResponse.user;
      context.read<UserProvider>().setUser(user!);
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      print('Error occurred: $e');
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
          .select()
          .eq('email', email)
          .single();

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
      print('Error fetching password: $e');
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
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Your Current Password'),
          content: SelectableText(currentPassword),
          actions: [
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: currentPassword));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
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
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
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
                const Center(
                  child: Image(
                    image: AssetImage('assets/login_logo-removebg-preview.png'),
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 10),
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
                            fontSize: 14,
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
                            fontSize: 8,
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