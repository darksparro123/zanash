import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zaanassh/screens/heart_rate/heart_rate.dart';
import 'package:zaanassh/screens/splash_screen.dart';
//import 'package:zaanassh/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  SensorEvents().getHeartRate();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreenn(),
  ));
}
