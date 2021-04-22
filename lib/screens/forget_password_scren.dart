import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/signin_screen.dart';
import 'package:zaanassh/services/authentication_services.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  final fomKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 20.0,
          ),
          child: Form(
            key: fomKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/forget_password.png",
                      height: MediaQuery.of(context).size.height / 2.8,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15.0,
                ),
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 8.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 25.0,
                ),
                Text(
                  "Enter your email address below.We will send you an SMS with a pin code to confirm your identity.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 28.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15.0,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 28.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0,
                  ),
                  validator: (val) =>
                      val.isEmpty ? "Please enter valid email" : null,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: MediaQuery.of(context).size.width / 26.0,
                    ),
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.white.withOpacity(0.4),
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
                Container(
                  color: Colors.grey[500].withOpacity(0.6),
                  child: SizedBox(
                    height: 0.45,
                    width: MediaQuery.of(context).size.width / 1.05,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10.0,
                ),
                MaterialButton(
                  onPressed: () async {
                    //Get.to(() => SignInScreen());
                    if (fomKey.currentState.validate()) {
                      bool a = await AuthenticationServices()
                          .forgetPassword(emailController.text);
                      if (a) {
                        Get.dialog(
                          AlertDialog(
                            title: Text(
                              "Check Your email",
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Get.to(SignInScreen());
                                  },
                                  child: Text("Okay"))
                            ],
                          ),
                        );
                      } else {
                        Get.dialog(
                          AlertDialog(
                            title: Text(
                              "Something went wrong.Please try again",
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Try again"))
                            ],
                          ),
                        );
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: MediaQuery.of(context).size.height / 12,
                    decoration: BoxDecoration(
                      // color: Color.fromRGBO(14, 24, 50, 0.8),
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    child: Text(
                      "Send Email",
                      style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400,
                        fontSize: MediaQuery.of(context).size.width / 20,
                        //letterSpacing: 3.0,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
