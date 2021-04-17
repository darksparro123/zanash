import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:http/http.dart" as http;
import 'package:zaanassh/screens/start_runScreen.dart';
import 'package:zaanassh/services/save_challenge_result.dart';

class StartWalkScreen extends StatefulWidget {
  final String challengeId;
  StartWalkScreen({@required this.challengeId});
  @override
  _StartWalkScreenState createState() => _StartWalkScreenState();
}

class _StartWalkScreenState extends State<StartWalkScreen> {
  final geo = Geolocator();
  TextEditingController destinationText = TextEditingController();
  GoogleMapController mapController;
  Set<Marker> destinationMark = {};
  Position d;
  bool clicked = false;
  String unit = "";
  final _formKey = GlobalKey<FormState>();
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  bool isStarted = true;
  bool isReset = true;
  bool isStopped = true;

  String stopTimetoDisplay = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);
  Completer<GoogleMapController> _googleMapController = Completer();
  Future<void> centerPostion(Position position) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            zoom: 16.0, target: LatLng(position.latitude, position.longitude)),
      ),
    );
  }

//time processing methods
  void startTimer() {
    Timer(
      dur,
      keepRunning,
    );
    setInitialPosition();
  }

  void setInitialPosition() async {
    streamPosition = await geo.getCurrentPosition();
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
        //time++;
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
      //isStarted = false;
      isReset = false;
      isStopped = true;
      stopTimetoDisplay = "00:00:00";
      //time = 1;
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

  // find destination
  Future<Position> getDestination(String destination) async {
    try {
      List<Placemark> placeMark = await geo.placemarkFromAddress(destination);
      Placemark dest = placeMark[0];
      Position destinationPosition = dest.position;
      setState(() {
        destinationMark.add(
          Marker(
              markerId: MarkerId("Destination"),
              position: LatLng(
                destinationPosition.latitude,
                destinationPosition.longitude,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(30.0),
              infoWindow: InfoWindow(
                title: "Your Destionation",
                anchor: Offset(0.5, 0.0),
              )),
        );
      });
      return destinationPosition;
    } catch (e) {
      print("Get location failes $e");
      return null;
    }
  }

  double distance = 0.0;
  Future<double> getDestinationDistance(Position destinationPosition) async {
    try {
      Position currentLocation = await geo.getCurrentPosition();
      String url =
          "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${currentLocation.latitude},${currentLocation.longitude}&destinations=${destinationPosition.latitude},${destinationPosition.longitude}&key=AIzaSyBInYMrODKeADbONhwaJ6-SqawifKDnzew";

      var response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        String re = response.body;
        Map<String, dynamic> distanceData = jsonDecode(re);
        // print("${distanceData["rows"][0]["elements"][0]["distance"]["text"]} ");
        distance = double.parse(distanceData["rows"][0]["elements"][0]
                ["distance"]["text"]
            .split(" ")[0]);
        unit = distanceData["rows"][0]["elements"][0]["distance"]["text"]
            .split(" ")[1];
        //print(distanceData);
      }

      return distance;
    } catch (e) {
      print("Get destination destance failed $e");
      return null;
    }
  }

  void mapTap(LatLng latLng) {
    setState(() {
      destinationMark.add(
        Marker(
          markerId: MarkerId("Destination Point"),
          position: latLng,
          infoWindow: InfoWindow(
            title: "Destination Point",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(30.0),
        ),
      );
    });
    _getPolyline(
        Position(latitude: latLng.latitude, longitude: latLng.longitude));
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
      color: Colors.orange[700],
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline(Position destinationPosition) async {
    List<LatLng> polylineCoordinates = [];
    Position curruntPosition = await geo.getCurrentPosition();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBInYMrODKeADbONhwaJ6-SqawifKDnzew",
      PointLatLng(curruntPosition.latitude, curruntPosition.longitude),
      PointLatLng(destinationPosition.latitude, destinationPosition.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(
          point.latitude,
          point.longitude,
        ));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  Position streamPosition;
  //calculate walking distance
  Future<int> calculateWalkingDistance(Position inPos) async {
    Position inititalPosition = await geo.getCurrentPosition();

    double x1 = inititalPosition.latitude;
    double x2 = streamPosition.latitude;

    double y1 = inititalPosition.longitude;
    double y2 = streamPosition.longitude;

    double distance = sqrt((x1 - x2) * (x1 - x2) + (y2 - y1) * (y2 - y1));
    //print("distance is $distance");
    double previousD = 0.0;
    if (previousD < distance) {
      previousD = distance;
      int steps = previousD ~/ 2;

      return steps;
    } else {
      int steps = previousD ~/ 2;

      return steps;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.4,
              child: Stack(
                children: [
                  FutureBuilder<Position>(
                      future: geo.getCurrentPosition(),
                      builder: (context, AsyncSnapshot<Position> snapshot) {
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Center(
                              child: SpinKitFadingCircle(
                            color: Colors.amber[800],
                          ));
                        }
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return GoogleMap(
                          mapType: MapType.normal,
                          polylines: Set<Polyline>.of(polylines.values),
                          onTap: (LatLng p) {
                            setState(() {
                              destinationMark = {};
                              clicked = true;
                              d = Position(
                                  latitude: p.latitude, longitude: p.longitude);
                            });
                            mapTap(p);
                          },
                          initialCameraPosition: CameraPosition(
                              target: LatLng(snapshot.data.latitude,
                                  snapshot.data.longitude),
                              zoom: 15.0),
                          myLocationEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                            _googleMapController.complete(controller);
                          },
                          markers: destinationMark,
                        );
                      }),
                  (!clicked)
                      ? Positioned(
                          top: 100.0,
                          left: MediaQuery.of(context).size.width / 6,
                          child: Form(
                            key: _formKey,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextFormField(
                                style: TextStyle(
                                  color: Colors.amber[800],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 18,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Colors.amber[800],
                                      width: 3.0,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Colors.amber[800],
                                      width: 3.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                      color: Colors.amber[800],
                                      width: 3.0,
                                    ),
                                  ),
                                  labelText: "Destination Point",
                                  labelStyle: TextStyle(
                                    color: Colors.amber[800],
                                    fontSize:
                                        MediaQuery.of(context).size.width / 18,
                                  ),
                                ),
                                controller: destinationText,
                                validator: (val) => val.isEmpty
                                    ? "Plese enter destination place"
                                    : null,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(width: 0.0),
                  (!clicked)
                      ? Positioned(
                          top: 200.0,
                          left: MediaQuery.of(context).size.width / 2.5,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                Position de =
                                    await getDestination(destinationText.text);
                                print(de);
                                if (de != null) {
                                  setState(() {
                                    clicked = true;
                                    d = de;
                                    _getPolyline(d);
                                  });
                                }
                              }
                            },
                            child: Text(
                              "Start Walk",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.amber[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                18.0,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 0.0,
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            (!clicked)
                ? Text(
                    "Set your destination point with typing or tap the destination point in the map",
                    style: TextStyle(
                      color: Colors.amber[800],
                      fontSize: MediaQuery.of(context).size.width / 19.0,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  )
                : FutureBuilder<double>(
                    future: getDestinationDistance(d),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Text("Calculating distance",
                            style: TextStyle(
                              color: Colors.white,
                            ));
                      }
                      return Text(
                        "Distance ${snapshot.data * 1000 * 3} $unit",
                        style: TextStyle(
                          color: Colors.amber[800],
                          fontSize: MediaQuery.of(context).size.width / 19.0,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }),
            SizedBox(
              height: 20.0,
            ),
            stopWatch(),

            /*Row(
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
                  height: 20.0,
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
            ),*/
            SizedBox(
              height: 20.0,
            ),
            /*  FutureBuilder<int>(
              future: calculateWalkingDistance(),
              builder: (context, AsyncSnapshot<int> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                      child: SpinKitFadingCircle(
                    color: Colors.amber[800],
                  ));
                }
                // print(snapshot.data);
                return Text(
                  "Steps ${snapshot.data}",
                  style: TextStyle(
                    color: Colors.amber[800],
                    fontSize: MediaQuery.of(context).size.width / 19.0,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),*/
            SizedBox(
              height: 50.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () async {
                    //print(distance * 1000 * 3);
                    if (isStarted) {
                      int a = await calculateWalkingDistance(streamPosition);
                      //   print(a);
                      Get.dialog(
                        Dialog(
                          backgroundColor: Color.fromRGBO(35, 36, 70, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            height: MediaQuery.of(context).size.height / 3.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(18.0),
                                  margin: EdgeInsets.all(9.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Text(
                                    "You walked ${(a * 1000 / 3 / 6).floor()} steps.Do you want to save it as your challenge result",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.0,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          bool b = await SaveChallengeResult()
                                              .saveChallengeResult(
                                                  a, widget.challengeId);
                                          if (b) {
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                            color: Colors.orange[600],
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                            color: Colors.orange[900],
                                          ),
                                        ),
                                      ),
                                    ])
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    width: MediaQuery.of(context).size.width / 4.2,
                    height: MediaQuery.of(context).size.height / 22.0,
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 23.0,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: isReset ? resetsStopWatch : null,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    width: MediaQuery.of(context).size.width / 4.2,
                    height: MediaQuery.of(context).size.height / 22.0,
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 23.0,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: isStarted ? startsStopWatch : stopsStopWatch,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    width: MediaQuery.of(context).size.width / 4.2,
                    height: MediaQuery.of(context).size.height / 22.0,
                    child: Text(
                      (isStarted) ? "Start" : "Pause",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 23.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
