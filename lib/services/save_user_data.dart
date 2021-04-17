import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SaveUserData {
  final firebase = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;

  //save name
  Future<bool> saveName(String name) async {
    try {
      DocumentReference documentReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("user_data")
          .doc("name");

      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          transaction.update(documentReference, {"name": name});
        } else {
          transaction.set(documentReference, {"name": name});
        }
      });
      setData("name", name);
      print("Added succusfully");
      return true;
    } catch (e) {
      print("Save name failed $e");
      return false;
    }
  }

//save city
  Future<bool> saveCity(String city) async {
    try {
      DocumentReference documentReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("user_data")
          .doc("city");

      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          transaction.update(documentReference, {"city": city});
        } else {
          transaction.set(documentReference, {"city": city});
        }
      });
      setData("city", city);
      print("Added succusfully");
      return true;
    } catch (e) {
      print("Save name failed $e");
      return false;
    }
  }

//save country
  Future<bool> saveCountry(String country) async {
    try {
      DocumentReference documentReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("user_data")
          .doc("country");

      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          transaction.update(documentReference, {"country": country});
        } else {
          transaction.set(documentReference, {"country": country});
        }
      });
      setData("country", country);
      print("Added succusfully");
      return true;
    } catch (e) {
      print("Save name failed $e");
      return false;
    }
  }

//save name
  Future<bool> saveGender(String name) async {
    try {
      DocumentReference documentReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("user_data")
          .doc("gender");

      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          transaction.update(documentReference, {"gender": name});
        } else {
          transaction.set(documentReference, {"gender": name});
        }
      });
      return true;
    } catch (e) {
      print("Save gender failed $e");
      return false;
    }
  }

//save name
  Future<bool> saveAge(String name) async {
    try {
      DocumentReference documentReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("user_data")
          .doc("age");

      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          transaction.update(documentReference, {"age": name});
        } else {
          transaction.set(documentReference, {"age": name});
        }
      });
      return true;
    } catch (e) {
      print("Save age failed $e");
      return false;
    }
  }

  Future setData(String data, String value) async {
    await firebase.collection("users").doc(auth.currentUser.email).set({
      "$data": value,
    });
  }
}
