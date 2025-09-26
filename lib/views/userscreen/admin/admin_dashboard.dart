import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Color blueColor = const Color(0xFF365DA8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/profile_page_admin'); // 🔹 Profil admin
          },
        ),
        title: const Text(
          "Tableau de bord Admin",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: blueColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 🔹 Row raccourcis
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShortcut(
                    icon: Icons.group,
                    title: "Gérer utilisateurs",
                    onTap: () {
                      Navigator.pushNamed(context, '/manage_users_accounts');
                    },
                  ),
                  _buildShortcut(
                    icon: Icons.payment,
                    title: "Gérer paiements",
                    onTap: () {
                      Navigator.pushNamed(context, '/manage payments');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tu peux rajouter d’autres widgets ici (stats, graphiques…)
            ],
          ),
        ),
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
              Icon(icon, color: blueColor, size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: blueColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
