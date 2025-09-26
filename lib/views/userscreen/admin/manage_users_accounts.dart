import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageUsersAccounts extends StatefulWidget {
  const ManageUsersAccounts({super.key});

  @override
  State<ManageUsersAccounts> createState() => _ManageUsersAccountsState();
}

class _ManageUsersAccountsState extends State<ManageUsersAccounts> {
  final CollectionReference usersRef =
  FirebaseFirestore.instance.collection('users');

  // 🔴 Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    await usersRef.doc(userId).delete();
    // ⚠️ Pour supprimer aussi le compte FirebaseAuth côté serveur,
    // il faut utiliser Cloud Functions car côté client c’est limité.
  }

  // 🔒 Bloquer ou débloquer un utilisateur
  Future<void> toggleBlockUser(String userId, bool isBlocked) async {
    await usersRef.doc(userId).update({'blocked': !isBlocked});
  }

  // ✏️ Modifier les infos d’un utilisateur (ex: rôle)
  Future<void> editUser(String userId, String newRole) async {
    await usersRef.doc(userId).update({'role': newRole});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des utilisateurs"),
        backgroundColor: const Color(0xFF365DA8),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(), // 👀 Écoute en temps réel
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun utilisateur trouvé"));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;
              final userData = user.data() as Map<String, dynamic>;
              final name = userData['name'] ?? "Inconnu";
              final email = userData['email'] ?? "";
              final role = userData['role'] ?? "Sans rôle";
              final isBlocked = userData['blocked'] ?? false;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(name.isNotEmpty ? name[0] : "?"),
                  ),
                  title: Text(name),
                  subtitle: Text("$email\nRôle: $role"),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        deleteUser(userId);
                      } else if (value == 'block') {
                        toggleBlockUser(userId, isBlocked);
                      } else if (value == 'edit') {
                        _showEditDialog(userId, role);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Supprimer"),
                      ),
                      PopupMenuItem(
                        value: 'block',
                        child: Text(isBlocked ? "Débloquer" : "Bloquer"),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text("Modifier rôle"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ⚙️ Dialog pour modifier rôle utilisateur
  void _showEditDialog(String userId, String currentRole) {
    String? newRole = currentRole;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifier rôle"),
        content: DropdownButtonFormField<String>(
          value: currentRole,
          items: const [
            DropdownMenuItem(value: "Apprenant", child: Text("Apprenant")),
            DropdownMenuItem(value: "Formateur", child: Text("Formateur")),
          ],
          onChanged: (value) => newRole = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              if (newRole != null) {
                editUser(userId, newRole!);
              }
              Navigator.pop(context);
            },
            child: const Text("Sauvegarder"),
          ),
        ],
      ),
    );
  }
}
