import 'package:flutter/material.dart';
import 'package:edupasss/views/userscreen/advisor/advisor_dashboard.dart';
import 'package:edupasss/views/userscreen/advisor/courses_manage.dart';
import 'package:edupasss/views/userscreen/advisor/profile_page.dart';

class CustomNavigationAdvisor extends StatefulWidget {
  const CustomNavigationAdvisor({super.key});

  @override
  State<CustomNavigationAdvisor> createState() => _CustomNavigationAdvisorState();
}

class _CustomNavigationAdvisorState extends State<CustomNavigationAdvisor> {
  int _currentIndex = 0;
  final Color blueColor = const Color(0xFF3B82F6);

  final List<Widget> _pages = const [
    AdvisorDashboard(),
    coursesmanage(),
    profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: blueColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Cours"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}