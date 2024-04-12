import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grad/models/user.dart';
import 'package:http/http.dart' as http;
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Database _database = Database();
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  MyUser? _myUser(User? user, {String fullName = ''}) {
    return user != null
        ? MyUser(
      uid: user.uid,
      fullName: fullName,
      email: user.email ?? '',
      phone: '',
      password: '',
    )
        : null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_myUser);
  }
  Future registerWithEmailAndPassword(String fullName, String email, String password, String phone) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = result.user!;

      // Create a MyUser instance and add it to Firestore
      MyUser newUser = MyUser(
        uid: user.uid,
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );

      return _database.addUser(newUser);

      // return _myUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = result.user!;
      return _myUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return _myUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Create a GoogleSignIn instance
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        // Obtain the authentication credentials
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a GoogleAuthCredential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google Auth credential
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Return the signed-in user
        return userCredential.user;
      } else {
        // Handle the case where Google sign-in was cancelled or failed
        print('Google sign-in cancelled or failed');
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the sign-in process
      print('Error signing in with Google: $e');
      return null;
    }
  }
}
