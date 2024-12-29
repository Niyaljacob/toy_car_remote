import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:remote/utils/images.dart';

class SplashImage extends StatelessWidget {
  const SplashImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        splash, 
        width: 300,
        height: 300,
      ),
    );
  }
}