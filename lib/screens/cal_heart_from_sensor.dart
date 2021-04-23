/*import 'package:conreality_pulse/conreality_pulse.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class HeartSensorScreen extends StatefulWidget {
  @override
  _HeartSensorScreenState createState() => _HeartSensorScreenState();
}

class _HeartSensorScreenState extends State<HeartSensorScreen> {
  Future<Stream<PulseEvent>> s() {
    return Pulse.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream>(
      future: s(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "Please connect to a Polar H10 heart rate sensor or Polor 0H1 heart rate sensor",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width / 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return Container(
            alignment: Alignment.center,
            child: Text(
              "${snapshot.data} BPM",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width / 20.0,
                fontWeight: FontWeight.bold,
              ),
            ));
      },
    );
  }
}*/
