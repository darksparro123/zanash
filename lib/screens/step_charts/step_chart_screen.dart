import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zaanassh/screens/step_charts/steps_model.dart';

class StepsChart extends StatefulWidget {
  @override
  _StepsChartState createState() => _StepsChartState();
}

class _StepsChartState extends State<StepsChart> {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  // StepsModel stepsModel = StepsModel();
  //genrate chart data
  List<charts.Series<StepsModel, int>> _stepsData = [];
  List<StepsModel> myData = [];
  _generateData(myData) {
    _stepsData.add(
      charts.Series(
        domainFn: (StepsModel stepsModel, _) => stepsModel.week,
        measureFn: (StepsModel stepsModel, _) => stepsModel.totalSteps,
        colorFn: (StepsModel stepsModel, _) =>
            charts.ColorUtil.fromDartColor(Colors.green),
        id: "Steps",
        data: myData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firebase
          .collection("daily_activities")
          .orderBy("day")
          .where("user_id", isEqualTo: auth.currentUser.email)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SpinKitSpinningCircle(color: Colors.amber[700]),
          );
        } else {
          List<StepsModel> steps = snapshot.data.docs
              .map((doc) => StepsModel.fromMap(doc.data()))
              .toList();
          return _buildChart(context, steps);
        }
      },
    );
  }

  Widget _buildChart(context, List<StepsModel> steps) {
    myData = steps;
    _generateData(myData);
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: charts.LineChart(_stepsData,
          animate: true,
          animationDuration: Duration(seconds: 3),
          defaultRenderer: new charts.LineRendererConfig(includePoints: true)),
    );
  }
}
