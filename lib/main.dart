import 'package:edupasss/views/auth/login_page.dart';
import 'package:edupasss/views/auth/register_page.dart';
import 'package:edupasss/views/home/landing_page.dart';
import 'package:edupasss/views/userscreen/student/chat_bot.dart';
import 'package:edupasss/views/userscreen/student/profile_page.dart';
import 'package:edupasss/views/userscreen/student/student_dashboard.dart';
import 'package:edupasss/views/userscreen/student/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/student_dashboard': (context) => StudentDashboard(),
        '/chatbot': (context) => ChatBot(),

      },
    );
  }
}