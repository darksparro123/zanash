import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import 'package:zaanassh/screens/step_charts/step_chart_screen.dart';

class DailyRecordScreen extends StatefulWidget {
  final int year;
  final String month;
  final String docId;
  DailyRecordScreen({this.year, this.month, @required this.docId});
  @override
  _DailyRecordScreenState createState() => _DailyRecordScreenState();
}

class _DailyRecordScreenState extends State<DailyRecordScreen> {
  String shareText = "";
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

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

  int steps = 0;
  int hsteps = 0;
  int lsteps = 0;
  double tc = 0;
  //get share data
  Future<String> getShareData() async {
    int week = dayOfWeek() - 1;
    String docId = "week $week ${auth.currentUser.email}";
    print("Doc id is $docId");
    try {
      DocumentReference documentReference = firebase
          .collection("weekly_steps_summaries")
          .doc("$docId")
          .collection("steps")
          .doc("steps");
      firebase.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        print(snapshot.exists);
        if (snapshot.data() != null) {
          print("${snapshot.data()}");
          if (snapshot.data()["average_steps"] != null) {
            setState(() {
              steps = snapshot.data()["average_steps"];
            });
          }

          if (snapshot.data()["highest_steps"] != null) {
            setState(() {
              hsteps = snapshot.data()["highest_steps"];
            });
          }

          if (snapshot.data()["lowest_steps"] != null) {
            setState(() {
              lsteps = snapshot.data()["lowest_steps"];
            });
          }
        }
      });
      setState(() {
        shareText =
            "Hey there.I have walked $steps in this week.\nHighest steps count is $hsteps.\nLowest step count is $lsteps.\nAlso I burned total  $tc in this week.\nWant to do challenges with me.Join Zannash.\n${DateFormat("dd/MM/yy").format(DateTime.now())}";
      });
      print("share text is $shareText");
      return shareText;
    } catch (e) {
      return "Get Share data failed";
    }
  }

  _onShare(BuildContext context) async {
    print(shareText);
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(shareText,
        subject: "Daily Workout Summary in Zannash",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void initState() {
    //getShareData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        centerTitle: true,
        title: Text(
          "${DateFormat("MM-yy").format(DateTime.now())}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        shadowColor: Colors.white,
        actions: [
          Builder(
            builder: (BuildContext context) {
              return TextButton(
                onPressed: () {
                  getShareData();
                  _onShare(context);
                },
                child: Text(
                  "Share",
                  style: TextStyle(
                    color: Colors.amber[600],
                    letterSpacing: 1.0,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35.0,
          vertical: 12.0,
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("weekly_steps_summaries")
              .doc(widget.docId)
              .collection("steps")
              .doc("steps")
              .snapshots(),
          //initialData: initialData ,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            // print("snapshot is ${snapshot.data.data()}");
            return (!snapshot.hasData || snapshot.data.data() == null)
                ? Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/no_data.png"))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: Colors.grey[500],
                        child: SizedBox(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width / 1.1,
                        ),
                      ),
                      Text(
                        "Average Daily Steps",
                        style: TextStyle(
                          color: Colors.amber[600],
                          fontSize: MediaQuery.of(context).size.width / 28,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (snapshot.data.data()["average_steps"] != null)
                              ? Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(seconds: 4),
                                      width: MediaQuery.of(context).size.width /
                                          1.29,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              80,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(19.0),
                                      ),
                                    ),
                                    Container(
                                      width: ((MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.29) /
                                              42000) *
                                          snapshot.data.data()["average_steps"],
                                      height:
                                          MediaQuery.of(context).size.height /
                                              80,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[300],
                                        borderRadius:
                                            BorderRadius.circular(19.0),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 0.0,
                                ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            "${snapshot.data.data()["average_steps"]} Steps",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize:
                                    MediaQuery.of(context).size.height / 40),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.grey[500],
                        child: SizedBox(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width / 1.1,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5.0,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        //width: MediaQuery.of(context).size.width / 6.0,
                        //height: MediaQuery.of(context).size.height / 18,
                        child: Text(
                          "Average Global Performance",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("weekly_steps_summaries")
                                .doc(widget.docId)
                                .collection("steps")
                                .doc("steps")
                                .snapshots(),
                            //initialData: initialData ,
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data.data() == null) {
                                return Container(
                                    alignment: Alignment.center,
                                    child: Image.asset("assets/no_data.png"));
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Steps",
                                      style: TextStyle(
                                          color: Colors.amber[600],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30.0),
                                    ),
                                    CircularPercentIndicator(
                                      radius: 65.0,
                                      percent: snapshot.data
                                              .data()["average_steps"] /
                                          42000,
                                      //fillColor: Colors.grey[700],
                                      animation: true,
                                      animationDuration: 3,
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      progressColor: Colors.green,
                                      lineWidth: 8.0,
                                    ),
                                    Text(
                                      "${(snapshot.data.data()["average_steps"] / 4200 * 100).floorToDouble()} %",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              27.0),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("weekly_steps_summaries")
                                .doc(widget.docId)
                                .collection("steps")
                                .doc("steps")
                                .snapshots(),
                            //initialData: initialData ,
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data.data() == null) {
                                return Container(
                                    alignment: Alignment.center,
                                    child: Image.asset("assets/no_data.png"));
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Burned Calories",
                                      style: TextStyle(
                                          color: Colors.amber[600],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30.0),
                                    ),
                                    CircularPercentIndicator(
                                      radius: 65.0,
                                      percent: (double.parse(
                                                      snapshot.data.data()[
                                                          "total_calories"]) /
                                                  20000 >
                                              0)
                                          ? double.parse(snapshot.data
                                                  .data()["total_calories"]) /
                                              20000
                                          : 0,
                                      //fillColor: Colors.grey[700],
                                      animation: true,
                                      animationDuration: 3,
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      progressColor: Colors.lightBlue,
                                      lineWidth: 8.0,
                                    ),
                                    Text(
                                      "${(double.parse(snapshot.data.data()["total_calories"]) / 2000 * 100).floorToDouble()} %",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              27.0),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("weekly_summaries")
                                .doc(widget.docId)
                                .collection("sleep")
                                .doc("sleep")
                                .snapshots(),
                            //initialData: initialData ,
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data.data() == null) {
                                return Container(
                                    alignment: Alignment.center,
                                    child: Image.asset("assets/no_data.png"));
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sleep",
                                      style: TextStyle(
                                          color: Colors.amber[600],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30.0),
                                    ),
                                    CircularPercentIndicator(
                                      radius: 65.0,
                                      percent:
                                          (snapshot.data.data()["sleep_times"] /
                                                      42 >
                                                  0)
                                              ? snapshot.data
                                                      .data()["sleep_times"] /
                                                  42
                                              : 0,
                                      //fillColor: Colors.grey[700],
                                      animation: true,
                                      animationDuration: 3,
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      progressColor: Colors.red,
                                      lineWidth: 8.0,
                                    ),
                                    Text(
                                      "${(snapshot.data.data()["sleep_times"] / 42 * 100).floorToDouble()} %",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              27.0),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Activity Details:",
                            style: TextStyle(
                              color: Colors.amber[600],
                              fontSize: MediaQuery.of(context).size.width / 28,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            color: Colors.grey[500],
                            child: SizedBox(
                              height: 0.5,
                              width: MediaQuery.of(context).size.width / 1.1,
                            ),
                          ),
                          SizedBox(
                            height: 3.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Eat Healthier",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (snapshot.data.data()["total_calories"] != null)
                                ? "${double.parse(snapshot.data.data()["total_calories"]).floorToDouble()} Calories"
                                : "NO DATA",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.grey[500],
                        child: SizedBox(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width / 1.1,
                        ),
                      ),
                      Text(
                        "Steps",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: (snapshot.data.data()["least_steps"] != null)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Least ",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "-----------------------------------------",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${snapshot.data.data()["least_steps"]}",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(width: 0.0),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        child: (snapshot.data.data()["highest_steps"] != null)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Highest",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "-----------------------------------------",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "${snapshot.data.data()["highest_steps"]}",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(width: 0.0),
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15.0)),
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: MediaQuery.of(context).size.height / 3.0,
                        child: StepsChart(),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
