import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider()
        ..setCustomParameters({'prompt': 'select_account'});

      if (kIsWeb) {
        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      }

      return await FirebaseAuth.instance.signInWithProvider(googleProvider);

    } catch (e) {
      return null;
    }
  }
}