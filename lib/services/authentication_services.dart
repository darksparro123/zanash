import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationServices {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
//sign up with emnai
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

//signup with google
  Future<bool> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      var a = await FirebaseAuth.instance.signInWithCredential(credential);
      print(a.user);
      return true;
    } catch (e) {
      Get.dialog(Dialog(
          child: Container(
        child: Text("Google sign in faled $e"),
      )));
      return false;
    }
  }

//sign up with facebook
  Future<bool> signUpWithFacebook() async {
    try {
      final fb = FacebookLogin();
      final result = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);
      switch (result.status) {
        case FacebookLoginStatus.success:
          //get token
          final FacebookAccessToken facebookAccessToken = result.accessToken;
          //create credetial
          final AuthCredential authCredential =
              FacebookAuthProvider.credential(facebookAccessToken.token);
          // sign in with credential
          final r = await auth.signInWithCredential(authCredential);
          print("email is ${r.user.email}");
          print("worked");
          break;
        case FacebookLoginStatus.cancel:
          print("Cancled");

          break;
        case FacebookLoginStatus.error:
          print("error");

          break;
      }
      return false;
    } catch (e) {
      print("Facebook sign in faled $e");
      return false;
    }
  }

//sign in with email
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

//forget password
  Future<bool> forgetPassword(String email) async {
    try {
      auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // register user information
  Future<bool> registerUser(String email, String mobileNumber) async {
    try {
      firebase.collection("user_information").doc(email).set(
        {
          "user_mobile_number": mobileNumber,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
