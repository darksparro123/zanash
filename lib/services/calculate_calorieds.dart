import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalculateColories {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  //get  age,weight,
  Future<double> calculateCalories(int time) async {
    double calories = 0.0;
    DocumentReference ageReference = firebase
        .collection("users")
        .doc(auth.currentUser.email)
        .collection("user_data")
        .doc("age");

    DocumentReference weightReference = firebase
        .collection("users")
        .doc(auth.currentUser.email)
        .collection("weight")
        .doc("weight");
    firebase.runTransaction((transaction) async {
      DocumentSnapshot ageSnapshot = await transaction.get(ageReference);
      DocumentSnapshot weightSnapshot = await transaction.get(weightReference);
      int age = DateTime.now().year -
          int.parse(ageSnapshot.data()["age"].toString().split("-")[0]);
      print("Age is $age");
      double weight = weightSnapshot.data()["weight"];
      print("weight is $weight ");
      calories = (age * 0.074) -
          (weight * 0.05741) +
          (78 * 0.4472 - 20.4022) * time / 4.184;
    });

    return calories;
  }
}
