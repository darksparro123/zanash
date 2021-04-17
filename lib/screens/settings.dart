import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/unit_messurement_screeen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialButton(
              onPressed: () {
                Get.to(() => UnitMessurementScreen());
              },
              child: Container(
                padding: EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(00.1),
                    borderRadius: BorderRadius.circular(15.0)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      FontAwesomeIcons.globe,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    Text(
                      "Unit of mesurement",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 18.8,
                      ),
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Icon(
                      FontAwesomeIcons.chevronRight,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
