import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_image/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://poetiavbyzulpxvtyrej.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvZXRpYXZieXp1bHB4dnR5cmVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU1MzkxMjAsImV4cCI6MjA4MTExNTEyMH0.nAD1HL6-EUaT40HVS-pYVxyvwIIeyztV0Mer-1XfXyY',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Upload foto', home: MyHomePage());
  }
}
