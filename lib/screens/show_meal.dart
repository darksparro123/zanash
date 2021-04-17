import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowMeal extends StatefulWidget {
  final String meal;
  final String docId;
  ShowMeal({this.meal, this.docId});
  @override
  _ShowMealState createState() => _ShowMealState();
}

class _ShowMealState extends State<ShowMeal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        title: Text(
          "Your ${widget.meal}",
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser.email)
            .collection("food")
            .doc(widget.docId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitChasingDots(color: Colors.amber[600]),
            );
          }
          if (!snapshot.data.exists) {
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
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              itemCount: snapshot.data["food_data"].length,
              itemBuilder: (context, index) {
                print(
                    snapshot.data["food_data"][index]["food${index + 1}_name"]);
                return ListTile(
                  isThreeLine: true,
                  leading: ((snapshot.data["food_data"][index]
                              ["calories${index + 1}"] !=
                          "0")
                      ? Icon(
                          Icons.food_bank,
                          color: Colors.amber[600],
                        )
                      : SizedBox(
                          width: 0,
                          height: 0,
                        )),
                  title: Text(
                    (snapshot.data["food_data"][index]
                                ["calories${index + 1}"] !=
                            "0")
                        ? "Food name : ${snapshot.data["food_data"][index]["food${index + 1}_name"]}"
                        : "",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: MediaQuery.of(context).size.width / 18.0,
                    ),
                  ),
                  subtitle: (snapshot.data["food_data"][index]
                              ["calories${index + 1}"] !=
                          "0")
                      ? Text(
                          "${snapshot.data["food_data"][index]["calories${index + 1}"]} KCal",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: MediaQuery.of(context).size.width / 22.0,
                          ),
                        )
                      : Text(""),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
