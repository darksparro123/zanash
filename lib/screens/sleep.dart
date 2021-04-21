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
  int sleepTimes = 0;
  Future<int> checkSleep() async {
    DocumentReference documentReference = firebase
        .collection("daily_activities_sleep")
        .doc(
            "${DateTime.now().day} ${FirebaseAuth.instance.currentUser.email}");

    if (documentReference != null) {
      firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          setState(() {
            sleepTimes = snapshot.data()["sleep_times"];
          });
        }
      });
    }
    // print("Sleep times is ${sleepTimes / 1}");
    return sleepTimes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: checkSleep(),
      //initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: SpinKitChasingDots(color: Colors.amber[700]));
        }
        //print(docId);
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                backgroundColor: Colors.grey[600],
                radius: 80.0,
                lineWidth: 8.0,
                percent: (snapshot.data / 6 > 1) ? 1.0 : snapshot.data / 6,
                center: new Text(
                  "${snapshot.data}h",
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
              Text("SLEEP",
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
