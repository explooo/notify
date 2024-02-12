import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
// import 'pages/login_screen.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: HomeScreen(),
    );
  }
}
