import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import 'package:zaanassh/screens/heart_chart.dart';

import '../services/save_activity.dart';
import 'navigation_bar.dart';

class HeartCalScreen extends StatefulWidget {
  @override
  HeartCalScreenView createState() {
    return HeartCalScreenView();
  }
}

class HeartCalScreenView extends State<HeartCalScreen> {
  bool _toggled = false;
  bool _processing = false;
  List<SensorValue> _data = [];
  CameraController _controller;
  double _bpm = 0.0;
  double _alpha = 0.3;
  Future<void> _initController() async {
    try {
      List _cameras = await availableCameras();
      _controller = CameraController(_cameras.first, ResolutionPreset.low);

      await _controller.initialize();
      Future.delayed(Duration(milliseconds: 500)).then((onValue) {
        _controller.setFlashMode(FlashMode.torch);
      });
      _controller.startImageStream((CameraImage image) {
        if (!_processing) {
          setState(() {
            _processing = true;
          });
          _scanImage(image);
        }
      });
    } catch (Exception) {
      print(Exception);
    }
  }

  _scanImage(CameraImage image) {
    double _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= 50) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(DateTime.now(), _avg));
    });
    Future.delayed(Duration(milliseconds: 1000 ~/ 30)).then((onValue) {
      setState(() {
        _processing = false;
      });
    });
  }

  _disposeController() {
    _controller.dispose();
    _controller = null;
  }

  _toggle() {
    _initController().then((onValue) {
      Wakelock.enable();
      setState(() {
        _toggled = true;
        _processing = false;
      });
      _updateBPM();
    });
  }

  _untoggle() {
    _disposeController();
    Wakelock.disable();
    setState(() {
      _toggled = false;
      _processing = false;
    });
  }

  _updateBPM() async {
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;

    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data);
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm +=
                60000 / (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        setState(() {
          _bpm = (1 - _alpha) * _bpm + _alpha * _bpm;
        });
      }
      await Future.delayed(Duration(milliseconds: (1000 * 50 / 30).round()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Scaffold(
          backgroundColor: Color.fromRGBO(35, 36, 70, 1),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(35, 36, 70, 1),
            centerTitle: false,
            title: Text(
              "Measuring Herat's BPM",
              style: TextStyle(
                color: Colors.amber[700],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Save BPM",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height / 45.0),
                ),
                onPressed: () async {
                  bool shouldNavigate = await SaveActivity().saveBPM(_bpm);
                  if (shouldNavigate) {
                    Get.to(() => NavigationBarScreen());
                    _disposeController();
                  }
                },
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: _controller == null
                              ? Container()
                              : CameraPreview(_controller),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(25.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Text(
                              (_bpm > 30 && _bpm < 150
                                  ? "${_bpm.round().toString()} BPM"
                                  : "--"),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                                fontSize:
                                    MediaQuery.of(context).size.width / 10.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                          _toggled ? Icons.favorite : Icons.favorite_border),
                      color: Colors.red,
                      iconSize: 128,
                      onPressed: () {
                        if (_toggled) {
                          _untoggle();
                        } else {
                          _toggle();
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(18),
                        ),
                        color: Colors.black),
                    child: Chart(_data),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
