import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

class TimerS {
  timer() {
    return Countdown(
      seconds: 20,
      build: (BuildContext context, double time) => Text(time.toString()),
      interval: Duration(milliseconds: 100),
      onFinished: () {
        print('Timer is done!');
      },
    );
  }
}
