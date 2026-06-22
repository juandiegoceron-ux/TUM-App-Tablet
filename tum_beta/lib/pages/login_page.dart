import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tum_beta/components/my_button.dart';
import 'package:tum_beta/components/my_textfield.dart';
import 'package:tum_beta/components/square_tile.dart';
import 'package:tum_beta/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final navigator = Navigator.of(context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      navigator.pop();
    } on FirebaseAuthException catch (e) {
      navigator.pop();

      if (mounted) {
        showErrorMessage(e.code);
      }
    } catch (e) {
      navigator.pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado: ${e.toString()}')),
        );
      }
    }
  }

  void signUserInWithGoogle() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final navigator = Navigator.of(context);

    try {
      final userCredential = await AuthService().signInWithGoogle();
      
      navigator.pop();

      if (userCredential == null && mounted) {
        showErrorMessage("Inicio de sesión con Google cancelado o fallido.");
      }
    } catch (e) {
      navigator.pop();
      if (mounted) {
        showErrorMessage(e.toString());
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 768;

    if (isTablet) {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Row(
          children: [
            // Left Panel: Brand & Illustration (Visible only on tablets/desktops)
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.school_outlined,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "TUM App",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Gestiona y monitorea tu información académica de manera ágil y segura en todos tus dispositivos.",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withValues(alpha: 0.8),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.greenAccent[400], size: 20),
                            const SizedBox(width: 8),
                            const Text("Seguro", style: TextStyle(color: Colors.white70)),
                            const SizedBox(width: 20),
                            Icon(Icons.check_circle_outline, color: Colors.greenAccent[400], size: 20),
                            const SizedBox(width: 8),
                            const Text("Rápido", style: TextStyle(color: Colors.white70)),
                            const SizedBox(width: 20),
                            Icon(Icons.check_circle_outline, color: Colors.greenAccent[400], size: 20),
                            const SizedBox(width: 8),
                            const Text("Responsivo", style: TextStyle(color: Colors.white70)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Right Panel: Form
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.grey[100],
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 460),
                      padding: const EdgeInsets.all(24.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: _buildLoginForm(context, isMobile: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Mobile View
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: _buildLoginForm(context, isMobile: true),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildLoginForm(BuildContext context, {required bool isMobile}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMobile) ...[
          const SizedBox(height: 25),
          const Icon(
            Icons.lock,
            size: 50,
          ),
          const SizedBox(height: 25),
        ],

        Text(
          isMobile ? 'Welcome back!' : '¡Bienvenido de nuevo!',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: isMobile ? 16 : 22,
            fontWeight: isMobile ? FontWeight.normal : FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        // USERNAME
        MyTextfield(
          controller: emailController,
          hintText: 'Username',
          obscureText: false,
        ),
        const SizedBox(height: 10),
        // PASSWORD
        MyTextfield(
          controller: passwordController,
          hintText: '*************',
          obscureText: true,
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        MyButton(
          text: "Sign In",
          onTap: signUserIn,
        ),

        const SizedBox(height: 50),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 50),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SquareTile(
              imagePath: 'lib/images/google.png',
              onTap: signUserInWithGoogle,
            ),
          ],
        ),

        const SizedBox(height: 50),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Not a member?',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: widget.onTap,
              child: const Text(
                'Register now',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}