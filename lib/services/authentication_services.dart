import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import "package:http/http.dart" as http;
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
      /*final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);
      if (res.status == FacebookLoginStatus.success) {
        return true;
      } else {
        print("login failed");
        return false;
      }*/
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email,
        ],
      );
      final token = result.accessToken.token;
      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
      final profile = jsonDecode(graphResponse.body);
      print(profile);
      return true;
    } catch (e) {
      Get.dialog(Dialog(child: Text(e.toString())));

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
