import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://fnzulmmhahivejgonepd.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZuenVsbW1oYWhpdmVqZ29uZXBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUxODc2NDEsImV4cCI6MjA1MDc2MzY0MX0.IO9WN7cAVMDvzbXY_EWpOAvpLQcFDjqrWxpmxS3Mp8E';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
