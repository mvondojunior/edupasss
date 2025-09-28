import 'package:edupasss/views/auth/login_page.dart';
import 'package:edupasss/views/auth/register_page.dart';
import 'package:edupasss/views/home/landing_page.dart';
import 'package:edupasss/views/userscreen/admin/admin_dashboard.dart';
import 'package:edupasss/views/userscreen/admin/manage_payments.dart';
import 'package:edupasss/views/userscreen/admin/manage_users_accounts.dart';
import 'package:edupasss/views/userscreen/admin/profile_page_admin.dart';
import 'package:edupasss/views/userscreen/advisor/advisor_dashboard.dart';
import 'package:edupasss/views/userscreen/advisor/announcement.dart';
import 'package:edupasss/views/userscreen/student/chat_bot.dart';
import 'package:edupasss/views/userscreen/student/notifications.dart';
import 'package:edupasss/views/userscreen/student/profile_page.dart';
import 'package:edupasss/views/userscreen/student/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light; // Thème par défaut

  // Fonction toggleTheme 🔥
  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Thèmes
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: _themeMode,

      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/student_dashboard': (context) => StudentDashboard(),
        '/advisor_dashboard': (context) =>  AdvisorDashboard(),
        '/admin_dashboard': (context) => AdminDashboard(),
        '/chatbot': (context) => ChatBot(),
        '/profile_page_admin':(context) => ProfilePageAdmin(),
        '/manage_users_accounts':(context) => ManageUsersAccounts(),
        '/manage_payments':(context) => ManagePaymentsPage(),
        '/notifications': (context) => Notifications(),
        '/announcement': (context) => AnnouncementPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}