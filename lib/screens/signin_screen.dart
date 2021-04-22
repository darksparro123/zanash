import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/choose_sport.dart';
import 'package:zaanassh/screens/forget_password_scren.dart';
import 'package:zaanassh/screens/privacy_screeen.dart';
import 'package:zaanassh/screens/settings.dart';
import 'package:zaanassh/screens/signup_screen.dart';
import 'package:zaanassh/screens/signup_with_email_screen.dart';
import 'package:zaanassh/services/authentication_services.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/signin_background.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(35, 36, 65, 0.7),
                      Color.fromRGBO(35, 36, 65, 0.7),
                      Color.fromRGBO(35, 36, 65, 1),
                      Color.fromRGBO(35, 36, 65, 1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                )),
            Positioned(
              left: MediaQuery.of(context).size.width / 8,
              top: MediaQuery.of(context).size.height / 3 - 50,
              child: Text(
                "sign in",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 8.0,
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 8,
              top: MediaQuery.of(context).size.height / 3 + 20,
              child: Text("train and live new experience of",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 25.0,
                  )),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 8,
              top: MediaQuery.of(context).size.height / 3 + 40,
              child: Text("Healthy Life.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 25.0,
                  )),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 8,
              top: MediaQuery.of(context).size.height / 3 + 110,
              child: Form(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: TextFormField(
                          validator: (val) =>
                              val.isEmpty ? "Please enter valid email" : null,
                          controller: emailController,
                          autofocus: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 18,
                          ),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: MediaQuery.of(context).size.width / 22,
                            ),
                            labelText: "Email",
                            enabledBorder: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 8,
              top: MediaQuery.of(context).size.height / 3 + 190,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextFormField(
                      validator: (val) => val.isEmpty ? "enter password" : null,
                      controller: passwordController,
                      autofocus: true,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 18,
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: MediaQuery.of(context).size.width / 22,
                        ),
                        labelText: "Password",
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width / 12,
              top: MediaQuery.of(context).size.height / 3 + 270,
              child: TextButton(
                child: Text("Forgot your password?",
                    style: TextStyle(color: Colors.amber)),
                onPressed: () {
                  Get.to(() => ForgetPassword());
                },
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 8,
              top: MediaQuery.of(context).size.height / 3 + 320,
              child: Column(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        bool shouldNavigate = await AuthenticationServices()
                            .signInWithEmail(
                                emailController.text, passwordController.text);
                        if (shouldNavigate) {
                          Get.to(() => PrivacyScreen());
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
                                color: Colors.amber[600],
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
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                        //  color: Color.fromRGBO(35, 36, 120, 1),
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
                        "Login",
                        style: TextStyle(
                          color: Colors.white, //fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 16,
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
                    onPressed: () {
                      Get.to(() => SignupScreen());
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(14, 24, 50, 0.8),
                        border: Border.all(color: Colors.amber),
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.white, //fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width / 16,
                          //letterSpacing: 3.0,
                        ),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
