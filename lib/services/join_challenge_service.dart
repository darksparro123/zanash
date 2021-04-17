import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinChallenge {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  //join challenge
  Future<bool> joinChallenge(
    String docId,
    String name,
    String goal,
    String imageLink,
  ) async {
    try {
      DocumentReference documentReference =
          firebase.collection("challenges").doc(docId);
      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        int previusParticipents = snapshot.data()["challenge_participents"];
        transaction.update(documentReference,
            {"challenge_participents": previusParticipents + 1});
      });

      await firebase
          .collection("user_data")
          .doc(auth.currentUser.email)
          .collection("challenges")
          .doc()
          .set({
        "challenge_id": docId,
        "name": name,
        "goal": goal,
        "image_link": imageLink,
      });
      return true;
    } catch (e) {
      print("Join challenge failed $e");
      return false;
    }
  }
}
