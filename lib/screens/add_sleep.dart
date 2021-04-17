import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zaanassh/screens/navigation_bar.dart';
import 'package:zaanassh/services/save_sleep_hours.dart';
import 'package:zaanassh/services/save_water.dart';

class AddSleepScreen extends StatefulWidget {
  @override
  _AddSleepScreenState createState() => _AddSleepScreenState();
}

class _AddSleepScreenState extends State<AddSleepScreen> {
  int sleepHours = 0;
  String setToday() {
    DateTime now = DateTime.now();
    String today = DateFormat('MM/dd').format(now);
    return today;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        title: Text("Sleep"),
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
                      sleepHours--;
                      if (sleepHours < 0) {
                        setState(() {
                          sleepHours = 0;
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
                  "${sleepHours.toString()}",
                  style: TextStyle(
                    color: Colors.orange[600],
                    fontSize: MediaQuery.of(context).size.width / 10.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      sleepHours++;
                    });
                  },
                  color: Colors.lightBlue,
                  splashRadius: 10.0,
                  splashColor: Colors.lightBlue,
                  iconSize: MediaQuery.of(context).size.width / 5.0,
                ),
              ],
            ),
            Text(
              "We reccomend you sleep about 6 hours per day",
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: MediaQuery.of(context).size.width / 18.0,
              ),
              textAlign: TextAlign.center,
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
                bool a = await SleepHours().saveSleepHours(sleepHours);
                if (a) {
                  Get.to(() => NavigationBarScreen());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
