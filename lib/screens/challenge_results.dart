import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChallengeResultsScreen extends StatefulWidget {
  @override
  _ChallengeResultsScreenState createState() => _ChallengeResultsScreenState();
}

class _ChallengeResultsScreenState extends State<ChallengeResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        title: Text(
          "Cahllenge Results",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("challenge_results")
                  .orderBy("result", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.amber[800],
                    ),
                  );
                }
                var doc = snapshot.data.docs;
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 500.0,
                  child: ListView.builder(
                    itemCount: doc.length,
                    itemBuilder: (context, index) {
                      return (doc[index].data()["user_id"] ==
                              FirebaseAuth.instance.currentUser.email)
                          ? Card(
                              color: Color.fromRGBO(35, 36, 70, 1),
                              elevation: 9.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                height: MediaQuery.of(context).size.height / 5,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(18.0),
                                margin: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("challenges")
                                            .doc(doc[index].id.split(" ")[1])
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.data == null ||
                                              !snapshot.hasData) {
                                            return Center(
                                                child: SpinKitSpinningCircle(
                                              color: Colors.amber[500],
                                            ));
                                          }
                                          return Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                            ),
                                            padding: EdgeInsets.all(15.0),
                                            child: Text(
                                              "Challenge Name : ${snapshot.data["challenge_name"]}",
                                              style: TextStyle(
                                                color: Colors.orange[600],
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    18.0,
                                              ),
                                            ),
                                          );
                                        }),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      height: 3.0,
                                      child: Container(color: Colors.amber),
                                    ),
                                    Text(
                                      "Your rank is ${(index + 1).toString().padLeft(2, "0")}",
                                      style: TextStyle(
                                        color: Colors.orange[600],
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(width: 0.0);
                    },
                  ),
                );
              }),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("challenge_results")
                  .where("user_id",
                      isNotEqualTo: FirebaseAuth.instance.currentUser.email)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: SpinKitChasingDots(color: Colors.amber));
                }
                return SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 5,
                    child: ListView(
                      children: snapshot.data.docs.map((doc) {
                        return Card(
                          color: Color.fromRGBO(35, 36, 70, 1),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: MediaQuery.of(context).size.height / 8.0,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(doc.id.split(" ")[0])
                                  .snapshots(),
                              // initialData: initialData ,
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (!snapshot.data.exists ||
                                    snapshot.data == null) {
                                  return Center(
                                    child: SpinKitCircle(
                                      color: Colors.amber[600],
                                    ),
                                  );
                                }
                                return Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[600],
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              7.0,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              7.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                (snapshot.data.data()[
                                                            "image_link"] ==
                                                        null)
                                                    ? "${snapshot.data.data()["image_link"]}"
                                                    : "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDJ8fHxlbnwwfHx8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        radius: 40.0,
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(12.0),
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            color:
                                                Colors.white.withOpacity(0.1)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (snapshot.data.data()["name"] ==
                                                      null)
                                                  ? ""
                                                  : "Name : ${snapshot.data.data()["name"]}",
                                              style: TextStyle(
                                                  color: Colors.amber[500],
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          22.0),
                                            ),
                                            Text(
                                              (snapshot.data.data()["city"] ==
                                                      null)
                                                  ? ""
                                                  : "${snapshot.data.data()["city"]}",
                                              style: TextStyle(
                                                  color: Colors.amber[500],
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25.0),
                                            ),
                                            Text(
                                              (snapshot.data
                                                          .data()["country"] ==
                                                      null)
                                                  ? ""
                                                  : "${snapshot.data.data()["country"]}",
                                              style: TextStyle(
                                                  color: Colors.amber[500],
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ));
              })
        ],
      ),
    );
  }
}
