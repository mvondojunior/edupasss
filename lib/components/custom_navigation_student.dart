import 'package:edupasss/views/userscreen/student/notifications.dart';
import 'package:flutter/material.dart';
import 'package:edupasss/views/userscreen/student/courses_page.dart';
import 'package:edupasss/views/userscreen/student/quiz_page.dart';
import 'package:edupasss/views/userscreen/student/tutorials_page.dart';
import 'package:edupasss/views/userscreen/student/profile_page.dart';
import 'package:edupasss/views/userscreen/student/student_dashboard.dart';
import 'package:edupasss/views/userscreen/student/chat_bot.dart';

final GlobalKey<_StudentDashboardState> studentDashboardKey = GlobalKey();

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;
  final Color blueColor = const Color(0xFF3B82F6);

  final List<Widget> _pages = const [
    StudentDashboard(),
    CoursesPage(),
    QuizPage(),
    TutorialsPage(),
    ProfilePage(),
    Notifications(),
  ];

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: studentDashboardKey,
      body: _pages[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        backgroundColor: blueColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatBot()),
          );
        },
        child: const Icon(Icons.chat),
        tooltip: 'Assistant IA',
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: blueColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Cours'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'Tutoriels'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Notifications'),
        ],
      ),
    );
  }
}