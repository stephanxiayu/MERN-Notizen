import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Pages/LoginPage.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:mobile/Pages/NoteList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signIn() async {
    Dio dio = Dio();
    const url =
        'http://localhost:8080/api/user/signup'; // replace with your server URL

    final response = await dio.post(
      url,
      data: {
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      },
      options: Options(contentType: Headers.jsonContentType),
    );

    if (response.statusCode == 201) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', response.data['_id']);
      await prefs.setString(
          'sessionCookie', response.headers['set-cookie']![0]);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoteList(),
          ));
      print('Logged in successfully');
    } else {
      throw Exception('Failed to login');
      motionToastLoginError();
    }
  }

  void motionToastLoginError() {
    MotionToast.error(
        animationDuration: const Duration(seconds: 5),
        title: const Text("Login fehlgeschlagen"),
        description: const Text(
          "Deine Login-Daten sind nicht korrekt",
          style: TextStyle(fontSize: 20),
        )).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.black
              // image: DecorationImage(
              //   image: AssetImage("assets/image.jpg"),
              //   fit: BoxFit.fill,
              // ),
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
                      Text(
                        "Meine Notizen",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: <Color>[
                                Colors.orangeAccent,
                                Colors.yellowAccent,
                                Colors.yellow,
                                Colors.yellowAccent,
                                Colors.orangeAccent
                                //add more color here.
                              ],
                            ).createShader(
                                const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                        ),
                      ),
                      const SizedBox(height: 50),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusColor: Colors.yellow.shade700,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.account_circle,
                            color: Colors.yellow,
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow, width: 2.0)),
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusColor: Colors.yellow.shade700,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.account_circle,
                            color: Colors.yellow,
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow, width: 2.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
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
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.yellow,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.yellow, width: 2.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signIn().catchError((error) {
                              // Handle the error here
                              print('Login failed with error: $error');
                              motionToastLoginError();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.yellow),
                          backgroundColor:
                              Colors.black, //change the background color here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'Kostenloses Konto erstellen',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: <Color>[
                                    Colors.orangeAccent,
                                    Colors.yellowAccent,
                                    Colors.yellow,
                                    Colors.yellowAccent,
                                    Colors.orangeAccent
                                    //add more color here.
                                  ],
                                ).createShader(const Rect.fromLTWH(
                                    0.0, 0.0, 200.0, 100.0)),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginForm(),
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black, //change the background color here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'Login-Seite',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                              // fontWeight: FontWeight.bold,
                              // foreground: Paint()
                              //   ..shader = const LinearGradient(
                              //     colors: <Color>[
                              //       Colors.orangeAccent,
                              //       Colors.yellowAccent,
                              //       Colors.yellow,
                              //       Colors.yellowAccent,
                              //       Colors.orangeAccent
                              //       //add more color here.
                              //     ],
                              //   ).createShader(const Rect.fromLTWH(
                              //       0.0, 0.0, 200.0, 100.0)),
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
