import 'package:flutter/material.dart';
import '../../services/authenticate.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dropdown_button2/dropdown_button2.dart'; // Import DropdownButton2 package

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String phone = '';
  String fullName = '';
  String gender = ''; // Initialize selectedItem with an empty string
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: HexColor("#3F72AF"),
      appBar: AppBar(
        leading: logo,
        backgroundColor:HexColor("#DBE2EF"),
        elevation: 0.0,
        title: const Text('Sign up to FitMi'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Sign In'),
            style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Full Name'),
                validator: (val) => val!.isEmpty ? 'Enter your full name' : null,
                onChanged: (val) {
                  setState(() => fullName = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Example@example.com'),
                validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                validator: (val) => val!.length < 6 ? 'Enter a Password 6+ chars long' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: '0100000000'),
                validator: (val) => val!.length < 12 ? 'Enter a valid number' : null,
                onChanged: (val) {
                  setState(() => phone = val);
                },
              ),
              const SizedBox(height: 20.0),
              // Gender dropdown
              DropdownButton2<String>(
                hint: const Text('Select Gender'),
                items: ['Male', 'Female']
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: button,
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(
                      fullName,
                      email,
                      password,
                      phone,
                      gender, // Include gender in registration
                    );
                    if (result == null) {
                      // Registration failed, display an error message
                      setState(() {
                        error = 'Please Enter a valid email and password';
                        loading = false;
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
