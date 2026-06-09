import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cau1_login.dart';
import 'cau3_thongbao.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://supabase.com/dashboard/project/wkyqbkrvglhfzhxvdyhy',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndreXFia3J2Z2xoZnpoeHZkeWh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA3NzczMjAsImV4cCI6MjA5NjM1MzMyMH0.L-EnQDNKHjbpPKPn_hl735iswez4q54uEbdc0C4v5q0',
  );
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Life Assistant',
      home: const LoginScreen(),
    );
  }
}
