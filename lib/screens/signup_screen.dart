import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/choose_sport.dart';
import 'package:zaanassh/screens/navigation_bar.dart';
import 'package:zaanassh/screens/signin_screen.dart';
import 'package:zaanassh/screens/signup_with_email_screen.dart';
import 'package:zaanassh/services/authentication_services.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.asset(
              "assets/signup_background.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color.fromRGBO(14, 24, 50, 0.7),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2.0 - 65,
              left: MediaQuery.of(context).size.width / 8.0,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "ZAA",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 18,
                        letterSpacing: 3.0,
                      ),
                    ),
                    TextSpan(
                      text: "NASH",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: MediaQuery.of(context).size.width / 18,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2.0 - 37,
              left: MediaQuery.of(context).size.width / 8.0,
              child: Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 10,
                  //letterSpacing: 3.0,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2.0 + 15,
              left: MediaQuery.of(context).size.width / 8.0,
              child: Text(
                "train and live the new experience of",
                style: TextStyle(
                  color: Colors.white, //fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 26,
                  //letterSpacing: 3.0,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2.0 + 40,
              left: MediaQuery.of(context).size.width / 8.0,
              child: Text(
                "Healthy Life.",
                style: TextStyle(
                  color: Colors.white, //fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 26,
                  //letterSpacing: 3.0,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2.0 + 70,
              left: MediaQuery.of(context).size.width / 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      bool shouldNavigate =
                          await AuthenticationServices().signUpWithFacebook();
                      if (shouldNavigate) {
                        Get.to(() => ChooseSport());
                        print(FirebaseAuth.instance.currentUser.email);
                      } else {
                        Get.dialog(AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          backgroundColor:
                              Color.fromRGBO(35, 36, 70, 1).withOpacity(0.4),
                          elevation: 3.0,
                          title: Text(
                            "Something went wrong",
                            style: TextStyle(
                              color: Colors.orange[600],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text("Okay"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ));
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                        //color: Color.fromRGBO(14, 24, 50, 0.8),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(14, 24, 50, 0.8),
                            Colors.indigo[900],
                            // Color.fromRGBO(14, 24, 50, 0.8),
                            //Colors.indigo[900],
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      child: Text(
                        "Continue with Facebook",
                        style: TextStyle(
                          color: Colors.white, //fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 26,
                          //letterSpacing: 3.0,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      bool shouldNavigate =
                          await AuthenticationServices().signUpWithGoogle();

                      if (shouldNavigate) {
                        Get.to(() => ChooseSport());
                      } else {
                        /*Get.dialog(AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          backgroundColor:
                              Color.fromRGBO(35, 36, 70, 1).withOpacity(0.4),
                          elevation: 3.0,
                          title: Text(
                            "Something went wrong",
                            style: TextStyle(
                              color: Colors.orange[600],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text("Okay"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ));*/
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(14, 24, 50, 0.8),
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightGreen[600],
                            //Colors.yellow[900],
                            Colors.orange,
                            Colors.pink,
                            //Colors.indigo[600],
                            // Colors.blue[900],
                            Colors.purple,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      child: Text(
                        "Continue with Google",
                        style: TextStyle(
                          color: Colors.white, //fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 26,
                          //letterSpacing: 3.0,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Already have an account ?",
                    style: TextStyle(
                      color: Colors.white, //fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 26,
                      //letterSpacing: 3.0,
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.to(() => SignInScreen());
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(14, 24, 50, 0.8),
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white, //fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 26,
                          //letterSpacing: 3.0,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "New to Zaanassh ?",
                        style: TextStyle(
                          color: Colors.white, //fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 26,
                          //letterSpacing: 3.0,
                        ),
                      ),
                      TextButton(
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.orange, //fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width / 26,
                            //letterSpacing: 3.0,
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => SignupWithEmailScreen());
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
