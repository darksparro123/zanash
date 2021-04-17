import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SaveChallengeResult {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  //save challenge result
  Future<bool> saveChallengeResult(
    int steps,
    String challengId,
  ) async {
    String docID = "${auth.currentUser.email} $challengId";
    try {
      DocumentReference documentReference =
          firebase.collection("challenge_results").doc(docID);
      firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.data != null) {
          transaction.set(
            documentReference,
            {
              "user_id": auth.currentUser.email,
              "result": steps,
            },
          );
        } else {
          transaction.update(
            documentReference,
            {
              "user_id": auth.currentUser.email,
              "result": steps + snapshot.data()["result"],
            },
          );
        }
      });

      return true;
    } catch (e) {
      print("save challenge failed $e");
      return false;
    }
  }
}
