import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SaveActivity {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<bool> saveUserActivity(
      String title,
      String sport,
      String type,
      String description,
      String avgSpeed,
      String distance,
      String time,
      String caloriesBurned,
      double dlat,
      double dlon,
      double olat,
      double olon) async {
    try {
      await firebase.collection("saved_activities").doc().set({
        "customer_id": auth.currentUser.email,
        "date": DateTime.now(),
        "avg_speed": avgSpeed,
        "distance": distance,
        "time": time,
        "calories_burned": caloriesBurned,
        "title": title,
        "sport": sport,
        "type": type,
        "description": description,
        "destin_lat": dlat,
        "destin_lon": dlon,
        "origin_lat": olat,
        "origin_lon": olon,
      });

      savetoweeeklySummaries(double.parse(distance), caloriesBurned);
      saveDailyActivity(double.parse(distance));
      addTotalSteps(double.parse(distance));
      return true;
    } catch (e) {
      print("Save activity failed $e");
      return false;
    }
  }

  int dayOfWeek({DateTime date}) {
    if (date == null) date = DateTime.now();

    int w = ((dayOfYear(date) - date.weekday + 10) / 7).floor();

    if (w == 0) {
      w = getYearsWeekCount(date.year - 1);
    } else if (w == 53) {
      DateTime lastDay = DateTime(date.year, DateTime.december, 31);
      if (lastDay.weekday < DateTime.thursday) {
        w = 1;
      }
    }
    return w;
  }

  int getYearsWeekCount(int year) {
    DateTime lastDay = DateTime(year, DateTime.december, 31);
    int count = dayOfWeek(date: lastDay);
    if (count == 1)
      count = dayOfWeek(date: lastDay.subtract(Duration(days: 7)));
    return count;
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

  // add to weekly summaries
  Future<bool> savetoweeeklySummaries(
      double distance, String totalCalories) async {
    int steps = (distance ~/ 2).toInt();

    int week = (dayOfYear(DateTime.now()) ~/ 7).toInt();
    String docId = "week $week ${auth.currentUser.email}";
    print("Save to weekly summaries called ");
    try {
      DocumentReference documentReference = firebase
          .collection("weekly_steps_summaries")
          .doc(docId)
          .collection("steps")
          .doc("steps");
      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (!snapshot.exists) {
          transaction.set(documentReference, {
            "average_steps": steps,
            "highest_steps": steps,
            "least_steps": steps,
            "month": getMonth(DateTime.now().month),
            "total_calories": totalCalories,
            "year": DateTime.now().year,
            "user_id": auth.currentUser.email
          });
          await firebase
              .collection("weekly_steps_summaries")
              .doc(docId)
              .set({"email": auth.currentUser.email});
          print("Weeekly data added succusfully");
        } else {
          int highestStapes = 0;
          int lowest = 0;
          if ((snapshot.data()["highest_steps"]).toInt() < steps) {
            highestStapes = steps;
          } else {
            highestStapes = snapshot.data()["highest_steps"].toInt();
          }
          if (snapshot.data()["least_steps"].toInt() > steps) {
            lowest = steps;
          } else {
            lowest = snapshot.data()["least_steps"].toInt();
          }
          if (snapshot.data()["average_steos"] + steps < 42000) {
            transaction.update(documentReference, {
              "average_steps": steps + snapshot.data()["average_steps"].toInt(),
              "highest_steps": highestStapes,
              "least_steps": lowest,
              "total_calories": totalCalories,
            });
          } else {
            transaction.update(documentReference, {
              "average_steps": 42000,
              "highest_steps": highestStapes,
              "least_steps": lowest,
              "total_calories": totalCalories,
            });
          }
          print(
              "Weeekly data updated succusfully $lowest $highestStapes ${steps + snapshot.data()["average_steps"]}");
        }
      });
      //print("week is $week");

      return true;
    } catch (e) {
      print("save to week failed $e");
      return false;
    }
  }

  String getMonth(int index) {
    String monthname = "";
    switch (index) {
      case 1:
        monthname = "January";
        break;
      case 2:
        monthname = "February";
        break;
      case 3:
        monthname = "March";
        break;
      case 4:
        monthname = "April";
        break;
      case 5:
        monthname = "May";
        break;
      case 6:
        monthname = "June";
        break;
      case 7:
        monthname = "July";
        break;
      case 8:
        monthname = "August";
        break;
      case 9:
        monthname = "September";
        break;
      case 10:
        monthname = "October";
        break;
      case 11:
        monthname = "November";

        break;
      case 12:
        monthname = "December";
        break;

      default:
        monthname = "";
    }
    return monthname;
  }

  // save daily activity
  Future<bool> saveDailyActivity(double distance) async {
    int today = DateTime.now().day;
    int month = DateTime.now().month;
    String docId = "$today ${auth.currentUser.email}";
    int steps = distance ~/ 2;
    try {
      DocumentReference documentReference =
          firebase.collection("daily_activities").doc(docId);
      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (!snapshot.exists) {
          transaction.set(
            documentReference,
            {
              "steps": steps,
              "month": getMonth(month),
              "user_id": auth.currentUser.email,
              "day": DateTime.now().day
            },
          );
        } else if (snapshot.data()["steps"] == null) {
          transaction.set(
              documentReference, {"steps": steps, "day": DateTime.now().day});
        } else {
          transaction.update(
            documentReference,
            {
              "steps": steps + snapshot.data()["steps"],
              "month": getMonth(month),
              "user_id": auth.currentUser.email,
              "day": DateTime.now().day
            },
          );
        }
      });
      return true;
    } catch (e) {
      print("A Save daily acitivity failed $e");

      return false;
    }
  }

  //add total calories
  Future addTotalSteps(double distance) async {
    int steps = distance ~/ 2;
    try {
      DocumentReference documentReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("total_steps")
          .doc("total_steps");
      await firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (!snapshot.exists) {
          transaction.set(
            documentReference,
            {
              "total_steps": steps,
              "user_id": auth.currentUser.email,
            },
          );
        } else if (snapshot.data()["total_steps"] == null) {
          transaction.set(documentReference, {
            "total_steps": steps,
          });
        } else {
          transaction.update(
            documentReference,
            {
              "total_steps": steps + snapshot.data()["total_steps"],
              "user_id": auth.currentUser.email,
            },
          );
        }
      });
    } catch (e) {
      print("save total steps failed $e");
    }
  }

  Future<bool> saveBPM(double bpm) async {
    try {
      DocumentReference documentReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("heart_bpm")
          .doc("heart_bpm");
      firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (snapshot.exists) {
          transaction.update(documentReference, {
            "heart_bpm": bpm,
          });
        } else {
          transaction.set(documentReference, {"heart_bpm": bpm});
        }
      });
      return true;
    } catch (e) {
      print("save bpm failed $e");
      return false;
    }
  }
}
