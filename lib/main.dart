import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/landing_page.dart';
import 'package:zaanassh/screens/splash_screen.dart';
//import 'package:zaanassh/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreenn(),
  ));
}
