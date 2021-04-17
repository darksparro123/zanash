import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zaanassh/screens/navigation_bar.dart';
import 'package:zaanassh/services/save_water.dart';

class AddWaterScreen extends StatefulWidget {
  @override
  _AddWaterScreenState createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen> {
  //set Dodat date
  String setToday() {
    DateTime now = DateTime.now();
    String today = DateFormat('MM/dd').format(now);
    return today;
  }

  int numberOfGlasses = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        title: Text("Water"),
      ),
      body: Container(
        margin: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 12.0,
                  //padding: EdgeInsets.all(12.0),
                  alignment: Alignment.center,
                  child: Text(setToday(),
                      style: TextStyle(
                        color: Colors.orange[600],
                        fontSize: MediaQuery.of(context).size.width / 18.0,
                      )),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  padding: EdgeInsets.only(bottom: 50.0),
                  icon: Icon(Icons.minimize_rounded),
                  onPressed: () {
                    setState(() {
                      numberOfGlasses--;
                      if (numberOfGlasses < 0) {
                        setState(() {
                          numberOfGlasses = 0;
                        });
                      }
                    });
                  },
                  color: Colors.lightBlue,
                  splashRadius: 10.0,
                  splashColor: Colors.lightBlue,
                  iconSize: MediaQuery.of(context).size.width / 5.0,
                ),
                Text(
                  "${numberOfGlasses.toString()}",
                  style: TextStyle(
                    color: Colors.orange[600],
                    fontSize: MediaQuery.of(context).size.width / 10.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      numberOfGlasses++;
                    });
                  },
                  color: Colors.lightBlue,
                  splashRadius: 10.0,
                  splashColor: Colors.lightBlue,
                  iconSize: MediaQuery.of(context).size.width / 5.0,
                ),
              ],
            ),
            MaterialButton(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.orange[800],
                    borderRadius: BorderRadius.circular(18.0)),
                width: MediaQuery.of(context).size.width / 2.0,
                height: MediaQuery.of(context).size.height / 15.0,
                alignment: Alignment.center,
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 17.0,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              onPressed: () async {
                bool a = await SaveWater().saveWater(numberOfGlasses);
                if (a) {
                  // Get.snackbar("Water", "Added succusfully");
                  Get.to(NavigationBarScreen());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
