import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/models/sport_model.dart';
import 'package:zaanassh/screens/navigation_bar.dart';

class ChooseSport extends StatefulWidget {
  @override
  _ChooseSportState createState() => _ChooseSportState();
}

class _ChooseSportState extends State<ChooseSport> {
  Sports sports = Sports();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                MediaQuery.of(context).size.width / 6,
              ),
              topRight: Radius.circular(
                MediaQuery.of(context).size.width / 6,
              ),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "CHOOSE A SPORT",
                  style: TextStyle(
                    color: Colors.amber[600],
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    Get.to(() => NavigationBarScreen());
                  },
                  child: Text("Dismiss"),
                ),
              ),
              Container(
                color: Colors.grey[500],
                child: SizedBox(
                  height: 0.5,
                  width: MediaQuery.of(context).size.width / 1.1,
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: sports.sportList.length,
                    itemBuilder: (BuildContext context, index) {
                      return Column(
                        children: [
                          Container(
                            color: Colors.grey[500],
                            child: SizedBox(
                              height: 0.5,
                              width: MediaQuery.of(context).size.width / 1.1,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Get.to(() => NavigationBarScreen());
                            },
                            hoverColor: Colors.grey[500],
                            leading: sports.sportList[index]["icon"],
                            title: Text(
                              "${sports.sportList[index]["sport"]}",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
