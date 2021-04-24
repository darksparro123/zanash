import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android/android_hardware.dart'
    show Sensor, SensorEvent, SensorManager;

/*class HeartRateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HeartRatePage(),
    );
  }
}

class HeartRatePage extends StatefulWidget {
  const HeartRatePage({Key key}) : super(key: key);

  @override
  _HeartRateState createState() => _HeartRateState();
}*/
class SensorEvents {
  Stream<SensorEvent> getHeartRate() async* {
    var sensor = await SensorManager.getDefaultSensor(Sensor.TYPE_HEART_RATE);
    var events = await sensor.subscribe();
    events.listen((event) async* {
      print("event - $event");
      print(event.values[0]);
      yield event.values[0];
    });
  }
}

class HeartRateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Center(
        child: StreamBuilder(
          stream: SensorEvents().getHeartRate(),
          builder: (context, snapshot) {
            print("Snapshot - ${snapshot.data}");
            if (snapshot.hasData && snapshot.data != null) {
              return Text(
                snapshot.data,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width / 7.0,
                ),
              );
            } else {
              return Text(
                "No Data Available",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width / 7.0,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
