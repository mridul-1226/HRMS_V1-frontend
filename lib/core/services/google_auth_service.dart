import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: '74308265195-gqteq34ui2pj8tlga0tngglov8lvh6jj.apps.googleusercontent.com',
  );

  Future<String?> signIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken(true);
        return idToken;
      }

      return null;
    } catch (e) {
      log('Google Sign-In Error: $e');
      await signOut();
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text('Error during Google Sign-In')),
      );
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      log('Google Sign-Out Error: $e');
    }
  }

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();