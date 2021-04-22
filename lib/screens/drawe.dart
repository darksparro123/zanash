import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/landing_page.dart';
import 'package:zaanassh/screens/profile_screen.dart';
import 'package:zaanassh/screens/poly_line_screen.dart';
import 'package:zaanassh/screens/record_screen.dart';
import 'package:zaanassh/screens/settings.dart';
import 'package:zaanassh/screens/unit_messurement_screeen.dart';
import 'package:zaanassh/services/geo_locator_service.dart';

class DrawerClass {
  Future<String> getImage() async {
    String imageUrl;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection("avatar")
        .doc("avatar")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        imageUrl = documentSnapshot.data()['avatar'];
        print("Success $imageUrl");
      }
    });
    return imageUrl;
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(19, 20, 41, 1),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 12,
                ),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 5.5,
                  backgroundColor: Colors.grey[500].withOpacity(0.5),
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width / 6,
                    child: ClipOval(
                      child: Container(
                        child: FutureBuilder<String>(
                          future: getImage(),
                          builder: (context, snapshot) {
                            print(snapshot.data);
                            if (snapshot.hasData && snapshot.data != null) {
                              return Image.network(
                                snapshot.data,
                                fit: BoxFit.fill,
                              );
                            } else {
                              return Image.network(
                                "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png",
                                fit: BoxFit.fill,
                              );
                            }
                          },
                        ),
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 45,
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser.email)
                        .collection("user_data")
                        .doc("name")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: SpinKitChasingDots(
                            color: Colors.amber[600],
                          ),
                        );
                      return (snapshot.data.exists)
                          ? Text(
                              "${snapshot.data["name"]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.height / 25,
                              ),
                            )
                          : Text(
                              "User",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.height / 25,
                              ),
                            );
                    }),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser.email)
                            .collection("weight")
                            .doc("weight")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: SpinKitChasingDots(
                                color: Colors.amber[600],
                              ),
                            );
                          return (snapshot.data.exists)
                              ? Text(
                                  "${snapshot.data["weight"]} ${snapshot.data["unit"]} /",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize:
                                        MediaQuery.of(context).size.height / 35,
                                  ),
                                )
                              : Text(
                                  "weight /",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize:
                                        MediaQuery.of(context).size.height / 35,
                                  ),
                                );
                        }),
                    StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser.email)
                            .collection("height")
                            .doc("height")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: SpinKitChasingDots(
                                color: Colors.amber[600],
                              ),
                            );
                          return (snapshot.data.exists)
                              ? Text(
                                  "${snapshot.data["height"].toString().substring(0, 3)} ${snapshot.data["unit"]} ",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize:
                                        MediaQuery.of(context).size.height / 35,
                                  ),
                                )
                              : Text(
                                  "height",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize:
                                        MediaQuery.of(context).size.height / 35,
                                  ),
                                );
                        }),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 10,
                vertical: MediaQuery.of(context).size.width / 10,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Get.to(() => ProfileScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.home_sharp,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 18,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 8),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 140),
                          child: Text(
                            "Me",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 25,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Position i =
                          await GeolocatorService().getInitialLocation();
                      Get.to(() => RecordScreen(
                            initialPosition: i,
                            showMap: false,
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.adjust_sharp,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 18,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 8),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 140),
                          child: Text(
                            "Record",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 25,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  MaterialButton(
                    onPressed: () {
                      //Get.to(() => RiderMapScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.flip_camera_android,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 18,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 8),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 140),
                          child: Text(
                            "Help",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 25,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  MaterialButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.message_sharp,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 18,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 8),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 140),
                          child: Text(
                            "Contact Us",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 25,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  /*MaterialButton(
                    onPressed: () {
                      Get.to(() => SettingsScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / 18,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 8),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 140),
                          child: Text(
                            "Settings",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 25,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),*/
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .signOut()
                          .then((value) => Get.to(() => LandingPage()));
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
