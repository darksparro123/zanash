import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zaanassh/services/calculate_daily_calories.dart';
import 'package:zaanassh/services/cal_daily_water.dart';
import 'package:zaanassh/screens/drawe.dart';
import 'package:zaanassh/screens/friends_screen.dart';
import 'package:zaanassh/screens/profile_screen.dart';
import 'package:zaanassh/screens/set_goal_dialog.dart';
import 'package:zaanassh/screens/user_challenges.dart';
import 'package:zaanassh/screens/sleep.dart';

import 'ads/banner_ad.dart';

class UsScreen extends StatefulWidget {
  @override
  _UsScreenState createState() => _UsScreenState();
}

class _UsScreenState extends State<UsScreen> {
  int steps = 0;
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  TextEditingController step = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        drawer: DrawerClass().drawer(context),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(35, 36, 70, 1),
          title: Text(
            "Us",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle_outlined),
              onPressed: () {
                Get.to(() => ProfileScreen());
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => FriendsScreen());
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.amber[800],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.height / 25.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.group,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("user_data")
                                      .doc(FirebaseAuth
                                          .instance.currentUser.email)
                                      .collection("followers")
                                      .doc("followes")
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (!snapshot.hasData)
                                      return Center(
                                          child: SpinKitChasingDots(
                                        color: Colors.amber[600],
                                      ));
                                    return Text(
                                      (snapshot.data.exists)
                                          ? "${snapshot.data["followers"]}"
                                          : "Friends 0",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    );
                                  }),
                            ],
                          )),
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Get.to(() => UserChallengsScreen());
                      },
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.amber[800],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.height / 25.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "Challenges",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/create_account_background.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: firebase
                                .collection("challenge_results")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SpinKitFadingCube(
                                    color: Colors.amber[700],
                                  ),
                                );
                              }
                              var doc = snapshot.data.docs;
                              return SizedBox(
                                width: 50.0,
                                height: 10.0,
                                child: ListView.builder(
                                    itemCount: doc.length,
                                    itemBuilder: (context, index) {
                                      if (doc[index].id ==
                                          auth.currentUser.email) {
                                        return Text(
                                          "Your Rank : $index",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                          ),
                                        );
                                      } else {
                                        return SizedBox(
                                          width: 0,
                                        );
                                      }
                                    }),
                              );
                            }),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser.email)
                                .collection("total_steps")
                                .doc("total_steps")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData ||
                                  (!snapshot.data.exists) ||
                                  (snapshot.data["total_steps"] == null) ||
                                  (snapshot.data == null)) {
                                return Text(
                                  "You haven't started you walk yet",
                                  style: TextStyle(
                                    color: Colors.amber[800],
                                    fontSize:
                                        MediaQuery.of(context).size.width / 40,
                                  ),
                                );
                              }
                              return Text("");
                            }),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser.email)
                                .collection("total_steps")
                                .doc("total_steps")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  (!snapshot.data.exists) ||
                                  (snapshot.data["total_steps"] == null) ||
                                  (snapshot.data == null)) {
                                return Text(
                                  "You haven't started you walk yet",
                                  style: TextStyle(
                                    color: Colors.amber[800],
                                    fontSize:
                                        MediaQuery.of(context).size.width / 40,
                                  ),
                                );
                              }
                              return Text(
                                (snapshot.data["total_steps"] != null)
                                    ? "Total Steps : ${snapshot.data["total_steps"]}"
                                    : "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22,
                                ),
                              );
                            })
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 6),
                    Image.asset(
                      "assets/shoe.png",
                      width: MediaQuery.of(context).size.width / 10,
                      height: MediaQuery.of(context).size.width / 10,
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 30),
                Text(
                  "My Goals",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: Color.fromRGBO(35, 36, 70, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(35, 36, 70, 1),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 3,
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Activity Goals",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            25.0,
                                  ),
                                ),
                                StreamBuilder<DocumentSnapshot>(
                                  stream: firebase
                                      .collection("users")
                                      .doc(auth.currentUser.email)
                                      .collection("goals")
                                      .doc("step_goal")
                                      .snapshots(),
                                  //initialData: initialData ,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SpinKitDoubleBounce(
                                          color: Colors.amber[700],
                                        ),
                                      );
                                    }
                                    return (snapshot.data.exists)
                                        ? Container(
                                            child: RichText(
                                                text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${snapshot.data["step_goal"]}",
                                                  style: TextStyle(
                                                    color: Colors.amber[700],
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            25.0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "    steps",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            29.0,
                                                  ),
                                                ),
                                              ],
                                            )),
                                          )
                                        : MaterialButton(
                                            onPressed: () {
                                              SetGoalDialog()
                                                  .setGoalDialog(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.amber[700],
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              padding: EdgeInsets.all(6.0),
                                              child: Text(
                                                "Set a goal",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              alignment: Alignment.center,
                                            ));
                                  },
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.grey[600],
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  height: 1),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Weight Goals",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            25.0,
                                  ),
                                ),
                                StreamBuilder<DocumentSnapshot>(
                                  stream: firebase
                                      .collection("users")
                                      .doc(auth.currentUser.email)
                                      .collection("goals")
                                      .doc("weight_goal")
                                      .snapshots(),
                                  //initialData: initialData ,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SpinKitDoubleBounce(
                                          color: Colors.amber[700],
                                        ),
                                      );
                                    }
                                    return (snapshot.data.exists)
                                        ? Container(
                                            child: RichText(
                                                text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${snapshot.data["weight_goal"]}",
                                                  style: TextStyle(
                                                    color: Colors.amber[700],
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            25.0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "    kg",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            29.0,
                                                  ),
                                                ),
                                              ],
                                            )),
                                          )
                                        : MaterialButton(
                                            onPressed: () {
                                              SetGoalDialog()
                                                  .setWeightGoalDialog(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.amber[700],
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              padding: EdgeInsets.all(6.0),
                                              child: Text(
                                                "Set a goal",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25.0,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              alignment: Alignment.center,
                                            ));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CalDailyWaterUsage(),
                    SleepIndicator(),
                    CalCaloriesPercantage(),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                BannerAdScreen(),
                SizedBox(
                  height: 15.0,
                ),
                BannerAdScreen(),
              ],
            ),
          ),
        ));
  }
}
