import 'dart:async';

import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  @override
  _StopWatchScreenState createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  bool isStarted = true;
  bool isReset = true;
  bool isStopped = true;
  String stopTimetoDisplay = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(seconds: 1);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
