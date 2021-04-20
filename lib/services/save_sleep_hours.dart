import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:zaanassh/services/save_activity.dart';

class SleepHours {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  SaveActivity saveActivity = SaveActivity();
//save sleep houers
  Future<bool> saveSleepHours(int hours) async {
    try {
      DateTime now = DateTime.now();
      String today = DateFormat("dd").format(now);
      String email = auth.currentUser.email;
      String docId = today + " " + email;
      int month = DateTime.now().month;

      int week = (dayOfYear(DateTime.now()) ~/ 7).toInt();
      String weekDocId = "week $week ${auth.currentUser.email}";
      DocumentReference documentReference =
          firebase.collection("daily_activities_sleep").doc(docId);
      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists || snapshot.data()["sleep_time"] == null) {
          transaction.set(
            documentReference,
            {
              "user_id": email,
              "sleep_times": hours,
              "date": DateTime.now(),
              "month": saveActivity.getMonth(month),
              "day": DateTime.now().day,
            },
          );
        } else {
          int previousTimes = snapshot.data()["sleep_times"];
          int newTimes = hours + previousTimes;
          transaction.update(documentReference, {"sleep_times": newTimes});
        }
      });
      DocumentReference weeklyReference = firebase
          .collection("weekly_summaries")
          .doc(weekDocId)
          .collection("sleep")
          .doc("sleep");
      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(weeklyReference);

        if (!snapshot.exists || snapshot.data()["sleep_times"] == null) {
          print("Snapshot isn't exists");
          transaction.set(
            weeklyReference,
            {
              "user_id": email,
              "sleep_times": hours,
              "date": DateTime.now(),
              "month": saveActivity.getMonth(month),
              // "day": DateTime.now().day,
            },
          );
        } else {
          int previousTimes = snapshot.data()["sleep_times"];
          int newTimes = hours + previousTimes;
          transaction.update(weeklyReference, {"sleep_times": newTimes});
        }
      });
      return true;
    } catch (e) {
      print("save sleep hours failed $e");
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
