import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SaveWater {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
//save users water
  Future<bool> saveWater(int times) async {
    DateTime now = DateTime.now();
    String today = DateFormat("MM dd").format(now);
    String email = auth.currentUser.email;
    String docId = today + " " + email;
    try {
      DocumentReference documentReference = firebase
          .collection("daily_activities")
          .doc(email)
          .collection("water_drinks")
          .doc(docId);

      await firebase.runTransaction((transaction) async {
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);

        if (!documentSnapshot.exists) {
          transaction.set(documentReference, {
            "user_email": email,
            "times": times,
          });
        } else {
          int previousTimes = documentSnapshot.data()["times"];
          int newTimes = times + previousTimes;
          if (newTimes > 40) {
            newTimes = 40;
          }
          transaction.update(documentReference, {"times": newTimes});
        }
      });

      return true;
    } catch (e) {
      print("Save water failed $e");
      return false;
    }
  }
}
