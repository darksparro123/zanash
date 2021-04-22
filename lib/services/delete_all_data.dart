import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteData {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<bool> deleteAllData() async {
    try {
      await firebase.collection("users").doc(auth.currentUser.email).delete();
      await firebase
          .collection("user_data")
          .doc(auth.currentUser.email)
          .delete();

      return true;
    } catch (e) {
      print("delete failed $e");
      return false;
    }
  }
}
