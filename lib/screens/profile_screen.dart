import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/daily_record_screen.dart';
import 'package:zaanassh/screens/drawe.dart';
import 'package:zaanassh/screens/find_friends_screen.dart';
import 'package:zaanassh/screens/profile_edit_page.dart';
import 'package:zaanassh/screens/weekly_summaries_screen.dart';
import 'package:zaanassh/services/save_profile_picture.dart';

class ProfileScreen extends StatefulWidget {
  final String email;
  ProfileScreen({this.email});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
//  SaveProfilePicture saveProfilePicture = SaveProfilePicture();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        actions: [
          (widget.email == null)
              ? TextButton(
                  onPressed: () {
                    Get.to(() => ProfilePageScreen());
                  },
                  child: Text("Edit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.9,
                      )),
                )
              : SizedBox(
                  width: 0,
                ),
        ],
      ),
      drawer: DrawerClass().drawer(context),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 5,
            //bottom: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45.0),
                    topRight: Radius.circular(45.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 15,
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc((widget.email == null)
                              ? (widget.email == null)
                                  ? FirebaseAuth.instance.currentUser.email
                                  : widget.email
                              : widget.email)
                          .collection("user_data")
                          .doc("name")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: SpinKitChasingDots(
                              color: Colors.orange[600],
                            ),
                          );
                        return (snapshot.data.exists)
                            ? Text(
                                // user name
                                "${snapshot.data["name"]}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                ),
                              )
                            : Text(
                                // user name
                                "Enter Name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                ),
                              );
                      }),
                  Container(
                    color: Colors.grey[600],
                    child: SizedBox(
                      height: 0.54,
                      width: MediaQuery.of(context).size.width / 1.3,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc((widget.email == null)
                                  ? (widget.email == null)
                                      ? FirebaseAuth.instance.currentUser.email
                                      : widget.email
                                  : widget.email)
                              .collection("user_data")
                              .doc("city")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(
                                child: SpinKitChasingDots(
                                  color: Colors.orange[600],
                                ),
                              );
                            return (snapshot.data.exists)
                                ? Text(
                                    // user name
                                    "${snapshot.data["city"]}",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25.0,
                                      letterSpacing: 0.1,
                                    ),
                                  )
                                : Text(
                                    // user name
                                    "Enter City",
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 0.1,
                                    ),
                                  );
                          }),
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc((widget.email == null)
                                  ? (widget.email == null)
                                      ? FirebaseAuth.instance.currentUser.email
                                      : widget.email
                                  : widget.email)
                              .collection("user_data")
                              .doc("country")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(
                                child: SpinKitChasingDots(
                                  color: Colors.orange[600],
                                ),
                              );
                            return (snapshot.data.exists)
                                ? Text(
                                    // user name
                                    "/${snapshot.data["country"]}",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25.0,
                                      letterSpacing: 0.1,
                                    ),
                                  )
                                : Text(
                                    // user name
                                    "/ Enter Country",
                                    style: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 0.1,
                                    ),
                                  );
                          }),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("user_data")
                            .doc(FirebaseAuth.instance.currentUser.email)
                            .collection("followings")
                            .doc("followings")
                            .snapshots(),
                        //  initialData: initialData ,
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                                child: SpinKitChasingDots(
                              color: Colors.orange[600],
                            ));
                          else {
                            return Column(
                              children: [
                                Text(
                                  (snapshot.data.exists)
                                      ? "${snapshot.data["followings"]}"
                                      : "0",
                                  style: followTxtStyle(),
                                ),
                                Text("Following"),
                              ],
                            );
                          }
                        },
                      ),
                      Container(
                        color: Colors.grey[500],
                        child: SizedBox(
                          width: 0.7,
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("user_data")
                            .doc(FirebaseAuth.instance.currentUser.email)
                            .collection("followers")
                            .doc("followes")
                            .snapshots(),
                        // initialData: initialData,
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                                child: SpinKitChasingDots(
                              color: Colors.orange[600],
                            ));
                          return Column(
                            children: [
                              Text(
                                (snapshot.data.exists)
                                    ? "${snapshot.data["followers"]}"
                                    : "0",
                                style: followTxtStyle(),
                              ),
                              Text("Followers"),
                            ],
                          );
                        },
                      ),
                      (widget.email == null)
                          ? Container(
                              color: Colors.grey[500],
                              child: SizedBox(
                                width: 0.7,
                                height: MediaQuery.of(context).size.height / 40,
                              ))
                          : SizedBox(
                              width: 0,
                            ),
                      (widget.email == null)
                          ? MaterialButton(
                              onPressed: () {
                                Get.to(() => FindFreiendsScreen());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: MediaQuery.of(context).size.height / 22,
                                alignment: Alignment.center,
                                child: Text(
                                  "Find Friends",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 28,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 0,
                            ),
                    ],
                  ),
                  Container(
                    color: Colors.grey[600],
                    child: SizedBox(
                      height: 0.54,
                      width: MediaQuery.of(context).size.width / 1.1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "User Information",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height / 45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 20,
                    /*  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(25.0),
                    ),*/
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            height: MediaQuery.of(context).size.height / 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc((widget.email == null)
                                        ? (widget.email == null)
                                            ? FirebaseAuth
                                                .instance.currentUser.email
                                            : widget.email
                                        : widget.email)
                                    .collection("user_data")
                                    .doc("gender")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                      child: SpinKitChasingDots(
                                        color: Colors.orange[600],
                                      ),
                                    );
                                  return (snapshot.data.exists)
                                      ? Text(
                                          "${snapshot.data["gender"]}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : Text(
                                          "Gender",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        );
                                }),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            height: MediaQuery.of(context).size.height / 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc((widget.email == null)
                                        ? (widget.email == null)
                                            ? FirebaseAuth
                                                .instance.currentUser.email
                                            : widget.email
                                        : widget.email)
                                    .collection("user_data")
                                    .doc("age")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                      child: SpinKitChasingDots(
                                        color: Colors.orange[600],
                                      ),
                                    );
                                  return (snapshot.data.exists)
                                      ? Text(
                                          "DOB :${snapshot.data["age"]}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                35,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          "DOB",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.3,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 20,
                    /*  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(25.0),
                    ),*/
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            height: MediaQuery.of(context).size.height / 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc((widget.email == null)
                                        ? (widget.email == null)
                                            ? FirebaseAuth
                                                .instance.currentUser.email
                                            : widget.email
                                        : widget.email)
                                    .collection("height")
                                    .doc("height")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                        child: SpinKitChasingDots(
                                            color: Colors.orange[600]));
                                  return (snapshot.data.exists)
                                      ? Text(
                                          "${snapshot.data["height"].toString().substring(0, 3)} ${snapshot.data["unit"]}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : Text(
                                          "Height",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        );
                                }),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            height: MediaQuery.of(context).size.height / 25,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc((widget.email == null)
                                        ? (widget.email == null)
                                            ? FirebaseAuth
                                                .instance.currentUser.email
                                            : widget.email
                                        : widget.email)
                                    .collection("weight")
                                    .doc("weight")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                        child: SpinKitChasingDots(
                                            color: Colors.orange[600]));
                                  return (snapshot.data.exists)
                                      ? Text(
                                          "${snapshot.data["weight"].toString().substring(0, 4)} ${snapshot.data["unit"]}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.8,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                32,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      : Text(
                                          "Weight",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.3,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[600],
                    child: SizedBox(
                      height: 0.54,
                      width: MediaQuery.of(context).size.width / 1.1,
                    ),
                  ),
                  (widget.email == null)
                      ? ListTile(
                          onTap: () {
                            Get.to(() => WeeklySummariesScreen());
                          },
                          title: Text("Weekly Summary"),
                          subtitle:
                              Text("Last week's activity (15:21 April 2021)"),
                          trailing: IconButton(
                              icon: Icon(Icons.arrow_right), onPressed: () {}),
                        )
                      : SizedBox(width: 0),
                  Container(
                    color: Colors.grey[600],
                    child: SizedBox(
                      height: 0.54,
                      width: MediaQuery.of(context).size.width / 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width / 7,
            right: MediaQuery.of(context).size.width / 3.2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () async {
                    //File file = await saveProfilePicture.getImage();
                    //saveProfilePicture.saveImageToFirestore(file);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3.5,
                    height: MediaQuery.of(context).size.height / 5.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle followTxtStyle() {
    return TextStyle(
        color: Colors.orange,
        fontSize: MediaQuery.of(context).size.width / 25,
        letterSpacing: 1.0);
  }
}
