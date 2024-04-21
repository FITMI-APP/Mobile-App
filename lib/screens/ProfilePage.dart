import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = '';
  String _name = '';
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      user = _auth.currentUser;

      setState(() {
        _email = user?.email ?? '';
        _name = _extractName(_email);
      });
    }
  }

  String _extractName(String email) {
    // Extracting the name from email by cutting the domain part
    int atIndex = email.indexOf('@');
    if (atIndex != -1) {
      return email.substring(0, atIndex);
    }
    return '';
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
        // Re-authenticate user
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(credential);

        // Change password
        await user.updatePassword(newPassword);

        // Clear text fields
        _oldPasswordController.clear();
        _newPasswordController.clear();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Password changed successfully."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $_name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: $_email',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Old Password',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
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
