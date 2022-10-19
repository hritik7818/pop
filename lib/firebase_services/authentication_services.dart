import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //registration with email and password
  Future createNewUser(String name, String email, String password) async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  // login user

  Future loginUser(String email, String password) async {
    try {
      var result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  //sign out

  Future signOut() async {
    try {
      var response = await auth.signOut();
      return response;
    } catch (error) {
      print(error.toString());
    }
  }
}
