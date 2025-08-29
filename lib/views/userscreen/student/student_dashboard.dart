import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:edupasss/components/custom_navigation_student.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard ({super.key});

  @override
  Widget build(BuildContext context) {
    const Color blueColor = Color(0xFF3B82F6);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: const Text("Tableau de bord"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '👋 Bienvenue, Étudiant !',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              '📊 Progression',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('✅ Score général : 75%'),
                    SizedBox(height: 8),
                    Text('📘 Cours terminés : 3 / 5'),
                    SizedBox(height: 8),
                    Text('📝 Quiz réussis : 4 / 6'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '🚀 Accès rapide',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _ShortcutTile(icon: Icons.school, label: 'Cours', route: 1),
                _ShortcutTile(icon: Icons.quiz, label: 'Quiz', route: 2),
                _ShortcutTile(icon: Icons.play_circle_fill, label: 'Tutoriels', route: 3),
                _ShortcutTile(icon: Icons.person, label: 'Profil', route: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int route;

  const _ShortcutTile({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        studentDashboardKey.currentState?.switchTab(route);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF3B82F6), size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}