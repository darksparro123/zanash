import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/home_screen.dart';
import 'package:zaanassh/screens/navigation_bar.dart';
import 'package:zaanassh/screens/signin_screen.dart';
import 'package:zaanassh/screens/signup_screen.dart';
import 'package:zaanassh/services/authentication_services.dart';

class SignupWithEmailScreen extends StatefulWidget {
  @override
  _SignupWithEmailScreenState createState() => _SignupWithEmailScreenState();
}

class _SignupWithEmailScreenState extends State<SignupWithEmailScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/create_account_background.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.2,
              fit: BoxFit.fill,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(35, 36, 70, 0.5),
                      Color.fromRGBO(35, 36, 70, 0.5),
                      Color.fromRGBO(35, 36, 70, 0.9),
                      Color.fromRGBO(35, 36, 70, 1),
                      Color.fromRGBO(35, 36, 70, 1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                )),
            Positioned(
              top: MediaQuery.of(context).size.height / 2.5 - 50,
              left: MediaQuery.of(context).size.width / 10,
              child: Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 10.0,
                ),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height / 2.5 + 25,
                left: MediaQuery.of(context).size.width / 50,
                child: Form(
                    key: formKey,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: TextFormField(
                              controller: emailController,
                              validator: (val) => !val.isEmail
                                  ? "please enter valid email"
                                  : null,
                              // obscureText: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 18,
                              ),
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.amber,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22,
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
                          SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: TextFormField(
                              controller: mobileNumberController,
                              validator: (val) => !val.isNumericOnly
                                  ? "please fill this field"
                                  : null,
                              // obscureText: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 18,
                              ),
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.mobile_friendly_outlined,
                                  color: Colors.amber,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22,
                                ),
                                labelText: "Phone Number",
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: TextFormField(
                              controller: passwordController, obscureText: true,
                              validator: (val) =>
                                  val.isEmpty ? "please fill this field" : null,
                              // obscureText: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 18,
                              ),
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: Colors.amber,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22,
                                ),
                                labelText: "Password",
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 10,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              //Get.to(() => NavigationBarScreen());
                              if (formKey.currentState.validate()) {
                                bool shgouldNavigate =
                                    await AuthenticationServices()
                                        .signUpWithEmail(emailController.text,
                                            passwordController.text);

                                if (shgouldNavigate) {
                                  Get.to(() => NavigationBarScreen());
                                } else {
                                  Get.dialog(AlertDialog(
                                    backgroundColor:
                                        Color.fromRGBO(19, 20, 41, 1),
                                    title: Text(
                                      "Something went wrong",
                                      style: TextStyle(
                                        color: Colors.amber,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          autofocus: true,
                                          child: Text(
                                            "Try Again",
                                            style: TextStyle(
                                                color: Colors.amber[800]),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          })
                                    ],
                                  ));
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: MediaQuery.of(context).size.height / 12,
                              decoration: BoxDecoration(
                                //  color: Color.fromRGBO(35, 36, 120, 1),
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                  color: Colors
                                      .white, //fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 16,
                                  //letterSpacing: 3.0,
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 35,
                          ),
                          Row(
                            children: [
                              Text(
                                "Already Registered ?",
                                style: TextStyle(
                                  color: Colors
                                      .white, //fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22,
                                  //letterSpacing: 3.0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => SignInScreen());
                                },
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 22,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
