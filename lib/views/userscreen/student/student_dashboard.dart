import 'package:edupasss/views/userscreen/student/chat_bot.dart';
import 'package:edupasss/views/userscreen/student/courses_page.dart';
import 'package:edupasss/views/userscreen/student/profile_page.dart';
import 'package:edupasss/views/userscreen/student/quiz_page.dart';
import 'package:edupasss/views/userscreen/student/tutorials_page.dart';
import 'package:flutter/material.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final Color blueColor = const Color(0xFF365DA8);

  int _currentIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      _buildHomePage(),
      CoursesPage(),
      QuizPage(),
      TutorialsPage(),
      ProfilePage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? AppBar(
        backgroundColor: blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () => setState(() => _currentIndex = 4),
        ),
        title: const Text(
          "Tableau de bord",
          style: TextStyle(color: Colors.white),
        ),
      )
          : null,
      backgroundColor: blueColor,
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        backgroundColor: blueColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatBot()),
          );
        },
        child: const Icon(Icons.chat, color: Colors.white),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_fill), label: 'Tutoriels'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Progression de l’apprenant
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Votre progression",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: 0.6, // exemple 60%
                  backgroundColor: Colors.grey[300],
                  color: blueColor,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 8),
                const Text("60% complété",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 🔹 Row raccourcis (Cours + Tutoriels)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShortcut(
                icon: Icons.school,
                title: "Cours",
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _buildShortcut(
                icon: Icons.play_circle_fill,
                title: "Tutoriels",
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcut({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: blueColor, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blueColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
