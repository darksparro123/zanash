import 'dart:async';
import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:zaanassh/services/calculate_service.dart';
import 'package:zaanassh/screens/drawe.dart';
import 'package:zaanassh/screens/save_activity.dart';
import 'package:zaanassh/services/geo_locator_service.dart';
import 'package:http/http.dart' as http;

class RecordScreen extends StatefulWidget {
  final Position initialPosition;
  final String time;
  final String speed;
  final String distance;
  final bool showMap;
  RecordScreen(
      {this.time,
      this.speed,
      this.distance,
      @required this.initialPosition,
      @required this.showMap});
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  bool isStarted = true;
  bool isReset = true;
  bool isStopped = true;
  Position initPosition;
  String stopTimetoDisplay;
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);
  Position sPosition;

  GeolocatorService geolocatorService = GeolocatorService();
  Geolocator geolocator = Geolocator();
  double time = 1.000000;
//calculate distance

  void startTimer() {
    Timer(
      dur,
      keepRunning,
    );
  }

  void keepRunning() {
    if (swatch.isRunning) {
      startTimer();
      setState(() {
        stopTimetoDisplay = swatch.elapsed.inHours.toString().padLeft(2, "0") +
            ":" +
            (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
        time++;
      });
    }
  }

  void startsStopWatch() {
    setState(() {
      // isStopped = false;
      isStarted = false;
    });
    swatch.start();
    startTimer();
  }

  void stopsStopWatch() {
    setState(() {
      isStopped = false;
      isStarted = true;
      isReset = true;
    });
    swatch.stop();
  }

  void resetsStopWatch() {
    setState(() {
      isStarted = true;
      isReset = false;
      isStopped = true;
      stopTimetoDisplay = "00:00:00";
      time = 1;
      // distance = 0.0;
      // speed = 0.0;
    });
    swatch.reset();
  }

  @override
  void dispose() {
    swatch.elapsed;

    super.dispose();
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();

    setState(() {
      stopTimetoDisplay = (widget.time == null) ? "00:00:00" : widget.time;
    });
  }

  Widget stopWatch() {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(
              stopTimetoDisplay,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 6.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //get currentLocation
  Future getCurrentLocation() async {
    var initPos = await geolocator.getCurrentPosition();
    initPosition = initPos;
  }

  Position lastPosition;
  double distance = 0.0;
  String unit = "m";
  int count = 0;
  String avgSpeed = "0";
  Stream<double> getDistance(Position streamPosition) async* {
    sPosition = streamPosition;
    try {
      /*Position initLocation = initPosition;

      //print(streamLocation.distinct());
      String url =
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${initLocation.latitude},${initLocation.longitude}&destinations=${streamPosition.latitude},${streamPosition.longitude}&key=AIzaSyBInYMrODKeADbONhwaJ6-SqawifKDnzew";

      var response = await http.post(Uri.parse(url));
      //print(response.statusCode);
      if (response.statusCode == 200) {
        String re = response.body;
        Map<String, dynamic> distanceData = jsonDecode(re);
        // print("${distanceData["rows"][0]["elements"][0]["distance"]["text"]} ");
        distance = double.parse(distanceData["rows"][0]["elements"][0]
                ["distance"]["text"]
            .split(" ")[0]);
        unit = distanceData["rows"][0]["elements"][0]["distance"]["text"]
            .split(" ")[1];
      }*/
      print("lastPos: $lastPosition");
      Future.delayed(Duration(milliseconds: 150), () async {
        var p2pdistance = await geolocator.distanceBetween(
            lastPosition.latitude,
            lastPosition.longitude,
            streamPosition.latitude,
            streamPosition.longitude);
        var tmp = p2pdistance.toStringAsFixed(3);
        p2pdistance = double.parse(tmp);
        print("p2pDistance: $p2pdistance");
        distance += p2pdistance;
        if (distance >= 1000) {
          distance = distance / 1000;
          unit = "km";
        }
        avgSpeed = (distance / time).toStringAsFixed(2);
      });
      yield distance;
    } catch (e) {
      yield 0.0;
    }
    count++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerClass().drawer(context),
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "ZAA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width / 22,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: "NASSH",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: MediaQuery.of(context).size.width / 22,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        //shadowColor: Colors.white.withOpacity(0.1),
        actions: [
          TextButton(
            onPressed: () async {
              Get.to(() => SaveActivityScreen(
                    speed: (distance ~/ time).toString(),
                    time: stopTimetoDisplay,
                    distance: distance.toString(),
                    initialPosition: widget.initialPosition,
                    cTime: time,
                    showMap: widget.showMap,
                    currentPosition: sPosition,
                  ));
            },
            child: Text(
              "Save Activity",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width / 36,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "TIME",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[600],
                    letterSpacing: 1.5,
                    fontSize: MediaQuery.of(context).size.width / 25,
                  ),
                ),
              ],
            ),
            stopWatch(),
            Container(
              color: Colors.grey[500],
              child: SizedBox(
                height: 0.5,
                width: MediaQuery.of(context).size.width / 1.1,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "AVG SPEED (s)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[600],
                    letterSpacing: 1.5,
                    fontSize: MediaQuery.of(context).size.width / 25,
                  ),
                ),
              ],
            ),
            Container(
              child: Text(
                "$avgSpeed ps",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 6.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "DISTANCE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.orange[600],
                    letterSpacing: 1.5,
                    fontSize: MediaQuery.of(context).size.width / 25,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder(
              stream: geolocatorService.getCurruntLocation(),
              builder: (context, AsyncSnapshot<Position> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: SpinKitChasingDots(
                      color: Colors.orange[700],
                    ),
                  );
                }
                if (lastPosition == null) {
                  lastPosition = initPosition;
                } else {
                  lastPosition = snapshot.data;
                }
                print("CurrentPos: ${snapshot.data}");
                return StreamBuilder(
                  stream: getDistance(snapshot.data),
                  // initialData: initialData ,
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot2) {
                    if (!snapshot2.hasData || snapshot2.data == null) {
                      return Center(
                          child: SpinKitChasingDots(color: Colors.orange[700]));
                    }
                    print("distance: ${snapshot2.data}");
                    return Container(
                        child: Text(
                      "${snapshot2.data} $unit",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 6.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ));
                  },
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: isStarted ? startsStopWatch : stopsStopWatch,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.width / 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //borderRadius: BorderRadius.circular(15.0),
                        color: Colors.orange[600]),
                    child: Icon(
                      (isStarted) ? Icons.play_arrow_sharp : Icons.stop,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width / 8,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                MaterialButton(
                  onPressed: isReset ? resetsStopWatch : null,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 8,
                    height: MediaQuery.of(context).size.width / 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restore_outlined,
                      color: Colors.orange[600],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
