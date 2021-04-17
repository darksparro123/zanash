import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/follow_requests_screen.dart';
import 'package:zaanassh/screens/profile_screen.dart';
import 'package:zaanassh/services/follo_following_service.dart';

class FindFreiendsScreen extends StatefulWidget {
  @override
  _FindFreiendsScreenState createState() => _FindFreiendsScreenState();
}

class _FindFreiendsScreenState extends State<FindFreiendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        title: Text(
          "Find Friends",
          textAlign: TextAlign.center,
        ),
        //centerTitle: true,
        actions: [
          MaterialButton(
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 24.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  color: Colors.orange[600]),
              child: Text(
                "Follow Requests",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            onPressed: () {
              Get.to(() => FollowRequestsScreen());
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        //initialData: initialData ,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitCircle(
                color: Colors.orange[600],
              ),
            );
          }
          return ListView(
              children: snapshot.data.docs.map((doc) {
            return (doc.id != FirebaseAuth.instance.currentUser.email)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.white.withOpacity(0.1),
                      child: ListTile(
                        onTap: () {
                          Get.to(() => ProfileScreen(
                                email: doc.id,
                              ));
                        },
                        leading: ClipOval(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 8.0,
                            height: MediaQuery.of(context).size.width / 8.0,
                            child: Image.network(
                              (doc.data()["profile_image_link"] == null)
                                  ? "https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg"
                                  : doc.data()["profile_image_link"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        title: Text(
                          (doc.data()["name"] != null)
                              ? doc.data()["name"]
                              : "",
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: MediaQuery.of(context).size.width / 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          (doc.data()["city"] != null)
                              ? "${doc.data()["city"]} / ${doc.data()["country"]}"
                              : "",
                          style: TextStyle(
                            color: Colors.orange[600],
                            fontSize: MediaQuery.of(context).size.width / 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // tileColor: Colors.orange[600],
                        trailing: MaterialButton(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 6,
                            height: MediaQuery.of(context).size.height / 25.0,
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
                                .sendFollowrequest(
                                    doc.id,
                                    doc.data()["name"],
                                    doc.data()["city"],
                                    doc.data()["country"],
                                    doc.data()["profile_image_link"]);
                            if (a) {
                              Get.snackbar(name, "Followe request sent");
                            }
                          },
                        ),
                      ),
                    ),
                  )
                : SizedBox(width: 0.0, height: 0.0);
          }).toList());
        },
      ),
    );
  }
}
