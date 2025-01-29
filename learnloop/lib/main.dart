import 'package:learnloop/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserProvider.dart';
import 'chat/screen/ChatPage.dart';
import 'homelander/community/Community_ui.dart';
import 'homelander/about_us.dart';
import 'homelander/fun_challenge.dart';
import 'login.dart';
import 'sign_up.dart';
import 'landing_page.dart';
import 'MainPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  await Firebase.initializeApp();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
      theme: ThemeData.dark().copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.green,
          selectionColor: Colors.greenAccent,
          selectionHandleColor: Colors.green,
        ),
      ),
      // home: MainPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainPage(),
        '/home/community': (context) => CommunityUI(),
        '/home/funChallenge': (context) => FunChallengeScreen(),
        '/home/about': (context) => AboutScreen(),
        '/login': (context) => LoginPage(),
        '/sign_up': (context) => SignUpPage(),
        '/chat': (context) => ChatPage(),
      },
    );

  }
  Future<void> _loadSession(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadSession();
  }
}
