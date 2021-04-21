import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CalCaloriesPercantage extends StatefulWidget {
  @override
  _CalCaloriesPercantageState createState() => _CalCaloriesPercantageState();
}

class _CalCaloriesPercantageState extends State<CalCaloriesPercantage> {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  double a = 0.0;
  double b = 0.0;
  double c = 0.0;
  Future<double> cal() async {
    try {
      var now = DateFormat.yMMMd().format(DateTime.now());
      // print("now is $now");
      String bId = "$now Breakfast";
      String lId = "$now Lunch";
      String dId = "$now Dinner";
      DocumentReference breakfastReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("food")
          .doc(bId);

      DocumentReference lunchReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("food")
          .doc(lId);
      DocumentReference dinnerReference = firebase
          .collection("users")
          .doc(auth.currentUser.email)
          .collection("food")
          .doc(dId);

      firebase.runTransaction((transaction) async {
        if (breakfastReference != null) {
          DocumentSnapshot bSnapshot =
              await transaction.get(breakfastReference);
          if (bSnapshot.data() != null) {
            setState(() {
              a = double.parse(bSnapshot.data()["total_calories"]);
              // print(
              //   "bsnapshot is ${bSnapshot.data()["total_calories"]} a is $a");
            });
          }
        }
        if (lunchReference != null) {
          DocumentSnapshot lSnapshot = await transaction.get(lunchReference);
          if (lSnapshot.data() != null) {
            setState(() {
              b = double.parse(lSnapshot.data()["total_calories"]);
              //  print("lsnapshot is ${lSnapshot.data()}");
            });
          }
        }
        if (dinnerReference != null) {
          DocumentSnapshot dSnapshot = await transaction.get(dinnerReference);
          if (dSnapshot.data() != null) {
            setState(() {
              c = double.parse(dSnapshot.data()["total_calories"]);
              // print("dsnapshot is ${dSnapshot.data()}");
            });
          }
        }
      });
      // print("abc is $a");

      return (a + b + c);
    } catch (e) {
      print("Caculate c failed $e");
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cal(),
      //initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: SpinKitChasingDots(color: Colors.amber[700]));
        }
        //s print("snapsht data is ${snapshot.data}");
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                backgroundColor: Colors.grey[600],
                radius: 80.0,
                lineWidth: 8.0,
                percent: snapshot.data / 3044,
                center: new Text(
                  "${snapshot.data}Kc",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                progressColor: Colors.red,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text("NUTRITION",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 22.0))
            ],
          ),
        );
      },
    );
  }
}
