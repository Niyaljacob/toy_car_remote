import 'package:flutter/material.dart';
import 'package:remote/utils/color.dart';
import 'dart:async';

import 'package:remote/view/home/home_screen.dart';
import 'package:remote/view/splash/widget/splash_image.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });

    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.light ? whiteColor : black,
      body: SplashImage(),
    );
  }
}
