import 'package:flutter/material.dart';
import 'package:tum_beta/pages/login_or_register_page.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 768;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE2EFE0), // Soft pale light green
              Color(0xFF83A98B), // Soft forest green
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: isTablet
                ? _buildTabletLayout(context)
                : _buildMobileLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        // Left Side: Full Sitting Bear Image
        Expanded(
          flex: 1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Image.asset(
                'lib/images/oso_sentado.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // Right Side: Content and Action Buttons
        Expanded(
          flex: 1,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(40.0),
              child: _buildWelcomeContent(context, isTablet: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top: Bear Image
            SizedBox(
              height: 250,
              child: Image.asset(
                'lib/images/oso_sentado.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 40),
            // Bottom: Content
            _buildWelcomeContent(context, isTablet: false),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeContent(BuildContext context, {required bool isTablet}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          isTablet ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge: "Aprende jugando"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2E4A3F), // Dark forest green
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Aprende jugando",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Subtitle: "Explora junto al oso andino"
        Text(
          "Explora junto al oso andino",
          textAlign: isTablet ? TextAlign.left : TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF2E4A3F),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Title: "T.U.M."
        Text(
          "T.U.M.",
          textAlign: isTablet ? TextAlign.left : TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF2E4A3F),
            fontSize: 64,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 40),
        // Button: "Comenzar"
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginOrRegisterPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2E4A3F),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Comenzar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Footer: "Para exploradores de 8 a 21 años"
        SizedBox(
          width: double.infinity,
          child: Text(
            "Para exploradores de 8 a 21 años",
            textAlign: isTablet ? TextAlign.left : TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF2E4A3F).withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
