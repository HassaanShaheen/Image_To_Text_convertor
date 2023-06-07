import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:semesterproject/Converted.dart';
import 'package:semesterproject/translation.dart';
import 'image_text.dart';

void main() {
  runApp(MaterialApp(
    home: const SplashScreen(),
    routes: {
      'image_text': (context) => const ImageToText(),
      'translation': (context) => const TranslationOfText(),
      'Converted': (context) => const ConvertedText(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: LottieBuilder.asset('assets/loading.json'),
        splashIconSize: double.infinity,
        backgroundColor: Colors.white,
        splashTransition: SplashTransition.scaleTransition,
        animationDuration: const Duration(milliseconds: 5),
        nextScreen: const ImageToText());
  }
}
