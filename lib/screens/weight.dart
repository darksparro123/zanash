import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:zaanassh/screens/navigation_bar.dart';
import 'package:zaanassh/services/save_weight.dart';

class WeightScreen extends StatefulWidget {
  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  bool isMeter = false;
  bool isFt = true;
  bool isLbs = true;
  bool isKg = false;
  bool isWeightSelected = false;
  double weight = 0.0;
  double _dragPercentage = 0;
  String weightUnit = "";
  String heightUnit = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        title: Text(
          "Weight",
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (isLbs) {
                setState(() {
                  weightUnit = "Lbs";
                });
              } else {
                setState(() {
                  weightUnit = "Kg";
                });
              }
              if (isFt) {
                setState(() {
                  heightUnit = "Feet";
                });
              } else {
                setState(() {
                  heightUnit = "Meter";
                });
              }
              bool a = await SaveWeight().saveWeight(weight, weightUnit);
              bool b =
                  await SaveWeight().saveHeight(_dragPercentage, heightUnit);

              if (a && b) {
                Get.to(() => NavigationBarScreen());
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 35.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Height",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 22.0,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      decoration: BoxDecoration(),
                      duration: Duration(seconds: 4),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isFt = true;
                            isMeter = false;
                          });
                        },
                        child: Text(
                          "Fts",
                          style: TextStyle(
                            color: (isFt) ? Colors.amber[600] : Colors.white,
                            fontSize: (isFt)
                                ? MediaQuery.of(context).size.width / 22.0
                                : MediaQuery.of(context).size.width / 28.0,
                            fontWeight:
                                (isFt) ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    AnimatedContainer(
                      decoration: BoxDecoration(),
                      duration: Duration(seconds: 4),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isFt = false;
                            isMeter = true;
                          });
                        },
                        child: Text(
                          "Meters",
                          style: TextStyle(
                            color: (isMeter) ? Colors.amber[600] : Colors.white,
                            fontSize: (isMeter)
                                ? MediaQuery.of(context).size.width / 22.0
                                : MediaQuery.of(context).size.width / 28.0,
                            fontWeight:
                                (isMeter) ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              child: (isFt)
                  ? SfSlider(
                      inactiveColor: Colors.amber[300],
                      activeColor: Colors.amber[600],

                      min: 2.0,
                      max: 8.0,
                      value: _dragPercentage,
                      interval: 16,
                      //showTicks: true,
                      //showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        setState(() {
                          _dragPercentage = value;
                        });
                      },
                    )
                  : SfSlider(
                      inactiveColor: Colors.amber[300],
                      activeColor: Colors.amber[600],

                      min: 0.75,
                      max: 4.0,
                      value: _dragPercentage,
                      interval: 8,
                      //showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        setState(() {
                          _dragPercentage = value;
                        });
                      },
                    ),
            ),
            //  SizedBox(height: MediaQuery.of(context).size.height / 8),
            Container(
              color: Colors.white.withOpacity(0.2),
              child: SizedBox(
                height: 0.5,
                width: MediaQuery.of(context).size.width / 1.1,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (isFt)
                      ? "${_dragPercentage.toString().substring(0, 3)} Feets"
                      : "${_dragPercentage.toString().substring(0, 3)} Meters",
                  style: TextStyle(
                      color: Colors.amber[600],
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width / 18.0),
                ),
              ],
            ),
            Container(
              color: Colors.white.withOpacity(0.2),
              child: SizedBox(
                height: 0.5,
                width: MediaQuery.of(context).size.width / 1.1,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weight",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 22.0,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      decoration: BoxDecoration(),
                      duration: Duration(seconds: 4),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isLbs = true;
                            isKg = false;
                          });
                        },
                        child: Text(
                          "Lbs",
                          style: TextStyle(
                            color: (isLbs) ? Colors.amber[600] : Colors.white,
                            fontSize: (isLbs)
                                ? MediaQuery.of(context).size.width / 22.0
                                : MediaQuery.of(context).size.width / 28.0,
                            fontWeight:
                                (isLbs) ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    AnimatedContainer(
                      decoration: BoxDecoration(),
                      duration: Duration(seconds: 4),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isLbs = false;
                            isKg = true;
                          });
                        },
                        child: Text(
                          "Kg",
                          style: TextStyle(
                            color: (isKg) ? Colors.amber[600] : Colors.white,
                            fontSize: (isKg)
                                ? MediaQuery.of(context).size.width / 22.0
                                : MediaQuery.of(context).size.width / 28.0,
                            fontWeight:
                                (isKg) ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            TextFormField(
              //controller: TextEditingController(),
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "Enter Your Weight",
                labelStyle: TextStyle(
                  color: Colors.amber[900],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.amber[600],
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.amber[600],
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.amber[600],
                  ),
                ),
              ),
              onChanged: (val) => setState(
                () => {
                  weight = double.parse(val),
                },
              ),
            ),
            Container(
              color: Colors.white.withOpacity(0.2),
              child: SizedBox(
                height: 0.5,
                width: MediaQuery.of(context).size.width / 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
