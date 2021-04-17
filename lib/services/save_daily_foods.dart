import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SaveFoodDetails {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  var now = DateFormat.yMMMd().format(DateTime.now()); //save food
  Future<bool> setFood(
    String meal,
    List<Map> foodsData,
    String totalCalories,
  ) async {
    try {
      await firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("food")
          .doc(now.toString() + " $meal")
          .set({
        "meal": meal,
        "total_calories": totalCalories,
        "food_data": foodsData,
      });

      return true;
    } catch (e) {
      print("Add data failed $e");
      return false;
    }
  }

  int dayOfYear(DateTime date) {
    int total = 0;
    for (int i = 1; i < date.month; i++) {
      total += getDayOfMonth(date.year, i);
    }
    total += date.day;
    return total;
  }

  int getDayOfMonth(int year, int month) {
    final List<int> days = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (year % 4 == 0) days[DateTime.february]++;
    return days[month];
  }
}
