import 'package:edupasss/views/userscreen/student/chat_bot.dart';
import 'package:edupasss/views/userscreen/student/courses_page.dart';
import 'package:edupasss/views/userscreen/student/profile_page.dart';
import 'package:edupasss/views/userscreen/student/quiz_page.dart';
import 'package:edupasss/views/userscreen/student/tutorials_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:edupasss/components/custom_navigation_student.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  // 🔹 Bleu royal harmonisé
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
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'Tutoriels'),
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
          // 🔹 Header
          Text(
            'Bienvenue ',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Faites le plein de connaissances',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 24),

          // 🔹 Container blanc avec options
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildTile(
                  icon: Icons.school,
                  title: 'Cours',
                  subtitle: 'Découvrez vos cours',
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                const SizedBox(height: 16),
                _buildTile(
                  icon: Icons.quiz,
                  title: 'Quiz',
                  subtitle: 'Testez vos connaissances',
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                const SizedBox(height: 16),
                _buildTile(
                  icon: Icons.play_circle_filled,
                  title: 'Tutoriels',
                  subtitle: 'Vidéos explicatives',
                  onTap: () => setState(() => _currentIndex = 3),
                ),
                const SizedBox(height: 16),
                _buildTile(
                  icon: Icons.person,
                  title: 'Profil',
                  subtitle: 'Gérez votre compte',
                  onTap: () => setState(() => _currentIndex = 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: blueColor.withOpacity(0.05),
          border: Border.all(color: blueColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: blueColor.withOpacity(0.1),
              child: Icon(icon, color: blueColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: blueColor, // 🔹 titres en bleu royal
                    ),
                  ),
                  const SizedBox(height: 4),
                   Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
