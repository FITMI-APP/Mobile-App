import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import '../services/authenticate.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  String _email = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: HexColor("#F5F5F5"), // Button background color
    foregroundColor: Colors.black, // Button text color
    padding: const EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 5, // Add elevation to the button
  );

  Future<void> getUserInfo() async {
    Map<String, String> userInfo = await _auth.getUserInfo();
    setState(() {
      _email = userInfo['email'] ?? '';
      _name = userInfo['name'] ?? '';
    });
  }

  Future<void> _changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty) {
      _showErrorDialog('Please enter both old and new passwords.');
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);

        _oldPasswordController.clear();
        _newPasswordController.clear();

        _showSuccessDialog("Password changed successfully.");
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'wrong-password') {
        _showErrorDialog('The old password you entered is incorrect.');
      } else {
        _showErrorDialog('An error occurred while changing the password.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $_name',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: $_email',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Old Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsets.all(12.0),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsets.all(12.0),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: _changePassword,
                child: Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
