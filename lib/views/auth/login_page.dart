import 'package:edupasss/views/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:edupasss/components/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color blueColor = const Color(0xFF3B82F6);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void handleLogin() {
    setState(() => isLoading = true);
    Future.delayed(const Duration(seconds: 2),(){
      setState(() => isLoading = false);
      Navigator.pushReplacementNamed(context, '/home');

    });
  }

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
            'Se connecter',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: blueColor,
            ),
          ),
          const SizedBox(height: 24),
          CustomTextfield(
            hintText: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          ),
          const SizedBox(height: 16
          ),
          CustomTextfield(
            hintText: 'Mot de passe',
            icon: Icons.lock,
            obscureText: true,
            controller: passwordController,
          ),
          const SizedBox(height: 24
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()
                ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Se connecter',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16
            ,),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Fond blanc pour ressembler à un bouton Google
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.grey), // Bord gris léger
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png', // Assure-toi d’avoir ce fichier dans ton dossier assets
                    height: 24.0,
                    width: 24.0,
                  ),
                  const SizedBox(width: 12), // Espace entre le logo et le texte
                  const Text(
                    'Continuer avec Google',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16
            ),
          Text('Vous n\'avez pas de compte ?',style: TextStyle(fontSize: 14),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=> RegisterPage()
                ),
              );
            },
            child: Text('Creer un compte',
              style: TextStyle(color: Colors.blue,fontSize: 14),
            ),
          ),
    ])
    )
    )
        )
    )
    );
  }
}

