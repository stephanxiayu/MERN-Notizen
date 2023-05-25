import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/LoginPage.dart';
import 'Pages/NoteList.dart';

void main() async {
  Dio dio = Dio();
  var cj = CookieJar();
  dio.interceptors.add(CookieManager(cj));
  // Add your request here.
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
