import 'package:flutter/material.dart';
import 'package:sign_up/model/user.dart';
import 'package:sign_up/screens/authentication_screen.dart';

void main() {
  runApp(const MyApp());
}

List<User> users = [];

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const AuthenticationScreen(),
    );
  }
}
