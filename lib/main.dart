import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
// import 'package:dynamic_color/dynamic_color.dart';
// import 'pages/login_screen.dart';
import 'themes/theme_data.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
  
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.system,
      
      home:  HomeScreen(),
    );
  
}
}