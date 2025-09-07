import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  final ValueChanged<bool>? onThemeChanged;

  const ProfilePage({super.key, this.onThemeChanged});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color blueColor = const Color(0xFF3B82F6);
  final User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
          isLoading = false;
        });
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _changePassword() {
    if (user != null && user!.email != null) {
      FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Lien de réinitialisation envoyé à votre email"),
          backgroundColor: blueColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: blueColor.withOpacity(0.1), // Softer background
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: blueColor.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Avatar
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: blueColor.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userData?['name'] ?? 'Nom inconnu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userData?['email'] ?? user?.email ?? 'Email inconnu',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Chip(
                      label: Text(
                        userData?['role'] ?? 'Rôle inconnu',
                        style: const TextStyle(fontSize: 14),
                      ),
                      backgroundColor: blueColor.withOpacity(0.1),
                      side: BorderSide(color: blueColor),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    const SizedBox(height: 24),
                    Divider(
                      thickness: 1,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                    // User Info
                    _buildListTile(
                      icon: Icons.email,
                      title: 'Email',
                      subtitle: user?.email ?? 'Non défini',
                      isDark: isDark,
                    ),
                    _buildListTile(
                      icon: Icons.person_outline,
                      title: 'Nom',
                      subtitle: userData?['name'] ?? 'Non défini',
                      isDark: isDark,
                    ),
                    _buildListTile(
                      icon: Icons.badge,
                      title: 'Rôle',
                      subtitle: userData?['role'] ?? 'Non défini',
                      isDark: isDark,
                    ),
                    Divider(
                      thickness: 1,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                    // Theme Switch
                    SwitchListTile(
                      secondary: Icon(
                        Icons.dark_mode,
                        color: blueColor,
                      ),
                      title: const Text(
                        "Thème sombre",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      value: isDark,
                      activeColor: blueColor,
                      onChanged: (value) {
                        if (widget.onThemeChanged != null) {
                          widget.onThemeChanged!(value);
                        }
                      },
                    ),
                    // Other Options
                    _buildListTile(
                      icon: Icons.lock_reset,
                      title: 'Changer le mot de passe',
                      onTap: _changePassword,
                      isDark: isDark,
                    ),
                    _buildListTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: page notifications
                      },
                      isDark: isDark,
                    ),
                    _buildListTile(
                      icon: Icons.info_outline,
                      title: 'À propos',
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: "EduPass",
                          applicationVersion: "1.0.0",
                          applicationLegalese: "© 2025 EduPass Inc.",
                        );
                      },
                      isDark: isDark,
                    ),
                    const SizedBox(height: 24),
                    // Logout Button
                    ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Se déconnecter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: blueColor,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: isDark ? Colors.grey[800]?.withOpacity(0.3) : Colors.grey[100]?.withOpacity(0.5),
    );
  }
}