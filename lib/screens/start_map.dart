import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:zaanassh/screens/save_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:zaanassh/services/geo_locator_service.dart';

import 'cal_heart_from_sensor.dart';
import 'calculate_distances/calculate_distance.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:zaanassh/services/distance_calculator.dart';

import 'heart_rate/heart_rate.dart';

class StartWorkOrRun extends StatefulWidget {
  @override
  _StartWorkOrRunState createState() => _StartWorkOrRunState();
}

class _StartWorkOrRunState extends State<StartWorkOrRun> {
  GeolocatorService geolocatorService = GeolocatorService();
  bool isRoutes = true;
  bool s = false;
  double initialLatitude;
  double initialLongitude;
  Position position;
  bool isStarted = false;
  bool isStopped = false;
  bool isReset = false;
  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  List<LatLng> polyLineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  double totalDistance = 0.0;

  Future<Position> setLocation() async {
    position = await geolocatorService.getInitialLocation();
    Marker initialLocationMarker = new Marker(
      markerId: MarkerId("My Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(30.0),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
        title: "Your Initial Location",
        anchor: Offset(0.5, 0.0),
      ),
    );
    setState(() {
      markers.add(initialLocationMarker);
    });
    return position;
  }

  Future<bool> getPermisstion() async {
    //print("hapoi ${LocationPermission.location.value}");

    PermissionName permissionName = PermissionName.Location;
    Permission.requestPermissions([permissionName]);

    return true;
  }

  String buttonText = "START";
  String toggleButtonText() {
    if (!isStarted) {
      setState(() {
        buttonText = "START";
        isStarted = true;
      });
    }
    if (isStarted) {
      setState(() {
        buttonText = "FINISH";
        isStarted = false;
      });
    }
    return buttonText;
  }

  String stopTimetoDisplay;
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);
  Position sPosition;

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

  Future<Position> cPosition;
  double distance;
  double speed;
  String unit = "m";
  String timeUnit = "mps";
  Position streamPosition;

  Stream<Set<Marker>> setMarkers() async* {
    Position currentPosition = position;
    Set<Marker> updated = {};

    streamPosition = await Geolocator().getCurrentPosition();

    Marker latestLocationMarker = new Marker(
      markerId: MarkerId("My Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(30.0),
      position: LatLng(streamPosition.latitude, streamPosition.longitude),
      infoWindow: InfoWindow(
        title: "Your Current Location",
        anchor: Offset(0.5, 0.0),
      ),
    );

    Marker initialLocationMarker = new Marker(
      markerId: MarkerId("My Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(30.0),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
        title: "Your Initial Location",
        anchor: Offset(0.5, 0.0),
      ),
    );
    updated.add(initialLocationMarker);
    updated.add(latestLocationMarker);
    _createPolylines(position, streamPosition);
    print("P - $position");
    print("SP - $streamPosition");
    yield updated;
  }

  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyD-eOH7NucH1jBKFITkipHNErz6Pblb3KI",
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polyLineCoordinates,
      width: 3,
    );

    polylines[id] = polyline;

    totalDistance = 0.0;

    for (int i = 0; i < polyLineCoordinates.length; i++) {
      setState(() {
        totalDistance += coordinateDistance(
              polyLineCoordinates[i].latitude,
              polyLineCoordinates[i].longitude,
              polyLineCoordinates[i + 1].latitude,
              polyLineCoordinates[i + 1].longitude,
            ) *
            1000;
      });
    }

    if (totalDistance > 1000) {
      setState(() {
        unit = "km";
        totalDistance = totalDistance / 1000;
        timeUnit = "kmps";
      });
    }
  }

  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  int age = 0;
  double weight = 0;

  Stream<double> calculateCalories(int time) async* {
    double calories = 0.0;
    if (isStarted) {
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
        DocumentSnapshot weightSnapshot =
            await transaction.get(weightReference);

        age = DateTime.now().year -
            int.parse(ageSnapshot.data()["age"].toString().split("-")[0]);
        // print("Age is $age");
        weight = weightSnapshot.data()["weight"];
        // print("weight is $weight ");
        calories = (age * 0.074) -
            (weight * 0.05741) +
            (78 * 0.4472 - 20.4022) * time / 4.184;
      });
    }
    print("Calories is $calories");
    yield calories;
  }

  @override
  void dispose() {
    swatch.elapsed;

    super.dispose();
  }

  @override
  void initState() {
    getPermisstion();
    //setLocation();
    setState(() {
      stopTimetoDisplay = "00:00:00";
    });
    setState(() {
      cPosition = geolocatorService.getInitialLocation();
    });
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      body: ListView(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: FutureBuilder<Position>(
                future: setLocation(),
                builder: (context, AsyncSnapshot<Position> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitDualRing(
                        color: Colors.amber[700],
                      ),
                    );
                  }
                  // print(snapshot.data);
                  return StreamBuilder<Set<Marker>>(
                    stream: setMarkers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var _markers = snapshot.data;
                        return GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          markers: markers,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_markers.last.position.latitude,
                                _markers.last.position.longitude),
                            zoom: 15,
                          ),
                          polylines: Set<Polyline>.of(polylines.values),
                        );
                      } else {
                        return GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          markers: markers,
                          initialCameraPosition: CameraPosition(
                            target:
                                LatLng(position.latitude, position.longitude),
                            zoom: 15,
                          ),
                        );
                      }
                    },
                  );
                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(35, 36, 70, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.amber, offset: Offset(1200, 100))
                ]),
            child: (s)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  isRoutes = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[700],
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                width: MediaQuery.of(context).size.width / 4,
                                height:
                                    MediaQuery.of(context).size.height / 18.0,
                                alignment: Alignment.center,
                                child: Text("Routes",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.0,
                                    )),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                setState(() {
                                  isRoutes = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[700],
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                width: MediaQuery.of(context).size.width / 4,
                                height:
                                    MediaQuery.of(context).size.height / 18.0,
                                alignment: Alignment.center,
                                child: Text(
                                  "Heart Beat",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            22.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      (isRoutes)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "TIME",
                                    style: TextStyle(
                                        color: Colors.amber[700],
                                        letterSpacing: 2.0,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                22.0),
                                  ),
                                  stopWatch(),
                                  Container(
                                    color: Colors.grey[600],
                                    child: SizedBox(
                                      height: 2.0,
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "DISTANCE",
                                            style: TextStyle(
                                                color: Colors.amber[700],
                                                letterSpacing: 2.0,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    22.0),
                                          ),
                                          Text(
                                            "${totalDistance.toStringAsFixed(2)} $unit",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  18.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.grey[600],
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10.0,
                                          width: 3.0,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "AVG SPEED",
                                            style: TextStyle(
                                                color: Colors.amber[700],
                                                letterSpacing: 2.0,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    22.0),
                                          ),
                                          Text(
                                            "${(totalDistance / time).toStringAsFixed(2)} $timeUnit",
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  18.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        color: Colors.grey[600],
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10.0,
                                          width: 3.0,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "CALORIES",
                                            style: TextStyle(
                                                color: Colors.amber[700],
                                                letterSpacing: 2.0,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    22.0),
                                          ),
                                          StreamBuilder(
                                            stream:
                                                calculateCalories(time.round()),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  "${snapshot.data}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            18.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              } else {
                                                return SpinKitDualRing(
                                                  color: Colors.amber[700],
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    color: Colors.grey[600],
                                    child: SizedBox(
                                      height: 2.0,
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: isStarted
                                            ? startsStopWatch
                                            : stopsStopWatch,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              //borderRadius: BorderRadius.circular(15.0),
                                              color: Colors.amber[600]),
                                          child: Icon(
                                            (isStarted)
                                                ? Icons.play_arrow_sharp
                                                : Icons.stop,
                                            color: Colors.white,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                          ),
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          //print(GeolocationPermission.location.value);

                                          Get.to(() => SaveActivityScreen(
                                                speed: (totalDistance / time)
                                                    .toStringAsFixed(2),
                                                time: stopTimetoDisplay,
                                                currentPosition: streamPosition,
                                                cTime: time,
                                                initialPosition: position,
                                                showMap: true,
                                                distance:
                                                    "${totalDistance.toStringAsFixed(2)} $unit}",
                                              ));

                                          print(
                                              "Started $isStarted and $buttonText");
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.amber[700],
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.amber[700],
                                              width: 5.0,
                                            ),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // color: Colors.amber[700],
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    35, 36, 70, 1),
                                                width: 5.0,
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.amber[700],
                                                  shape: BoxShape.circle),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "FINISH",
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      35, 36, 70, 1),
                                                  letterSpacing: 1.5,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          22.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      MaterialButton(
                                        onPressed:
                                            isReset ? resetsStopWatch : null,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              8,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              8,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.restore_outlined,
                                            color: Colors.amber[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: HeartRateScreen(),
                            )
                    ],
                  )
                : MaterialButton(
                    onPressed: () {
                      //print(GeolocationPermission.location.value);
                      toggleButtonText();
                      startsStopWatch();
                      /*Get.to(() => (RecordScreen(
                              showMap: true,
                              initialPosition: Position(
                                latitude: position.latitude,
                                longitude: position.longitude,
                              ),
                            )));*/

                      setState(() {
                        s = true;
                      });
                      //Get.pa;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.amber[700],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.amber[700],
                          width: 5.0,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.amber[700],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color.fromRGBO(35, 36, 70, 1),
                            width: 5.0,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.amber[700], shape: BoxShape.circle),
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          alignment: Alignment.center,
                          child: Text(
                            "START",
                            style: TextStyle(
                              color: Color.fromRGBO(35, 36, 70, 1),
                              letterSpacing: 1.5,
                              fontSize:
                                  MediaQuery.of(context).size.width / 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
