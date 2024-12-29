import 'package:flutter/material.dart';
import 'package:remote/utils/theme.dart';
import 'package:remote/view/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: Themes.lightModeTheme,
        darkTheme: Themes.darkModeTheme,
      home: const SplashScreen(),
    );
  }
}

