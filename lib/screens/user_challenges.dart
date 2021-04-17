import 'package:animated_list_view_scroll/animated_list_view_scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:zaanassh/screens/create_challenge.dart';
import 'package:zaanassh/screens/view_challeng_screen.dart';

class UserChallengsScreen extends StatefulWidget {
  @override
  _UserChallengsScreenState createState() => _UserChallengsScreenState();
}

class _UserChallengsScreenState extends State<UserChallengsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        title: Text("Challenges Recommended "),
        actions: [
          MaterialButton(
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 24.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  color: Colors.orange[600]),
              child: Text(
                "Create a challenge",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            onPressed: () {
              Get.to(() => CreateChallengeScreen());
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("challenges")
            .orderBy("created_at", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: SpinKitChasingDots(
              color: Colors.amber[600],
            ));
          }
          //  var doc = snapshot.data.docs;
          return ListView(
              children: snapshot.data.docs.map((e) {
            return Container(
                margin: EdgeInsets.all(15.0),
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 1.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white.withOpacity(0.1),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          // color: Colors.white.withOpacity(0.1),
                          image: DecorationImage(
                            image: NetworkImage(
                              e.data()["image_link"],
                            ),
                            fit: BoxFit.fill,
                          )),
                    ),
                    Text(
                      e.data()["challenge_name"],
                      style: TextStyle(
                        color: Colors.orange[600],
                        fontSize: MediaQuery.of(context).size.width / 18.0,
                      ),
                    ),
                    Text(
                      "${e.data()["goal"]} Steps",
                      style: TextStyle(
                        color: Colors.orange[600],
                        fontSize: MediaQuery.of(context).size.width / 22.0,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Get.to(() => ViewChallengeScreen(
                              docId: e.id,
                            ));
                        print(e.id);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 18.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            color: Colors.orange[600]),
                        child: Text(
                          "Start",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height / 35.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ));
          }).toList());
        },
      ),
    );
  }
}
