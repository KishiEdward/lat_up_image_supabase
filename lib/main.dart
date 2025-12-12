import 'package:flutter/material.dart';
import 'package:supabase_image/homepage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Upload foto', home: MyHomePage());
  }
}
