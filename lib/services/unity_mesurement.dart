import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UnityMesurement {
  final firebase = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;

  //change weight
  Future<bool> changeWait(String unity) async {
    try {
      switch (unity) {
        case "cm":
          break;
        case "":
          break;
      }

      return true;
    } catch (e) {
      print("Weight cgabged failed $e");
      return false;
    }
  }
}
