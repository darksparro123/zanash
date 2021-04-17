import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  ) async {
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
      });
      return true;
    } catch (e) {
      print("Create challenge failed $e");
      return false;
    }
  }
}
