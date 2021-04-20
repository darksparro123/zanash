import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:zaanassh/screens/landing_page.dart';

class SplashScreenn extends StatefulWidget {
  @override
  _SplashScreennState createState() => _SplashScreennState();
}

class _SplashScreennState extends State<SplashScreenn> {
  //navigate to landing page
  naviator() {
    Future.delayed(Duration(seconds: 4))
        .then((value) => Get.to(() => LandingPage()));
  }

  @override
  void initState() {
    super.initState();
    naviator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/s.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
        ));
  }
}
