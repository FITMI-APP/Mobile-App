import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grad/models/user.dart';

import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Database _database = Database();

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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
}
