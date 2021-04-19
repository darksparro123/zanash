import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:zaanassh/screens/landing_page.dart';

class SplashScreenn extends StatefulWidget {
  @override
  _SplashScreennState createState() => _SplashScreennState();
}

class _SplashScreennState extends State<SplashScreenn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: LandingPage(),
          title: new Text('Welcome In '),
          image: new Image.asset(
            'assets/s.png',
          ),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.red),
    );
  }
}
