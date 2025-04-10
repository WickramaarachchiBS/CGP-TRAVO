import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn({required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      //create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //store in firestore
      // await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      //   'username': username,
      //   'email': email,
      //   'nic': nic,
      //   'uid': _auth.currentUser!.uid,
      //   'createdAt': FieldValue.serverTimestamp(),
      // });

      return userCredential;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
