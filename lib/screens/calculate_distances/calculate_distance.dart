import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zaanassh/services/geo_locator_service.dart';
import 'package:http/http.dart' as http;

class CalculateDistance extends StatefulWidget {
  @override
  _CalculateDistanceState createState() => _CalculateDistanceState();
}

class _CalculateDistanceState extends State<CalculateDistance> {
  GeolocatorService geolocatorService = GeolocatorService();

  Future<Position> cPosition;
  Position streamPosition;
  double distance;
  String unit;
  Future<double> setDistance() async {
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

    return distance;
  }

  @override
  void dispose() {
    geolocatorService.getCurruntLocation();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      cPosition = geolocatorService.getInitialLocation();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: setDistance(),
        builder: (context, AsyncSnapshot<double> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitChasingDots(color: Colors.amber),
            );
          }
          return Column(
            children: [
              Text("DISTANCE",
                  style: TextStyle(
                      color: Colors.amber[700],
                      letterSpacing: 2.0,
                      fontSize: MediaQuery.of(context).size.width / 22.0)),
              Text(
                "${snapshot.data} $unit",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 6.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          );
        });
  }
}
