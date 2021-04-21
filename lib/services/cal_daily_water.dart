import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CalDailyWaterUsage extends StatefulWidget {
  @override
  _CalDailyWaterUsageState createState() => _CalDailyWaterUsageState();
}

class _CalDailyWaterUsageState extends State<CalDailyWaterUsage> {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  String docId =
      "${DateFormat("MM dd").format(DateTime.now())} ${FirebaseAuth.instance.currentUser.email}";
  double a = 0.0;
  Future<double> checkWaterCal() async {
    DocumentReference documentReference = firebase
        .collection("daily_activities")
        .doc(auth.currentUser.email)
        .collection("water_drinks")
        .doc(docId);

    if (documentReference != null) {
      //print("$docId");
      firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        setState(() {
          a = snapshot.data()["times"].toDouble();
        });
        //print("snapshot exists ${snapshot.data()}");
      });
    }

    // print("a is $a");
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: checkWaterCal(),
      //initialData: initialData ,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: SpinKitChasingDots(color: Colors.amber[700]));
        }
        //    print(docId);
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                backgroundColor: Colors.grey[600],
                radius: 80.0,
                lineWidth: 8.0,
                percent: (snapshot.data / 40 > 1) ? 1 : snapshot.data / 40,
                center: new Text(
                  "${(snapshot.data * 100) / 1000} ltr",
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
              Text("DRINK",
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
