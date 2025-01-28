import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnloop/login.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'MainPage.dart';
import 'landing_page.dart';
import 'login.dart';

// SignUp Page
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _isPasswordVisible = false; // Track password visibility
  bool _isConfirmPasswordVisible = false; // Track confirm password visibility

  Future<void> _signUp() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match!';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {

      // Sign up the user with Firebase Authentication
      UserCredential firebaseUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (firebaseUser.user == null) {
        throw Exception('Firebase sign-up failed');
      }

      final firebaseUserId = firebaseUser.user!.uid;


      // Sign up the user with Supabase authentication
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        setState(() {
          _errorMessage = 'Sign-up failed:  "Unknown error"}';
        });
        return;
      }

      final user = response.user;

      // Insert the profile data (username, email) into the 'profiles' table
      final profileResponse = await Supabase.instance.client
          .from('profiles')
          .insert([
        {
          'user_id': user?.id, // Storing the UUID in the new column
          'name': username,
          'email': email,
          'created_at': DateTime.now().toUtc().toIso8601String(),
          'password': password,
         // 'fire_id': firebaseUserId,
        }
      ])
          .select();

      final userResponse = await Supabase.instance.client
          .from('users')
          .insert([
        {
          'sup_id': user?.id, // Storing the UUID in the new column
          'name': username,
          'email': email,
         // 'created_at': DateTime.now().toUtc().toIso8601String(),
         // 'password': password
          'fire_id': firebaseUserId,
          'friends': [], // Insert an empty JSON array
          'request_sent': [], // Insert an empty JSON array
          'request_received': [], // Insert an empty JSON array
          'rating':0,
          'userFeedback':[],
          'bio':"",
          'occupation':'',
          'location':'',
          'achievements':[],
          'skills':[],
          'profile_picture':'',


        }
      ])
          .select();


      if (profileResponse == null) {
        setState(() {
          _errorMessage = 'Profile insertion failed: unknown error';
        });
        // print('Supabase Insert Error: ${profileResponse.error!.message}');
        return;
      }

      // Navigate to the login page
      Navigator.pushReplacementNamed(context, '/login');
      //  Navigator.push(
      //    context,
      //    MaterialPageRoute(builder: (context) => const LoginPage()),
      //  );
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
                const SizedBox(height: 10),
                // Add the image widget above the "SignUp" text
                const Center(

                  child: Image(
                    image: AssetImage('assets/reg.png'), // Replace with your image path
                    height: 100, // Adjust the height as needed
                    width: 100, // Adjust the width as needed
                  ),
                ),
                const SizedBox(height: 10), // Add spacing between the image and the "SignUp" text

                const Center(
                  child: Text(
                    'Register Now',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //const Text(
                 //   'Username', style: TextStyle(color: Colors.white70)),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Username',
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
                  ),
                ),
                const SizedBox(height: 20),
               // const Text('Email', style: TextStyle(color: Colors.white70)),
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
                          color: Color(0xFF009252), width: 2),
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
               // const Text(
                  //  'Password', style: TextStyle(color: Colors.white70)),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
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
               // const Text('Re-enter Password',
                //    style: TextStyle(color: Colors.white70)),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Re-enter Password',
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
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Sign Up'),
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
                      // Navigator.pop(context);
                      //  Navigator.push(
                      //    context,
                      //    MaterialPageRoute(builder: (context) => const LoginPage()),
                      //  );
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Color(0xFF009252)),
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

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Center(
//                   child: Text(
//                     'SignUp',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 const Text('Username', style: TextStyle(color: Colors.white70)),
//                 TextField(
//                   controller: _usernameController,
//                   decoration: const InputDecoration(hintText: 'Enter Username'),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Email', style: TextStyle(color: Colors.white70)),
//                 TextField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(hintText: 'Enter Email'),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Password', style: TextStyle(color: Colors.white70)),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(hintText: 'Enter Password'),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Re-enter Password', style: TextStyle(color: Colors.white70)),
//                 TextField(
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(hintText: 'Re-enter Password'),
//                 ),
//                 const SizedBox(height: 20),
//                 _isLoading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                   onPressed: _signUp,
//                   child: const Text('SignUp'),
//                 ),
//                 if (_errorMessage.isNotEmpty) ...[
//                   const SizedBox(height: 10),
//                   Text(
//                     _errorMessage,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 ],
//                 const SizedBox(height: 10),
//                 Center(
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text(
//                       "Already have an account? Login",
//                       style: TextStyle(color: Color(0xFF009252)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }









