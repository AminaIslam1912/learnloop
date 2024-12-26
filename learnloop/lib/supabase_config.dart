import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://fydubhxmhupqdoksymto.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ5ZHViaHhtaHVwcWRva3N5bXRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ5Mzc5MTcsImV4cCI6MjA1MDUxMzkxN30.YNpzZxqcNs6Odlc8YJOVnCnIkiQgacRYHBLd_OFuPoQ';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
