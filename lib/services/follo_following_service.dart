import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowFollowingService {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  //follow service
  Future<bool> sendFollowrequest(
    String userEmail,
    String name,
    String city,
    String country,
    String imageLink,
  ) async {
    try {
      await firebase.collection("follow_requests").doc().set({
        "follower_email": userEmail,
        "request_email": auth.currentUser.email,
        "name": name,
        "city": city,
        "country": country,
        "image_link": imageLink,
        "accepted": false,
      });
      DocumentReference documentReference = firebase
          .collection("user_data")
          .doc(auth.currentUser.email)
          .collection("followers")
          .doc("followes");
      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          int previosFollwers = snapshot.data()["followers"];
          int newFollwCount = previosFollwers + 1;
          transaction.set(documentReference, {"followers": newFollwCount});
        } else {
          transaction.set(documentReference, {"followers": 1});
        }
      });
      return true;
    } catch (e) {
      print("Send follw request failed $e");
      return false;
    }
  }

  // following service
  Future<bool> following(String docId) async {
    try {
      await firebase.collection("follow_requests").doc(docId).update({
        "accepted": true,
      });
      DocumentReference documentReference = firebase
          .collection("user_data")
          .doc(auth.currentUser.email)
          .collection("followings")
          .doc("followings");
      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          int previosFollwers = snapshot.data()["followings"];
          int newFollwCount = previosFollwers + 1;
          transaction.set(documentReference, {"followings": newFollwCount});
        } else {
          transaction.set(documentReference, {"followings": 1});
        }
      });
      return true;
    } catch (e) {
      print("Send follw request failed $e");
      return false;
    }
  }
}
