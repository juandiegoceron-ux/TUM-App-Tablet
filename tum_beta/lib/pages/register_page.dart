import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tum_beta/components/my_button.dart';
import 'package:tum_beta/components/my_textfield.dart';
import 'package:tum_beta/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
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
      if (passwordController.text == confirmPasswordController.text) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // Guardar detalles del usuario en Firestore (iniciar el perfil de explorador)
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': emailController.text.trim(),
          'role': 'explorador',
          'createdAt': FieldValue.serverTimestamp(),
          'progress': {
            'completedActivities': 0,
            'totalActivities': 12,
            'generalProgress': 0.0,
          }
        });

        navigator.pop();
      } else {
        navigator.pop();
        if (mounted) {
          showErrorMessage("Passwords don't match!");
        }
      }
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

  void signUserUpWithGoogle() async {
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

      if (userCredential != null) {
        // Verificar si el documento del usuario ya existe en Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'email': userCredential.user!.email ?? '',
            'role': 'explorador',
            'createdAt': FieldValue.serverTimestamp(),
            'progress': {
              'completedActivities': 0,
              'totalActivities': 12,
              'generalProgress': 0.0,
            }
          });
        }
      } else if (mounted) {
        showErrorMessage("Registro con Google cancelado.");
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

    return Scaffold(
      backgroundColor: const Color(0xFF4A7356), // Outer background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 1100 : 450,
                  maxHeight: isTablet ? 580 : double.infinity,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E4A3F), // Inner forest green background
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ]
                ),
                child: isTablet
                    ? _buildTabletLayout(context)
                    : _buildMobileLayout(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        // Left Side: Form
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: Center(
              child: SingleChildScrollView(
                child: _buildRegisterForm(context, isMobile: false),
              ),
            ),
          ),
        ),
        // Right Side: Card Selection (Figma cards)
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF243F33),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              border: Border(
                left: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProfileCard(
                        title: "Explorador Curioso",
                        subtitle: "¡Aprende jugando!",
                        backgroundColor: const Color(0xFFEAA646),
                        icon: Icons.explore_rounded,
                      ),
                      const SizedBox(width: 20),
                      _buildProfileCard(
                        title: "Aprende STEM",
                        subtitle: "¡Descubre la ciencia!",
                        backgroundColor: const Color(0xFF538666),
                        icon: Icons.science_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRegisterForm(context, isMobile: true),
        ],
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required IconData icon,
  }) {
    return Container(
      width: 180,
      height: 240,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context, {required bool isMobile}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Tu cuenta define tu perfil de explorador',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 25),

        // EMAIL
        MyTextfield(
          controller: emailController,
          hintText: 'Nombre / correo',
          obscureText: false,
          prefixIcon: const Icon(
            Icons.alternate_email_rounded,
            color: Colors.white70,
            size: 20,
          ),
          fillColor: const Color(0xFF243F33),
          enabledBorderColor: Colors.white.withValues(alpha: 0.1),
          focusedBorderColor: const Color(0xFF83A98B),
          style: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white60),
        ),
        
        const SizedBox(height: 12),
        
        // PASSWORD
        MyTextfield(
          controller: passwordController,
          hintText: 'Contraseña',
          obscureText: true,
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: Colors.white70,
            size: 20,
          ),
          fillColor: const Color(0xFF243F33),
          enabledBorderColor: Colors.white.withValues(alpha: 0.1),
          focusedBorderColor: const Color(0xFF83A98B),
          style: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white60),
        ),

        const SizedBox(height: 12),

        // CONFIRM PASSWORD
        MyTextfield(
          controller: confirmPasswordController,
          hintText: 'Confirmar Contraseña',
          obscureText: true,
          prefixIcon: const Icon(
            Icons.lock_outline_rounded,
            color: Colors.white70,
            size: 20,
          ),
          fillColor: const Color(0xFF243F33),
          enabledBorderColor: Colors.white.withValues(alpha: 0.1),
          focusedBorderColor: const Color(0xFF83A98B),
          style: const TextStyle(color: Colors.white),
          hintStyle: const TextStyle(color: Colors.white60),
        ),

        const SizedBox(height: 25),

        // Finalizar Button
        MyButton(
          text: "Finalizar",
          onTap: signUserUp,
          backgroundColor: Colors.white,
          textColor: const Color(0xFF2E4A3F),
          borderRadius: 30,
          trailingIcon: const Icon(
            Icons.check_rounded,
            color: Color(0xFF2E4A3F),
            size: 18,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
        ),

        const SizedBox(height: 20),

        // Link: Login now
        GestureDetector(
          onTap: widget.onTap,
          child: const Text(
            '¿Ya tienes cuenta? Inicia sesión',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white70,
            ),
          ),
        ),

        const SizedBox(height: 25),

        // Google Button
        GestureDetector(
          onTap: signUserUpWithGoogle,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ]
            ),
            child: Image.asset(
              'lib/images/google.png',
              height: 32,
              width: 32,
            ),
          ),
        ),
      ],
    );
  }
}