import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class CreateChallenge {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // create challenge
  Future<bool> createChallenge(
      String challengeName,
      String challengeDescription,
      bool isPublic,
      String challengeDate,
      int goal,
      String imageLink) async {
    String email = auth.currentUser.email;
    try {
      await firebase.collection("challenges").doc().set({
        "create_email": email,
        "is_public": isPublic,
        "challenge_name": challengeName,
        "challenge_description": challengeDescription,
        "challenge_date": challengeDate,
        "goal": goal,
        "created_at": DateTime.now(),
        "challenge_participents": 0,
        "image_link": imageLink,
      }).then((value) {});

      return true;
    } catch (e) {
      print("Create challenge failed $e");
      return false;
    }
  }

  Future<String> uploadFile(
    File file,
    BuildContext context,
    String challengeName,
    String challengeDescription,
    bool isPublic,
    String challengeDate,
    int goal,
  ) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }
    FirebaseStorage storage = FirebaseStorage.instance;
    String email = FirebaseAuth.instance.currentUser.email;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('challengeImages')
        .child(FirebaseAuth.instance.currentUser.email);
    TaskSnapshot snapshot =
        await storage.ref().child("avatars/$email").putFile(file);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      createChallenge(challengeName, challengeDescription, isPublic,
          challengeDate, goal, downloadUrl);

      return "Succeful";
    } else {
      return "Unsuccesful";
    }
  }

  loadingWidget(BuildContext context, Future<String> function) {
    return FutureBuilder(
        future: function,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData || snapshot.data == "") {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Center(
                child: SpinKitChasingDots(
                  color: Colors.amber[700],
                ),
              ),
            );
          }
          return AlertDialog(
            title: Text(
              "Sucssesfully uploaded",
              style: TextStyle(
                color: Colors.indigo,
              ),
            ),
          );
        });
  }
}
