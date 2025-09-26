import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final TextEditingController _announcementController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendAnnouncement() async {
    final text = _announcementController.text.trim();
    if (text.isEmpty) return;

    await _firestore.collection('announcements').add({
      'message': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _announcementController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Annonce envoyée avec succès !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envoyer une annonce'),
        backgroundColor: const Color(0xFF365DA8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _announcementController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Écrire votre annonce',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _sendAnnouncement,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF365DA8),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Envoyer'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Annonces précédentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('announcements')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final announcements = snapshot.data!.docs;

                  if (announcements.isEmpty) {
                    return const Center(child: Text('Aucune annonce pour l’instant.'));
                  }

                  return ListView.builder(
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final data = announcements[index].data() as Map<String, dynamic>;
                      final message = data['message'] ?? '';
                      final timestamp = data['timestamp'] as Timestamp?;
                      final date = timestamp != null
                          ? DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000)
                          : null;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(message),
                          subtitle: date != null
                              ? Text('${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}')
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
