import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tum_beta/components/my_button.dart';
import 'package:tum_beta/components/my_textfield.dart';
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
        showErrorMessage("Inicio de sesión con Google cancelado.");
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
      backgroundColor: const Color(0xFF4A7356), // Outer background color from Figma
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 1100 : 450,
                  maxHeight: isTablet ? 550 : double.infinity,
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
        // Left Side: Peeking Bear Image
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              bottomLeft: Radius.circular(28),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  height: 380,
                  child: Image.asset(
                    'lib/images/oso_asomado.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Right Side: Form
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: Center(
              child: SingleChildScrollView(
                child: _buildLoginForm(context, isMobile: false),
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
          // Bear Peeking from the top-left on mobile, or showing half
          SizedBox(
            height: 150,
            child: Image.asset(
              'lib/images/oso_asomado.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          _buildLoginForm(context, isMobile: true),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, {required bool isMobile}) {
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

        // USERNAME / EMAIL
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

        const SizedBox(height: 20),

        // Entrar Button
        MyButton(
          text: "Entrar",
          onTap: signUserIn,
          backgroundColor: Colors.white,
          textColor: const Color(0xFF2E4A3F),
          borderRadius: 30,
          trailingIcon: const Icon(
            Icons.arrow_forward_rounded,
            color: Color(0xFF2E4A3F),
            size: 18,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
        ),

        const SizedBox(height: 20),

        // Link: Register now
        GestureDetector(
          onTap: widget.onTap,
          child: const Text(
            '¿No estás registrado? Crea tu cuenta',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white70,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Google Button
        GestureDetector(
          onTap: signUserInWithGoogle,
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