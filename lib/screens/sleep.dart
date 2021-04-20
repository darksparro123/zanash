import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SleepIndicator extends StatefulWidget {
  @override
  _SleepIndicatorState createState() => _SleepIndicatorState();
}

class _SleepIndicatorState extends State<SleepIndicator> {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<int> checkSleep() {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: firebase
          .collection("daily_activities_sleep")
          .doc(
              "${DateTime.now().day} ${FirebaseAuth.instance.currentUser.email}")
          .snapshots(),
      //initialData: initialData ,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data["sleep_times"] == null) {
          return Center(child: SpinKitChasingDots(color: Colors.amber[700]));
        }
        //print(docId);
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 8.0,
                percent: (snapshot.data["sleep_times"] / 6 > 1)
                    ? 1.0
                    : snapshot.data["sleep_times"] / 6,
                center: new Text(
                  "${snapshot.data["sleep_times"]}h",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                progressColor: Colors.lightBlue,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text("Drink",
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
