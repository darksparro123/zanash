import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaanassh/models/sport_model.dart';

import 'package:zaanassh/screens/navigation_bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zaanassh/services/ads/ad_helper.dart';

import 'package:zaanassh/screens/start_runScreen.dart';
import 'package:zaanassh/services/calculate_calorieds.dart';
import 'package:zaanassh/services/save_activity.dart';

class SaveActivityScreen extends StatefulWidget {
  final String time;
  final double cTime;
  final String speed;
  final String distance;
  final Position initialPosition;
  final Position currentPosition;
  final bool showMap;
  SaveActivityScreen(
      {@required this.time,
      @required this.speed,
      @required this.distance,
      @required this.initialPosition,
      @required this.currentPosition,
      @required this.cTime,
      @required this.showMap});
  @override
  _SaveActivityScreenState createState() => _SaveActivityScreenState();
}

class _SaveActivityScreenState extends State<SaveActivityScreen> {
  TextEditingController titleController = TextEditingController();
  String sport = "";
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CalculateColories calculateColories = CalculateColories();
  InterstitialAd _interstitialAd;
  @override
  void initState() {
    _interstitialAd = InterstitialAd(
      request: AdRequest(),
      adUnitId: AddHelper.interstitialAdUnitId,
      listener: AdListener(onAdClosed: (ad) {
        print("Add closed");

        //
        Get.to(() => NavigationBarScreen());
      }, onAdOpened: (ad) {
        print("Add opened");
      }, onAdFailedToLoad: (ad, error) {
        print("Ad load falied $error");
      }),
    );
    _interstitialAd.load();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  double calories = 0.0;
  final formKey = GlobalKey<FormState>();
  Future<double> calculateCalories(int time) async {
    DocumentReference ageReference = firebase
        .collection("users")
        .doc(auth.currentUser.email)
        .collection("user_data")
        .doc("age");

    DocumentReference weightReference = firebase
        .collection("users")
        .doc(auth.currentUser.email)
        .collection("weight")
        .doc("weight");
    firebase.runTransaction((transaction) async {
      DocumentSnapshot ageSnapshot = await transaction.get(ageReference);
      DocumentSnapshot weightSnapshot = await transaction.get(weightReference);
      setState(() {
        int age = DateTime.now().year -
            int.parse(ageSnapshot.data()["age"].toString().split("-")[0]);
        // print("Age is $age");
        double weight = weightSnapshot.data()["weight"];
        // print("weight is $weight ");
        calories = (age * 0.074) -
            (weight * 0.05741) +
            (78 * 0.4472 - 20.4022) * time / 4.184;
      });
    });
    //   print("Calories is $calories");
    return calories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        centerTitle: true,
        title: Text(
          "Save Activity",
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width / 22,
            letterSpacing: 1.0,
          ),
        ),
        /* actions: [
          TextButton(
            onPressed: () {
              Get.to(() => RecordScreen(
                    time: widget.time,
                    initialPosition: widget.currentPosition,
                  ));
            },
            child: Text(
              "Resume",
              style: TextStyle(
                color: Colors.amber,
              ),
            ),
          ),
        ],*/
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5.0),
        child: ListView(
          children: [
            (widget.showMap &&
                    widget.initialPosition != null &&
                    widget.currentPosition != null)
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                    color: Colors.white.withOpacity(0.2),
                    child: MapPage(
                      originLat: widget.initialPosition.latitude,
                      originLon: widget.initialPosition.longitude,
                      destinLat: widget.currentPosition.latitude,
                      destinLon: widget.currentPosition.longitude,
                    ))
                : SizedBox(width: 0.0, height: 0.0),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 10,
              color: Colors.white.withOpacity(0.1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AVG SPEED",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: MediaQuery.of(context).size.width / 36,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          (widget.speed == null)
                              ? "0.00"
                              : "${double.parse(widget.speed).floorToDouble()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 27,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DISTANCE",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: MediaQuery.of(context).size.width / 38,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          (widget.distance == null)
                              ? "0.00"
                              : "${widget.distance.toString().substring(0, 3)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 27,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TIME",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: MediaQuery.of(context).size.width / 37,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          "${widget.time}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 28,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CALARIES BURNED",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: MediaQuery.of(context).size.width / 43,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: FutureBuilder(
                              future: calculateCalories(widget.cTime.toInt()),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return Center(
                                      child: SpinKitChasingDots(
                                          color: Colors.amber[700]));
                                }
                                // print("data is ${snapshot.data}");
                                return Text(
                                  "${((snapshot.data) / 100).toString().substring(0, 3)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 28,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "CUSTOMIZE YOUR RIDE",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontSize: MediaQuery.of(context).size.width / 25,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.1,
              color: Colors.white.withOpacity(0.2),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "NAME :",
                            style: TextStyle(
                              color: Colors.amber,
                              letterSpacing: 2.0,
                              fontSize: MediaQuery.of(context).size.width / 25,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (val) => val.isEmpty
                                  ? "Plese give a name to your activity"
                                  : null,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                              controller: titleController,
                              decoration: InputDecoration(
                                  labelText: "Title Your Activity",
                                  labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    letterSpacing: 1.0,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 32,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              FontAwesomeIcons.upload,
                              color: Colors.amber,
                              size: MediaQuery.of(context).size.width / 10,
                            ),
                            TextButton(
                              child: Text(
                                "Upload Photo",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  letterSpacing: 1.0,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 32,
                                ),
                              ),
                              onPressed: () {
                                ImagePicker()
                                    .getImage(source: ImageSource.gallery);
                              },
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey[500],
                        child: SizedBox(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width / 1.1,
                        ),
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              "SPORT :",
                              style: TextStyle(
                                color: Colors.amber,
                                letterSpacing: 2.0,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          (sport == "")
                              ? TextButton(
                                  onPressed: () {
                                    Sports sports = Sports();
                                    Get.dialog(Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(19, 20, 41, 1),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: sports.sportList.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                color: Colors.grey[500],
                                                child: SizedBox(
                                                  height: 0.5,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.1,
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    sport =
                                                        sports.sportList[index]
                                                            ["sport"];
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                hoverColor: Colors.grey[500],
                                                leading: sports.sportList[index]
                                                    ["icon"],
                                                title: Text(
                                                  "${sports.sportList[index]["sport"]}",
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            25,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ));
                                  },
                                  child: Text(
                                    "SELECT",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      letterSpacing: 1.0,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              32,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    sport,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      letterSpacing: 1.0,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              32,
                                    ),
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
                      Container(
                        color: Colors.grey[500],
                        child: SizedBox(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width / 1.1,
                        ),
                      ),
                      /*Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              "TYPE :",
                              style: TextStyle(
                                color: Colors.amber,
                                letterSpacing: 2.0,
                                fontSize: MediaQuery.of(context).size.width / 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "SELECT",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                letterSpacing: 1.0,
                                fontSize: MediaQuery.of(context).size.width / 32,
                              ),
                            ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "DESCRIPTION :",
                            style: TextStyle(
                              color: Colors.amber,
                              letterSpacing: 2.0,
                              fontSize: MediaQuery.of(context).size.width / 25,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 24,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                              ),
                              controller: descriptionController,
                              decoration: InputDecoration(
                                  labelText: "write about the activity",
                                  labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    letterSpacing: 1.0,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 32,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: MaterialButton(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 18.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.amber[600],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Save Avtivity",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 20.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    bool a = await SaveActivity().saveUserActivity(
                      titleController.text,
                      sport,
                      "Fast",
                      descriptionController.text,
                      widget.speed.toString(),
                      widget.distance.toString(),
                      widget.time.toString(),
                      calories.toString(),
                      widget.initialPosition.latitude,
                      widget.initialPosition.longitude,
                      widget.currentPosition.latitude,
                      widget.currentPosition.longitude,
                    );
                    if (a) {
                      Get.snackbar(
                          "Save Activity", "Activity Saved Succesfully");
                      _interstitialAd.show();
                    } else {
                      Get.snackbar("Save Activity", "Activity Saving failed");
                    }
                  }

                  // SaveActivity().savetoweeeklySummaries(150.0, "15.0");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
