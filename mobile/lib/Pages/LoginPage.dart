import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile/Pages/NoteList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    const url =
        'http://localhost:8080/api/user/login'; // replace with your server URL
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'username': _usernameController.text.trim(),
        // 'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoteList(),
          ));
      print('Logged in successfully');
    } else {
      // If the server did not return a 200 OK response,
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              // To avoid overflow when keyboard shows up
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 50),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .white, // Change the color to white for better visibility on image
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login().catchError((error) {
                              // Handle the error here
                              print('Login failed with error: $error');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.white, //change the background color here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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
        ),
      ]),
    );
  }
}
