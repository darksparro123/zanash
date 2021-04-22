import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
import 'package:zaanassh/screens/record_screen.dart';
import 'package:zaanassh/services/geo_locator_service.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'calculate_distances/calculate_distance.dart';
import 'package:http/http.dart' as http;

class StartWorkOrRun extends StatefulWidget {
  @override
  _StartWorkOrRunState createState() => _StartWorkOrRunState();
}

class _StartWorkOrRunState extends State<StartWorkOrRun> {
  GeolocatorService geolocatorService = GeolocatorService();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  double initialLatitude;
  double initialLongitude;
  Position position;
  bool isStarted = false;
  bool isStopped = false;
  bool isReset = false;
  Set<Marker> markers = {};
  Future<Position> setLocation() async {
    position = await geolocatorService.getInitialLocation();
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("My Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(30.0),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: "Your Current Location",
            anchor: Offset(0.5, 0.0),
          )));
    });
    return position;
  }

  Future<bool> getPermisstion() async {
    print("hapoi ${GeolocationPermission.location.value}");

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
  Position streamPosition;
  double distance;
  String unit;
  Future<double> setSpeed() async {
    Position currentPosition = await cPosition;

    geolocatorService.getCurruntLocation().listen((Position p) {
      streamPosition = p;
    });

    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${currentPosition.latitude},${currentPosition.longitude}&destinations=${streamPosition.latitude},${streamPosition.longitude}&key=AIzaSyBInYMrODKeADbONhwaJ6-SqawifKDnzew";

    var response = await http.post(Uri.parse(url));
    //print(response.statusCode);
    if (response.statusCode == 200) {
      String re = response.body;
      Map<String, dynamic> distanceData = jsonDecode(re);
      // print("${distanceData["rows"][0]["elements"][0]["distance"]["text"]} ");
      distance = double.parse(distanceData["rows"][0]["elements"][0]["distance"]
              ["text"]
          .split(" ")[0]);
      unit = distanceData["rows"][0]["elements"][0]["distance"]["text"]
          .split(" ")[1];
    }
    // print("distance : $distance");

    return distance / time;
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
            height: MediaQuery.of(context).size.height * 0.5,
            child: FutureBuilder<Position>(
                future: setLocation(),
                builder: (context, AsyncSnapshot<Position> snapshot) {
                  if (!snapshot.hasData) {
                    print("snapshot.hasData");
                    return Center(
                      child: SpinKitDualRing(
                        color: Colors.amber[700],
                      ),
                    );
                  }
                  // print(snapshot.data);
                  return GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    markers: markers,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          snapshot.data.latitude, snapshot.data.longitude),
                      zoom: 15,
                    ),
                  );
                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TIME",
                    style: TextStyle(
                        color: Colors.amber[700],
                        letterSpacing: 2.0,
                        fontSize: MediaQuery.of(context).size.width / 22.0)),
                stopWatch(),
                Container(
                  color: Colors.grey[600],
                  child: SizedBox(
                    height: 2.0,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CalculateDistance(),
                    Container(
                        color: Colors.grey[600],
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 10.0,
                          width: 3.0,
                        )),
                    FutureBuilder<double>(
                        future: setSpeed(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SpinKitChasingDots(color: Colors.amber),
                            );
                          }
                          var speed = snapshot.data.floorToDouble();
                          return (!isStarted)
                              ? Column(
                                  children: [
                                    Text("AVG.SPEED",
                                        style: TextStyle(
                                            color: Colors.amber[700],
                                            letterSpacing: 2.0,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22.0)),
                                    Text(
                                      "${snapshot.data.floorToDouble()} ${unit}ps",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                6.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text("AVG.SPEED",
                                        style: TextStyle(
                                            color: Colors.amber[700],
                                            letterSpacing: 2.0,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                22.0)),
                                    Text(
                                      "$speed",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                6.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                        })
                  ],
                ),
                Container(
                  color: Colors.grey[600],
                  child: SizedBox(
                    height: 2.0,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
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
                            color: Colors.amber[600]),
                        child: Icon(
                          (isStarted) ? Icons.play_arrow_sharp : Icons.stop,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 8,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        //print(GeolocationPermission.location.value);
                        toggleButtonText();
                        /*Get.to(() => (RecordScreen(
                              showMap: true,
                              initialPosition: Position(
                                latitude: position.latitude,
                                longitude: position.longitude,
                              ),
                            )));*/

                        print("Started $isStarted and $buttonText");
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
                                color: Colors.amber[700],
                                shape: BoxShape.circle),
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            alignment: Alignment.center,
                            child: Text(
                              "$buttonText",
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
                          color: Colors.amber[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
