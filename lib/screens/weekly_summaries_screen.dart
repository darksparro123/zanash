import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

import 'package:get/get.dart';
import 'package:zaanassh/screens/daily_record_screen.dart';

class WeeklySummariesScreen extends StatefulWidget {
  @override
  _WeeklySummariesScreenState createState() => _WeeklySummariesScreenState();
}

class _WeeklySummariesScreenState extends State<WeeklySummariesScreen> {
  @override
  void initState() {
    super.initState();
  }

  timeMethod() {
    DateTime now = DateTime.now();
    //DateTime after = now.subtract(Duration(days: 7));
    var a = now.difference(DateTime.utc(DateTime.now().year));
    int inDays = a.inDays;
    var b = now.add(Duration(days: 28)).day;

    double week = inDays / 7;
    print("week is ${week.toString().split(".")[0]} $b");
    if (DateTime.now().day == 1) {
      var weekOneEndDay = now.add(Duration(days: 7));
    }
  }

  String getMonth(String month) {
    String monthname = "";
    switch (month) {
      case "01":
        monthname = "January";
        break;
      case "02":
        monthname = "February";
        break;
      case "03":
        monthname = "March";
        break;
      case "04":
        monthname = "April";
        break;
      case "05":
        monthname = "May";
        break;
      case "06":
        monthname = "June";
        break;
      case "07":
        monthname = "July";
        break;
      case "08":
        monthname = "August";
        break;
      case "09":
        monthname = "September";
        break;
      case "10":
        monthname = "October";
        break;
      case "11":
        monthname = "November";

        break;
      case "12":
        monthname = "December";
        break;

      default:
        monthname = "";
    }
    return monthname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        centerTitle: true,
        title: Text(
          "Weekly Summaries",
        ),
      ),
      body: Container(
        /*child: MaterialButton(
        onPressed: () {
          timeMethod();
          // Get.to(() => DailyRecordScreen());
        },
        child: Text("Click me"),*/
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("weekly_summaries")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return (!snapshot.hasData || snapshot.isBlank)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: Image.asset("assets/no_data.png")),
                      Text(
                        "No data",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          letterSpacing: 1.5,
                          fontSize: MediaQuery.of(context).size.width / 22,
                        ),
                      )
                    ],
                  )
                : ListView(
                    children: snapshot.data.docs.map((doc) {
                      if (!doc.exists) {
                        return Center(
                          child: SpinKitChasingDots(
                            color: Colors.orange[600],
                          ),
                        );
                      }
                      return (doc.id.split(" ")[2] ==
                              FirebaseAuth.instance.currentUser.email)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white.withOpacity(0.01),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => DailyRecordScreen(
                                            docId: doc.id,
                                            month: doc.data()["month"],
                                            year: doc.data()["year"],
                                          ),
                                        );
                                        print(doc.id);
                                      },
                                      title: Text(
                                        doc.id.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.orange[500],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              22.0,
                                        ),
                                      ),
                                      trailing: Icon(
                                          FontAwesomeIcons.arrowRight,
                                          color: Colors.orange),
                                    ),
                                    Container(
                                      color: Colors.grey[600],
                                      child: SizedBox(
                                        height: 0.54,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(width: 0.0);
                    }).toList(),
                  );
          },
        ),
      ),
    );
  }
}
