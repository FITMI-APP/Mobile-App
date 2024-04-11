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

  // Future<bool> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
  //
  //     if (googleUser != null) {
  //       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //
  //       final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //       // Optional: Fetch additional user data from Google APIs
  //       await _handleGetContact(userCredential.user!);
  //
  //       return true; // Return true for successful sign-in
  //     } else {
  //       return false; // Return false for failed sign-in
  //     }
  //   } catch (e) {
  //     print('Error signing in with Google: $e');
  //     return false; // Return false for failed sign-in
  //   }
  // }

  Future<void> _handleGetContact(User user) async {
    try {
      if (user == null || !user.emailVerified) {
        print('User is not authenticated');
        return;
      }

      final idToken = await user.getIdToken();

      final response = await http.get(
        Uri.parse('https://people.googleapis.com/v1/people/me/connections?requestMask.includeField=person.names'),
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        final String? namedContact = _pickFirstNamedContact(data);

        if (namedContact != null) {
          print('Named Contact: $namedContact');
        }
      } else {
        print('People API request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching contact information: $error');
    }
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;

    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
            (dynamic name) => (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;

      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
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
