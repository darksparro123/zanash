import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SetGoal {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // set goal
  Future<bool> setStepGoal(String steps) async {
    DocumentReference documentReference = firebase
        .collection("users")
        .doc(auth.currentUser.email)
        .collection("goals")
        .doc("step_goal");
    await firebase.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(documentReference);
      if (documentSnapshot.exists) {
        transaction.update(documentReference, {"step_goal": steps});
      } else {
        transaction.set(documentReference, {"step_goal": steps});
      }
    });
    return true;
  }

  Future<bool> setWeightGoal(String weight) async {
    DocumentReference documentReference = firebase
        .collection("users")
        .doc(auth.currentUser.email)
        .collection("goals")
        .doc("weight_goal");
    await firebase.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(documentReference);
      if (documentSnapshot.exists) {
        transaction.update(documentReference, {"weight_goal": weight});
      } else {
        transaction.set(documentReference, {"weight_goal": weight});
      }
    });
    return true;
  }

  Future<bool> setcalorieGoal(String calories) async {
    DocumentReference documentReference = firebase
        .collection("users")
        .doc(auth.currentUser.email)
        .collection("goals")
        .doc("calorie_goal");
    await firebase.runTransaction((transaction) async {
      DocumentSnapshot documentSnapshot =
          await transaction.get(documentReference);
      if (documentSnapshot.exists) {
        transaction.update(documentReference, {"calorie_goal": calories});
      } else {
        transaction.set(documentReference, {"calorie_goal": calories});
      }
    });
    return true;
  }
}
