import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grad/shared/Header.dart';
import 'package:grad/widget/navigation_drawer_widget.dart';
import '../services/authenticate.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      appBar: Header(title: 'PROFILE' ,  scaffoldKey: _scaffoldKey),
      drawer: NavigationDrawerWidget(),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF4A2F7C)),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    _name,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF4A2F7C)),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    _email,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Change Password',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF4A2F7C)),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: SizedBox(
                      width: 200.0,
                      child: ElevatedButton(
                        onPressed: _changePassword,
                        child: Text(
                          'Change Password',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                            return Color(0xFF4615af);
                          }),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 15.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xFF4A2F7C),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF4A2F7C),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
        headline6: TextStyle(color: Color(0xFF4A2F7C)), // For titles in cards
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: ProfilePage(),
  ));
}
