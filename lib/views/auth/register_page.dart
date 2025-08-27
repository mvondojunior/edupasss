import 'package:flutter/material.dart';
import 'package:edupasss/components/custom_textfield.dart';
import 'package:edupasss/components/custom_dropdownfield.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Color blueColor = const Color(0xFF3B82F6);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? selectedRole;

  final List<DropdownMenuItem<String>> roleItems = const [
    DropdownMenuItem(value: 'Etudiant', child: Text('Étudiant')),
    DropdownMenuItem(value: 'Enseignant', child: Text('Enseignant')),
    DropdownMenuItem(value: 'Administrateur', child: Text('Administrateur')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.arrow_back, color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Creer un compte',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Champ Nom
                  CustomTextfield(
                    hintText: 'Nom',
                    icon: Icons.person,
                    controller: nameController,
                  ),
                  const SizedBox(height: 16),

                  // Champ Email
                  CustomTextfield(
                    hintText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),

                  // Mot de passe
                  CustomTextfield(
                    hintText: 'Mot de passe',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 16),

                  // Confirmation mot de passe
                  CustomTextfield(
                    hintText: 'Confirmer mot de passe',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    controller: confirmPasswordController,
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Creer un compte',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (selectedRole == null) {
        _showSnackBar('Veuillez sélectionner un rôle.');
        return;
      }
      if (passwordController.text != confirmPasswordController.text) {
        _showSnackBar('Les mots de passe ne correspondent pas.');
        return;
      }
      _showSnackBar('Inscription réussie !', success: true);
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

