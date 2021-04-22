import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

import 'package:random_color/random_color.dart';
import 'package:zaanassh/screens/add_food_details_screen.dart';
import 'package:zaanassh/screens/ads/ad_screen.dart';
import 'package:zaanassh/screens/ads/banner_ad.dart';
import 'package:zaanassh/screens/cal_heart.dart';
import 'package:zaanassh/screens/add_sleep.dart';
import 'package:zaanassh/screens/add_water.dart';
import 'package:zaanassh/screens/drawe.dart';
import 'package:zaanassh/screens/my_challenges_screen.dart';
import 'package:zaanassh/screens/profile_screen.dart';
import 'package:zaanassh/screens/setGoalDialog.dart';
import 'package:zaanassh/screens/set_goal_dialog.dart';
import 'package:zaanassh/screens/start_map.dart';
import 'package:zaanassh/screens/start_runScreen.dart';
import 'package:zaanassh/screens/start_walk.dart';
import 'package:zaanassh/screens/weight.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:zaanassh/services/geo_locator_service.dart';
import 'package:zaanassh/services/save_activity.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GeolocatorService geolocatonService = GeolocatorService();
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  List<Colors> colorList = [];
  RandomColor _randomColor = RandomColor();
  //set month

  void initState() {
    DrawerClass().getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          AdScreenState().loadAd();
        },
      ),*/
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "ZANN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width / 22,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: "ASH",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: MediaQuery.of(context).size.width / 22,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        shadowColor: Colors.white.withOpacity(0.1),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {
              Get.to(() => ProfileScreen());
            },
          ),
        ],
      ),
      drawer: DrawerClass().drawer(context),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Text(
            "GOALS",
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width / 25.0,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: MediaQuery.of(context).size.height / 7,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  alignment: Alignment.center,
                  child: StreamBuilder(
                      stream: firebase
                          .collection("users")
                          .doc(auth.currentUser.email)
                          .collection("goals")
                          .doc("step_goal")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child:
                                  SpinKitChasingDots(color: Colors.amber[700]));
                        }
                        if (!snapshot.data.exists ||
                            snapshot.data["step_goal"] == null) {
                          return MaterialButton(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.amber[700],
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              width: MediaQuery.of(context).size.width / 5,
                              height: MediaQuery.of(context).size.height / 35,
                              alignment: Alignment.center,
                              child: Text(
                                "Set Goal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 29.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              SetGoalDialog1().setGoalDialog(context, "steps");
                            },
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                              "Step Goal",
                              style: TextStyle(
                                color: Colors.amber[700],
                                fontSize:
                                    MediaQuery.of(context).size.width / 26.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${snapshot.data["step_goal"]} Steps",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 29.0,
                              ),
                            ),
                            MaterialButton(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[700],
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.height / 35,
                                alignment: Alignment.center,
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            32.0,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                SetGoalDialog1()
                                    .setGoalDialog(context, "steps");
                              },
                            )
                          ],
                        );
                      })),
              Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: MediaQuery.of(context).size.height / 7,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  alignment: Alignment.center,
                  child: StreamBuilder(
                      stream: firebase
                          .collection("users")
                          .doc(auth.currentUser.email)
                          .collection("goals")
                          .doc("weight_goal")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child:
                                  SpinKitChasingDots(color: Colors.amber[700]));
                        }
                        print("snapshot is ${snapshot.data.exists}");
                        if (!snapshot.data.exists ||
                            snapshot.data["weight_goal"] == null) {
                          return MaterialButton(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.amber[700],
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              width: MediaQuery.of(context).size.width / 5,
                              height: MediaQuery.of(context).size.height / 35,
                              alignment: Alignment.center,
                              child: Text(
                                "Sete Goal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              SetGoalDialog1().setGoalDialog(context, "weight");
                            },
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                "Weight Goal",
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${snapshot.data["weight_goal"]} Kg",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 26.0,
                                ),
                              ),
                              MaterialButton(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber[700],
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 35,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              29.0,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  SetGoalDialog1()
                                      .setGoalDialog(context, "weight");
                                },
                              )
                            ],
                          );
                        }
                      })),
              Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: MediaQuery.of(context).size.height / 7,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  alignment: Alignment.center,
                  child: StreamBuilder(
                      stream: firebase
                          .collection("users")
                          .doc(auth.currentUser.email)
                          .collection("goals")
                          .doc("calorie_goal")
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child:
                                  SpinKitChasingDots(color: Colors.amber[700]));
                        }
                        print("snapshot is ${snapshot.data.exists}");
                        if (!snapshot.data.exists ||
                            snapshot.data["calorie_goal"] == null) {
                          return MaterialButton(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.amber[700],
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              width: MediaQuery.of(context).size.width / 5,
                              height: MediaQuery.of(context).size.height / 35,
                              alignment: Alignment.center,
                              child: Text(
                                "Set Goal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 29.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              SetGoalDialog1()
                                  .setGoalDialog(context, "calorie");
                            },
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 3.0,
                              ),
                              Text(
                                "Calory Goal",
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${snapshot.data["calorie_goal"]} KCal",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 26.0,
                                ),
                              ),
                              MaterialButton(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber[700],
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 35,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25.0,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  SetGoalDialog1()
                                      .setGoalDialog(context, "calorie");
                                },
                              )
                            ],
                          );
                        }
                      })),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 300,
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 2.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder(
                            stream: firebase
                                .collection("users")
                                .doc(auth.currentUser.email)
                                .collection("total_steps")
                                .doc("total_steps")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.amber[700],
                                  ),
                                );
                              }
                              if (!snapshot.data.exists ||
                                  snapshot.data["total_steps"] == null) {
                                return Text(
                                  "You haven't start your workout yet",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            28.0,
                                  ),
                                );
                              }
                              if (snapshot.data["user_id"] ==
                                  auth.currentUser.email) {
                                return Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.shoePrints,
                                      color: Colors.grey[700],
                                    ),
                                    SizedBox(width: 20.0),
                                    Text(
                                        "${snapshot.data["total_steps"]} Steps",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              22.0,
                                        )),
                                  ],
                                );
                              }
                            }),
                        Text("${SaveActivity().getMonth(DateTime.now().month)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width / 22.0,
                            ))
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("daily_activities")
                        //.orderBy("date")
                        .where("month",
                            isEqualTo:
                                SaveActivity().getMonth(DateTime.now().month))
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child:
                                SpinKitChasingDots(color: Colors.amber[700]));
                      }

                      return //Expanded(
                          SizedBox(
                        height: MediaQuery.of(context).size.height / 3.9,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs.map((e) {
                            if (e.id.split(" ")[1] == auth.currentUser.email &&
                                e.data()["steps"] != null) {
                              double percentage =
                                  ((e.data()["steps"] / 6000) * 100) / 100;
                              if (percentage > 1) {
                                percentage = 1.0;
                              }
                              if (e.data()["steps"] == null) {
                                return Text(
                                  "No data",
                                  style: TextStyle(color: Colors.grey[600]),
                                );
                              }
                              return RotatedBox(
                                quarterTurns: 3,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: new LinearPercentIndicator(
                                    width: MediaQuery.of(context).size.height /
                                        4.9,
                                    lineHeight: 12.0,
                                    percent: percentage,
                                    center: Text(
                                      "${e.data()["steps"]} steps",
                                      style: new TextStyle(
                                        fontSize: 9.0,
                                        color: Colors.white,
                                        letterSpacing: 1.8,
                                      ),
                                    ),
                                    // trailing: Icon(Icons.mood),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    backgroundColor: Colors.grey,
                                    progressColor: _randomColor.randomColor(
                                        colorBrightness: ColorBrightness.dark),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(width: 0.0, height: 0.0);
                            }
                          }).toList(),
                        ),
                        //  ),
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("daily_activities")
                        //.orderBy("date")
                        .where("month",
                            isEqualTo:
                                SaveActivity().getMonth(DateTime.now().month))
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child:
                                SpinKitChasingDots(color: Colors.amber[700]));
                      }
                      return //Expanded(
                          SizedBox(
                        height: MediaQuery.of(context).size.height / 15,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs.map((e) {
                            if (e.id.split(" ")[1] == auth.currentUser.email) {
                              return Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text("${e.data()["day"]}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    )),
                              );
                            } else {
                              return SizedBox(width: 0.0, height: 0.0);
                            }
                          }).toList(),
                        ),
                        //  ),
                      );
                    },
                  ),
                ],
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 300,
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                color: Colors.white.withOpacity(0.1),
              ),
              alignment: Alignment.center,
              child: StreamBuilder<QuerySnapshot>(
                  stream: firebase.collection("saved_activities").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                          child: SpinKitFadingCircle(color: Colors.amber[700]));
                    }

                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: MediaQuery.of(context).size.height / 2.2,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data.docs.map((doc) {
                          return Card(
                              color: Color.fromRGBO(35, 36, 70, 1),
                              elevation: 9,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: firebase
                                          .collection("users")
                                          .doc(doc.data()["customer_id"])
                                          .collection("user_data")
                                          .doc("name")
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return SizedBox(width: 0.0);
                                        } else {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 12.0),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.0,
                                                horizontal: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text("${snapshot.data["name"]}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Text(
                                                    "${doc.data()["date"].toDate()}",
                                                    style: TextStyle(
                                                      color: Colors.amber[800],
                                                    ))
                                              ],
                                            ),
                                          );
                                        }
                                      }),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.0,
                                                vertical: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "AVG SPEED",
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            36,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                                Text(
                                                  (doc.data()["speed"] == null)
                                                      ? "0.00"
                                                      : "${doc.data()["speed"]}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            27,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.0,
                                                vertical: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "DISTANCE",
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            38,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                                Text(
                                                  (doc.data()["distance"] ==
                                                          null)
                                                      ? "0.00"
                                                      : "${double.parse(doc.data()["distance"]).floorToDouble()}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            27,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.0,
                                                vertical: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "TIME",
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            37,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                                Text(
                                                  "${doc.data()["time"]}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            28,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.0,
                                                vertical: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "CALARIES BURNT",
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            43,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                                Text(
                                                  "${double.parse(doc.data()["calories_burned"]).floorToDouble()}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            28,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        4.5,
                                    margin: EdgeInsets.all(10.0),
                                    child: Flexible(
                                      child: MapPage(
                                          originLat: doc.data()["origin_lat"],
                                          originLon: doc.data()["origin_lon"],
                                          destinLat: doc.data()["destin_lat"],
                                          destinLon: doc.data()["destin_lon"]),
                                    ),
                                  ),
                                ],
                              ));
                        }).toList(),
                      ),
                    );
                  })),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => StartWorkOrRun());
//                  AdScreenState().loadAd(StartWorkOrRun());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: 5.0,
                  ),
                  width: MediaQuery.of(context).size.width / 3.4,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/run.png",
                        /*width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 8,
                        fit: BoxFit.contain,*/
                      ),
                      Text("Running",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 26,
                            fontWeight: FontWeight.w700,
                          )),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[800],
                          borderRadius: BorderRadius.circular(
                            18.0,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 25,
                        alignment: Alignment.center,
                        child: Text("Start",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 28,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => HeartCalScreen());
                  // AdScreenState().loadAd(HeartCalScreen());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: 5.0,
                  ),
                  width: MediaQuery.of(context).size.width / 3.4,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/heart.png",
                        /*width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 8,
                        fit: BoxFit.contain,*/
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: firebase
                              .collection("users")
                              .doc(auth.currentUser.email)
                              .collection("heart_bpm")
                              .doc("heart_bpm")
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData || !snapshot.data.exists) {
                              return Text("Measure your bpm",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 32,
                                    fontWeight: FontWeight.w700,
                                  ));
                            }
                            return Text("${snapshot.data["heart_bpm"].floor()}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 26,
                                  fontWeight: FontWeight.w700,
                                ));
                          }),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[800],
                          borderRadius: BorderRadius.circular(
                            18.0,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 25,
                        alignment: Alignment.center,
                        child: Text("Start",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 28,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AddSleepScreen());
                  // AdScreenState().loadAd(AddSleepScreen());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: 5.0,
                  ),
                  width: MediaQuery.of(context).size.width / 3.6,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /* Image.asset(
                        "assets/yoga.png",
                        width: MediaQuery.of(context).size.width / 4.5,
                        height: MediaQuery.of(context).size.height / 12,
                        fit: BoxFit.contain,
                      ),*/
                      Icon(
                        FontAwesomeIcons.bed,
                        color: Colors.green[500],
                        size: MediaQuery.of(context).size.width / 9,
                      ),
                      Text("Sleeping",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 26,
                            fontWeight: FontWeight.w700,
                          )),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[800],
                          borderRadius: BorderRadius.circular(
                            18.0,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 25,
                        alignment: Alignment.center,
                        child: Text("Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 28,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => StartWorkOrRun());
                  // AdScreenState().loadAd(StartWorkOrRun());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: 5.0,
                  ),
                  width: MediaQuery.of(context).size.width / 3.4,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/walking.png",
                        /*width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 8,
                        fit: BoxFit.contain,*/
                      ),
                      Text("Walking",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 26,
                            fontWeight: FontWeight.w700,
                          )),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[800],
                          borderRadius: BorderRadius.circular(
                            18.0,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 25,
                        alignment: Alignment.center,
                        child: Text("Start",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 28,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AddFoodDetailsScreen());
                  // AdScreenState().loadAd(AddFoodDetailsScreen());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: 5.0,
                  ),
                  width: MediaQuery.of(context).size.width / 3.4,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/apple.png",
                        /*width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 8,
                        fit: BoxFit.contain,*/
                      ),
                      Text("Food",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 26,
                            fontWeight: FontWeight.w700,
                          )),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[800],
                          borderRadius: BorderRadius.circular(
                            18.0,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 25,
                        alignment: Alignment.center,
                        child: Text("Start",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 28,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AddWaterScreen());
                  //AdScreenState().loadAd(AddWaterScreen());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: 5.0,
                  ),
                  width: MediaQuery.of(context).size.width / 3.6,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/water.png",
                        /*width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 8,
                        fit: BoxFit.contain,*/
                      ),
                      Text("Water",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 26,
                            fontWeight: FontWeight.w700,
                          )),
                      Icon(Icons.add, color: Colors.amber[900])
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => WeightScreen());
                  //  AdScreenState().loadAd(WeightScreen());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: 5.0,
                  ),
                  width: MediaQuery.of(context).size.width / 3.4,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/weight.png",
                        /*width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 8,
                        fit: BoxFit.contain,*/
                      ),
                      Text("Weight",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 26,
                            fontWeight: FontWeight.w700,
                          )),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[800],
                          borderRadius: BorderRadius.circular(
                            18.0,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 25,
                        alignment: Alignment.center,
                        child: Text("Start",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 28,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => MyChallengesScreen());
                  //AdScreenState().loadAd(MyChallengesScreen());
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: 5.0,
                  ),
                  width: MediaQuery.of(context).size.width / 3.4,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        FontAwesomeIcons.hiking,
                        color: Colors.indigo[500],
                        size: 50.0,
                      ),
                      Text(
                        "Challenges",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.amber[800],
                          borderRadius: BorderRadius.circular(
                            18.0,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 3.8,
                        height: MediaQuery.of(context).size.height / 25,
                        alignment: Alignment.center,
                        child: Text("See",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 28,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              /*Container(
                //margin: EdgeInsets.only(right: 5.0),
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),*/
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 60,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white.withOpacity(0.1),
            ),
            child: StreamBuilder(
                stream: firebase
                    .collection("users")
                    .doc(auth.currentUser.email)
                    .collection("total_steps")
                    .doc("total_steps")
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitThreeBounce(
                        color: Colors.amber[700],
                      ),
                    );
                  }
                  print("s ${snapshot.data.exists} sd ${snapshot.data}");
                  if (!snapshot.data.exists ||
                      snapshot.data["total_steps"] == null) {
                    return Wrap(
                      children: [
                        Text(
                          "You haven't start your workout yet",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: MediaQuery.of(context).size.width / 30.0,
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.data["user_id"] == auth.currentUser.email) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 15.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Achievements",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.0,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  Text(
                                      DateFormat("dd/MM/yy")
                                          .format(DateTime.now()),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22.0,
                                      ))
                                ],
                              ),
                              SizedBox(width: 20.0),
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.heartbeat,
                                      color: Colors.pink[700]),
                                  SizedBox(width: 10.0),
                                  Text(
                                      "${snapshot.data["total_steps"] ~/ 300}/20 Points",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                29.0,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 9,
                                color: Color.fromRGBO(35, 36, 70, 1),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${snapshot.data["total_steps"]}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              22.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text("Avg Steps",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              26.0,
                                          //fontWeight: FontWeight.bold,
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: MediaQuery.of(context).size.height / 9,
                                color: Color.fromRGBO(35, 36, 70, 1),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        "${snapshot.data["total_steps"] * 2 / 1000}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              22.0,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text("Total Kilometers",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              26.0,
                                          //fontWeight: FontWeight.bold,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            (snapshot.data["total_steps"] ~/ 300 > 10)
                                ? "All are going good continue daily walking more than 60 min to maintain your health"
                                : "You must work hard and get atleast 10 points",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize:
                                  MediaQuery.of(context).size.width / 25.0,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(width: 0.0, height: 0.0);
                  }
                }),
          ),
          BannerAdScreen(),
          SizedBox(
            height: 15.0,
          ),
          BannerAdScreen(),
        ],
      ),
    );
  }
}
