import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance.collection("USERS");

  String getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid ?? "";
  }

  Future<void> signIn(String email, String password, Function onSignInSuccess, Function(String) onSignInError) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) => onSignInSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onSignInError("User account not found");
      }
      if (e.code == 'wrong-password') {
        onSignInError("Password is not correct");
      }
    }
  }

  Future<void> signUp(String name, String email, String password, Function onSignUpSuccess, Function(String) onSignUpError) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => _fireStore.doc(value.user!.uid).set({
                "uid": value.user!.uid,
                "email": email,
                "name": name,
                "avatar": "",
              }))
          .then((value) => onSignUpSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onSignUpError("Password is too weak");
      }
      if (e.code == 'email-already-in-use') {
        onSignUpError("Account already exists");
      }
    }
  }

  Future<void> updatePassword(String newPassword, Function onUpdateSuccess, Function(String) onUpdateError) async {
    try {
      await _firebaseAuth.currentUser!.updatePassword(newPassword).then((value) => onUpdateSuccess());
    } catch (e) {
      onUpdateError(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
