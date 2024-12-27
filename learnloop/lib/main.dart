import 'package:flutter/material.dart';
import 'package:learnloop/person/UserProfile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SupabaseConfig {
  static const String supabaseUrl = "https://gbnedwibenauvcnsyktw.supabase.co"; // Replace with your Supabase URL
  static const String supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdibmVkd2liZW5hdXZjbnN5a3R3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUxMjIzMjAsImV4cCI6MjA1MDY5ODMyMH0.Mc6DHLDDsRMiKZQ0XdlYasnacBimNDObwu-aOOtT-AI"; // Replace with your Supabase anon key

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfile(
        loggedInUserId: 1, // Replace with the actual logged-in user ID
        profileUserId: 1, // Replace with the actual profile owner ID
      ),
    );
  }

}
