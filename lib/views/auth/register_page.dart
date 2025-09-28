import 'package:flutter/material.dart';
import 'package:edupasss/components/custom_textfield.dart';
import 'package:edupasss/components/custom_dropdownfield.dart';
import 'package:edupasss/components/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Color appBlue = const Color(0xFF365DA8); // 👈 ton bleu royal
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? selectedRole;

  final List<DropdownMenuItem<String>> roleItems = const [
    DropdownMenuItem(value: 'Apprenant', child: Text('Apprenant')),
    DropdownMenuItem(value: 'Formateur', child: Text('Formateur')),
  ];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlue,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: appBlue),
                      onPressed: () => Navigator.pushNamed(context, '/'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Créer un compte',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: appBlue,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Champ Nom
                  CustomTextfield(
                    hintText: 'Nom',
                    icon: Icons.person,
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Champ Email
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

                  // Mot de passe
                  CustomTextfield(
                    hintText: 'Mot de passe',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      if (value.length < 6) {
                        return 'Le mot de passe doit avoir au moins 6 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirmation mot de passe
                  CustomTextfield(
                    hintText: 'Confirmer mot de passe',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez confirmer votre mot de passe';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown rôle
                  CustomDropdownField(
                    label: "Rôle",
                    hintText: "Sélectionnez votre rôle",
                    items: roleItems,
                    value: selectedRole,
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Bouton d'inscription
                  CustomButton(
                    text: 'Créer un compte',
                    onPressed: _handleSubmit,
                    isLoading: isLoading,
                    backgroundColor: appBlue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (selectedRole == null) {
        _showSnackBar('Veuillez sélectionner un rôle.');
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        _showSnackBar('Les mots de passe ne correspondent pas.');
        return;
      }

      setState(() => isLoading = true);

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'role': selectedRole,
          'createdAt': Timestamp.now(),
        });

        _showSnackBar('Inscription réussie !', success: true);
        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        String message = 'Erreur inconnue';
        if (e.code == 'weak-password') {
          message = 'Le mot de passe est trop faible.';
        } else if (e.code == 'email-already-in-use') {
          message = 'Cet email est déjà utilisé.';
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
}