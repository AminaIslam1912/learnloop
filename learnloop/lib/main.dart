/*import 'package:dumppro/supabase_config.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'sign_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with the SupabaseConfig class
  await SupabaseConfig.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and SignUp',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF009252),
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[850],
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF009252)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF009252), width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF009252),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      // Define your routes here
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
      },
    );
  }
}
*/


import 'package:learnloop/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserProvider.dart';
import 'homelander/community/Community_ui.dart';
import 'homelander/about_us.dart';
import 'homelander/fun_challenge.dart';
import 'login.dart';
import 'sign_up.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'landing_page.dart';
import 'MainPage.dart';

void main() async {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with the SupabaseConfig class
  await SupabaseConfig.initialize();
  // runApp(const MyApp());
  //await Firebase.initializeApp();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), // Add UserProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // home: MainPage(),
      // Define named routes here
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainPage(),
        // Add other routes as needed
        // '/home/suggested': (context) => SuggestedForYou(),
        '/home/community': (context) => CommunityUI(),
        //'/home/funChallenge': (context) =>  FunChallengeScreen(),
        '/home/about': (context) => AboutScreen(),
        '/login':(context)=>LoginPage(),
        '/sign_up':(context)=>SignUpPage(),
        //'/home/fun':(context)=>FunChallengeScreen()
      },
    );
  }
  Future<void> _loadSession(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
   // await userProvider.loadSession(); // Load the session into the UserProvider
  }
}