import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SaveWeight {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  //save weight
  Future<bool> saveWeight(double weight, String unit) async {
    try {
      DocumentReference documentReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("weight")
          .doc("weight");
      firebase.runTransaction((transaction) async {
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);
        if (documentSnapshot.exists) {
          transaction
              .update(documentReference, {"weight": weight, "unit": unit});
        } else {
          transaction.set(documentReference, {"weight": weight, "unit": unit});
        }
      });
      return true;
    } catch (e) {
      print("Save weight failed $e");
      return false;
    }
  }

  Future<bool> saveHeight(double height, String unit) async {
    try {
      DocumentReference documentReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("height")
          .doc("height");

      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          transaction
              .update(documentReference, {"height": height, "unit": unit});
        } else {
          transaction.set(documentReference, {"height": height, "unit": unit});
        }
      });
      return true;
    } catch (e) {
      print("set height failed $e");
      return false;
    }
  }
}
