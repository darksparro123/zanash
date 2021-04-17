import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/start_walk.dart';

class SeeChallenge extends StatefulWidget {
  final bool fromUsScreen;
  final String docId;
  SeeChallenge({this.docId, this.fromUsScreen});
  @override
  _SeeChallengeState createState() => _SeeChallengeState();
}

class _SeeChallengeState extends State<SeeChallenge> {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder(
              stream: firebase
                  .collection("challenges")
                  .doc(widget.docId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.orange[700],
                    ),
                  );
                }

                return Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              NetworkImage("${snapshot.data["image_link"]}"))),
                );
              },
            ),
            StreamBuilder(
              stream: firebase
                  .collection("challenges")
                  .doc(widget.docId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: SpinKitCircle(
                      color: Colors.orange[700],
                    ),
                  );
                }

                return Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Name : ${snapshot.data["challenge_name"]}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 22.0,
                          ),
                        ),
                        Container(
                          color: Colors.amber.withOpacity(0.4),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            height: 2.0,
                          ),
                        ),
                        Text(
                          "Date : ${snapshot.data["challenge_date"]}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 22.0,
                          ),
                        ),
                        Container(
                          color: Colors.amber.withOpacity(0.4),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            height: 2.0,
                          ),
                        ),
                        Text(
                          "Description : ${snapshot.data["challenge_description"]}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 22.0,
                          ),
                        ),
                        Container(
                          color: Colors.amber.withOpacity(0.4),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.3,
                            height: 2.0,
                          ),
                        ),
                        Text(
                          "Current Participants : ${snapshot.data["challenge_participents"]}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width / 22.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            MaterialButton(
              onPressed: () {
                Get.to(() => StartWalkScreen(
                      challengeId: widget.docId,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber[700],
                  borderRadius: BorderRadius.circular(18.0),
                ),
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 15.0,
                alignment: Alignment.center,
                child: Text(
                  "Start",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
