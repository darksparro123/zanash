import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/challenge_results.dart';
import 'package:zaanassh/screens/see_challenge.dart';

class MyChallengesScreen extends StatefulWidget {
  @override
  _MyChallengesScreenState createState() => _MyChallengesScreenState();
}

class _MyChallengesScreenState extends State<MyChallengesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        centerTitle: false,
        title: Text("My Challenges"),
        actions: [
          TextButton(
            child: Text(
              "Challenge Results",
              style: TextStyle(color: Colors.amber[700]),
            ),
            onPressed: () {
              Get.to(() => ChallengeResultsScreen());
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("challenges").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/no_data.png")),
                Text(
                  "No data",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 1.5,
                    fontSize: MediaQuery.of(context).size.width / 22,
                  ),
                )
              ],
            );
          }

          return ListView(
            children: snapshot.data.docs.map((doc) {
              if (doc.data() == null || doc.data()["challenge_name"] == null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        child: Image.asset("assets/no_data.png")),
                    Text(
                      "No data",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        letterSpacing: 1.5,
                        fontSize: MediaQuery.of(context).size.width / 22,
                      ),
                    )
                  ],
                );
              }
              return (doc
                      .data()["participants"]
                      .contains(FirebaseAuth.instance.currentUser.email))
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        color: Color.fromRGBO(35, 36, 70, 1),
                        elevation: 5,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          title: Text(
                            doc.data()["challenge_name"],
                            style: TextStyle(
                              color: Colors.amber[700],
                              fontSize:
                                  MediaQuery.of(context).size.width / 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${doc.data()["goal"]} Steps",
                            style: TextStyle(
                              color: Colors.amber[300],
                              //fontSize: MediaQuery.of(context).size.width / 18.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          // isThreeLine: true,
                          contentPadding: EdgeInsets.all(20.0),
                          leading: ClipOval(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 7,
                              height: MediaQuery.of(context).size.width / 7,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "${doc.data()["image_link"]}",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                                color: Colors.pink.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15.0)),
                            padding: EdgeInsets.all(10.0),
                            child: TextButton(
                              onPressed: () {
                                Get.to(() => SeeChallenge(
                                    docId: doc.id, fromUsScreen: false));
                              },
                              child: Text(
                                "See Challenge",
                                style: TextStyle(
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 0.0,
                    );
            }).toList(),
          );
        },
      ),
    );
  }
}
