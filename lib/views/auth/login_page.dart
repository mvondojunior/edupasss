import 'package:edupasss/components/custom_button.dart';
import 'package:edupasss/components/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // --- Bleu royal utilisé partout ---
  final Color blueColor = const Color(0xFF365DA8);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _handleEmailLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
          String role = userData['role'];

          if (role == 'Etudiant') {
            Navigator.pushReplacementNamed(context, '/student_dashboard');
          } else if (role == 'Formateur') {
            Navigator.pushReplacementNamed(context, '/advisor_dashboard');
          } else if (role == 'Administrateur') {
            Navigator.pushReplacementNamed(context, '/admin_dashboard');
          }
          _showSnackBar('Connexion réussie !', success: true);
        } else {
          _showSnackBar('Utilisateur non trouvé.');
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Erreur de connexion';
        if (e.code == 'user-not-found') {
          message = 'Utilisateur non trouvé.';
        } else if (e.code == 'wrong-password') {
          message = 'Mot de passe incorrect.';
        } else if (e.code == 'invalid-email') {
          message = 'Email invalide.';
        }
        _showSnackBar(message);
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor, // 🔹 fond bleu royal

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: blueColor, // 🔹 titre en bleu royal
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextfield(
                    hintText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Email invalide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    hintText: 'Mot de passe',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Se connecter',
                    onPressed: _handleEmailLogin,
                    isLoading: isLoading,
                    backgroundColor: blueColor, // 🔹 bouton bleu royal
                  ),
                  const SizedBox(height: 24),

                  // --- Section inscription ---
                  Column(
                    children: [
                      Text(
                        "Vous n'avez pas de compte ?",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: Text(
                          "Créer un compte",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
