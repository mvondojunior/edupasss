import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // Exemple de notifications locales (remplace par Firestore plus tard)
  final List<Map<String, String>> _notifications = [
    {
      'title': 'Nouvelle annonce',
      'message': 'Le cours Flutter commence demain à 10h !'
    },
    {
      'title': 'Rappel',
      'message': 'N’oubliez pas de compléter le quiz de Dart.'
    },
    {
      'title': 'Mise à jour',
      'message': 'De nouveaux tutoriels ont été ajoutés à votre espace.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF365DA8),
      ),
      backgroundColor: Colors.white,
      body: _notifications.isEmpty
          ? const Center(
        child: Text(
          'Aucune notification pour le moment.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Color(0xFF365DA8),
              ),
              title: Text(
                notification['title']!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                notification['message']!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
