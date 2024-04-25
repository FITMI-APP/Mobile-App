import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grad/models/user.dart';
import 'package:http/http.dart' as http;
import 'database.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Database _database = Database();
  late final CollectionReference<MyUser> _users;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String _email = '';
  String _name = '';
  String _userid = '';
  String _gender = '';
  User? get currentUser => _auth.currentUser;

  MyUser? _myUser(User? user, {String fullName = '', String gender = ''}) {
    return user != null
        ? MyUser(
      uid: user.uid,
      fullName: fullName,
      email: user.email ?? '',
      phone: '',
      password: '',
      gender: gender,
    )
        : null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_myUser);
  }

  Future<Map<String, String>> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      user = _auth.currentUser;

      _email = user?.email ?? '';
      _name = _extractName(_email)?? '';
      _userid = user!.uid ?? '';
      //_gender = user.gender ?? '';

    }
    return {'email': _email, 'name': _name  ,  'userid': _userid , 'gender': _gender};
  }

  String _extractName(String email) {
    // Extracting the name from email by cutting the domain part
    int atIndex = email.indexOf('@');
    if (atIndex != -1) {
      return email.substring(0, atIndex);
    }
    return '';
  }

  Future registerWithEmailAndPassword(String fullName, String email, String password, String phone, String gender) async {
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
        gender: gender,
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

        final fullName = googleUser.displayName ?? '';

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

// Future<UserInfo?> getUserInfo(User user) async {
//   try {
//     if (user.providerData[0].providerId == 'password') {
//       // If user signed in with email/password, fullName will be empty for now.
//       return newUser(user: user, fullName: '');
//     } else if (user.providerData[0].providerId == 'google.com') {
//       // If user signed in with Google, get the full name from GoogleSignIn
//       final googleUser = await _googleSignIn.signInSilently();
//       final fullName = googleUser?.displayName ?? '';
//       return newUser(user: user, fullName: fullName);
//     } else {
//       // Handle other sign-in providers if needed
//       return null;
//     }
//   } catch (e) {
//     // Handle any errors that occur during the retrieval process
//     print('Error retrieving user info: $e');
//     return null;
//   }
// }
}