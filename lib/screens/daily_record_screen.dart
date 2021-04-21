import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';

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
  //get share data
  Future<String> getShareData() async {
    try {
      await FirebaseFirestore.instance
          .collection("weekly_summaries")
          .doc(widget.docId)
          .get()
          .then((value) {
        setState(() {
          shareText = "Hey checkout my workout in Zaanassh\n" +
              "Daily active mins : " +
              //value.data()["average_daily_active_mins"] +
              ".\nDaily average steps " +
              value.data()["average_steps"] +
              ".\nAte calories" +
              value.data()["total_calories"];
        });
      });
      return "Fet data sucsussfully";
    } catch (e) {
      return "Get Share data failed";
    }
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(shareText,
        subject: "Daily Workout Summary in Zaanassh",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void initState() {
    getShareData();
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
          (widget.month == null) ? "" : "${widget.month}-${widget.year}",
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
                  _onShare(context);
                },
                child: Text(
                  "Share",
                  style: TextStyle(
                    color: Colors.orange[600],
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
              .collection("weekly_summaries")
              .doc(widget.docId)
              .collection("steps")
              .doc("steps")
              .snapshots(),
          //initialData: initialData ,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            //print("snapshot is ${snapshot.data.data()}");
            return (!snapshot.hasData || snapshot.data.data() == null)
                ? Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/no_data.png"))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /* Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5.0,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        //width: MediaQuery.of(context).size.width / 6.0,
                        //height: MediaQuery.of(context).size.height / 18,
                        child: Text(
                          "Group Comparsion",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "Group : ",
                          style: TextStyle(
                            color: Colors.orange[600],
                            fontSize: MediaQuery.of(context).size.width / 28,
                          ),
                        ),
                        TextSpan(
                            text: (snapshot.data.data()["group_name"] == null)
                                ? "You haven't joined to a group"
                                : snapshot.data.data()["group_name"])
                      ])),*/
                      /*Container(
                        color: Colors.grey[500],
                        child: SizedBox(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width / 1.1,
                        ),
                      ),
                      Text(
                        "Average Daily Active Mins",
                        style: TextStyle(
                          color: Colors.orange[600],
                          fontSize: MediaQuery.of(context).size.width / 28,
                        ),
                      ),*/
                      /*  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.29,
                                height: MediaQuery.of(context).size.height / 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(19.0),
                                ),
                              ),
                            AnimatedContainer(
                                duration: Duration(seconds: 5),
                                width: ((MediaQuery.of(context).size.width /
                                            1.29) /
                                        1500) *
                                    int.parse(snapshot
                                        .data["average_daily_active_mins"]),
                                height: MediaQuery.of(context).size.height / 80,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(19.0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                         Text(
                            "${snapshot.data.data()["average_daily_active_mins"]} Mins",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize:
                                    MediaQuery.of(context).size.height / 40),
                          ),
                        ],
                      ),*/
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
                          color: Colors.orange[600],
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
                                              6000) *
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
                                .collection("weekly_summaries")
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
                                          color: Colors.orange[600],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30.0),
                                    ),
                                    CircularPercentIndicator(
                                      radius: 65.0,
                                      percent: (snapshot.data
                                                  .data()["average_steps"] /
                                              42000) *
                                          10,
                                      //fillColor: Colors.grey[700],
                                      animation: true,
                                      animationDuration: 3,
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      progressColor: Colors.red,
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
                                .collection("weekly_summaries")
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
                                          color: Colors.orange[600],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30.0),
                                    ),
                                    CircularPercentIndicator(
                                      radius: 65.0,
                                      percent: (double.parse(snapshot.data
                                                  .data()["total_calories"]) /
                                              20000) *
                                          100,
                                      //fillColor: Colors.grey[700],
                                      animation: true,
                                      animationDuration: 3,
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      progressColor: Colors.red,
                                      lineWidth: 8.0,
                                    ),
                                    Text(
                                      "${(double.parse(snapshot.data.data()["total_calories"]) / 2000 * 1000).floorToDouble()} %",
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
                                          color: Colors.orange[600],
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30.0),
                                    ),
                                    CircularPercentIndicator(
                                      radius: 65.0,
                                      percent:
                                          (snapshot.data.data()["sleep_times"] /
                                              42),
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
                              color: Colors.orange[600],
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
                                ? "${(snapshot.data.data()["total_calories"]).substring(0, 5)} Calories"
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
                    ],
                  );
          },
        ),
      ),
    );
  }
}
