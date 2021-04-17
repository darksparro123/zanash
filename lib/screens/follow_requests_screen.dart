import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/profile_screen.dart';
import 'package:zaanassh/services/follo_following_service.dart';

class FollowRequestsScreen extends StatefulWidget {
  @override
  _FollowRequestsScreenState createState() => _FollowRequestsScreenState();
}

class _FollowRequestsScreenState extends State<FollowRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        title: Text("Follow Requests"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("follow_requests")
            .where("follower_email",
                isEqualTo: FirebaseAuth.instance.currentUser.email)
            .snapshots(),
        //initialData: initialData ,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitChasingDots(
                color: Colors.orange[800],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: snapshot.data.docs.map((doc) {
                return (!doc.data()["accepted"])
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        color: Colors.white.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            color: Colors.white.withOpacity(0.1),
                            child: ListTile(
                              onTap: () {
                                Get.to(() => ProfileScreen(
                                    email: doc.data()["request_email"]));
                              },
                              leading: ClipOval(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 8.0,
                                  height:
                                      MediaQuery.of(context).size.width / 8.0,
                                  child: Image.network(
                                    (doc.data()["profile_image_link"] == null)
                                        ? "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg"
                                        : doc.data()["image_link"],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              title: Text(
                                doc.data()["name"],
                                style: TextStyle(
                                  color: Colors.orange[800],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${doc.data()["city"]} / ${doc.data()["country"]}",
                                style: TextStyle(
                                  color: Colors.orange[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // tileColor: Colors.orange[600],
                              trailing: MaterialButton(
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  height:
                                      MediaQuery.of(context).size.height / 25.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: Colors.orange[600]),
                                  child: Text(
                                    "Follow",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  String name = doc.data()["name"];
                                  bool a = await FollowFollowingService()
                                      .following(doc.id);
                                  if (a) {
                                    Get.snackbar(name, "You are now following");
                                  }
                                },
                              ),
                            ),
                          ),
                        ))
                    : SizedBox(
                        height: 0,
                        width: 0,
                      );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
