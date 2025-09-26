import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagePaymentsPage extends StatefulWidget {
  const ManagePaymentsPage({super.key});

  @override
  State<ManagePaymentsPage> createState() => _ManagePaymentsPageState();
}

class _ManagePaymentsPageState extends State<ManagePaymentsPage> {
  final CollectionReference paymentsRef =
  FirebaseFirestore.instance.collection('payments');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des paiements"),
        backgroundColor: const Color(0xFF365DA8),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: paymentsRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun paiement trouvé"));
          }

          final payments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              final data = payment.data() as Map<String, dynamic>;

              final name = data['name'] ?? "Inconnu";
              final amount = data['amount'] ?? 0;
              final method = data['method'] ?? "N/A";
              final status = data['status'] ?? "pending";
              final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: status == "success"
                        ? Colors.green
                        : status == "failed"
                        ? Colors.red
                        : Colors.orange,
                    child: Icon(
                      status == "success"
                          ? Icons.check
                          : status == "failed"
                          ? Icons.close
                          : Icons.hourglass_empty,
                      color: Colors.white,
                    ),
                  ),
                  title: Text("$name - $amount XAF"),
                  subtitle: Text(
                    "Méthode: $method\nDate: ${createdAt ?? 'Inconnue'}",
                  ),
                  isThreeLine: true,
                  trailing: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: status == "success"
                          ? Colors.green
                          : status == "failed"
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
