import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/LoginPage.dart';
import 'Pages/NoteList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = prefs.getBool('isLoggedIn');

  runApp(MyApp(isLoggedIn: isLoggedIn ?? false));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    print("isLoggedIn == true??? $isLoggedIn");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App',
      theme: ThemeData.dark(),
      home: isLoggedIn ? const NoteList() : const LoginForm(),
    );
  }
}
