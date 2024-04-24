import 'package:flutter/material.dart';
import '../../services/authenticate.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Use TextEditingController to maintain input field states
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String gender = ''; // Gender field
  String error = '';
  bool loading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
      backgroundColor: HexColor("#3F72AF"),
      appBar: AppBar(
        backgroundColor: HexColor("#DBE2EF"),
        elevation: 0.0,
        title: const Text('Sign up to FitMi'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Sign In'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 80.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _fullNameController,
                decoration: textInputDecoration.copyWith(hintText: 'Full Name'),
                validator: (val) => val!.isEmpty ? 'Enter your full name' : null,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _phoneController,
                decoration: textInputDecoration.copyWith(hintText: 'Phone Number'),
                validator: (val) => val!.length < 10 ? 'Enter a valid phone number' : null,
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                decoration: textInputDecoration.copyWith(hintText: 'Select Gender'),
                value: gender.isNotEmpty ? gender : null,
                items: ['Male', 'Female']
                    .map(
                      (String gender) => DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  ),
                )
                    .toList(),
                onChanged: (String? value) {
                  setState(() => gender = value ?? ''); // Update the gender
                },
                validator: (value) => value == null ? 'Please select a gender' : null,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Register'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(
                      _fullNameController.text,
                      _emailController.text,
                      _passwordController.text,
                      _phoneController.text,
                      gender,
                    );
                    if (result == null) {
                      setState(() {
                        error = 'Registration failed. Please try again.';
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}