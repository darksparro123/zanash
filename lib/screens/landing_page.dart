import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zaanassh/screens/navigation_bar.dart';
import 'package:zaanassh/screens/signup_screen.dart';
import 'package:zaanassh/screens/splash_screen.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignupScreen();
          } else {
            //print(user.email);
            return NavigationBarScreen();
          }
        } else {
          return Scaffold(
            backgroundColor: Color.fromRGBO(35, 36, 65, 1),
            body: Center(
              child: SpinKitChasingDots(
                color: Colors.amber[800],
              ),
            ),
          );
        }
      },
    );
  }
}
