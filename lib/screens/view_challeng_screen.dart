import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/navigation_bar.dart';
import 'package:zaanassh/services/join_challenge_service.dart';

class ViewChallengeScreen extends StatefulWidget {
  final String docId;
  ViewChallengeScreen({@required this.docId});
  @override
  _ViewChallengeScreenState createState() => _ViewChallengeScreenState();
}

class _ViewChallengeScreenState extends State<ViewChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("challenges")
            .doc(widget.docId)
            .snapshots(),
        //initialData: initialData,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitChasingDots(color: Colors.orange[600]),
            );
          }
          return (snapshot.data.exists)
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                // color: Colors.white.withOpacity(0.1),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    snapshot.data["image_link"],
                                  ),
                                  fit: BoxFit.fill,
                                )),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(18.0)),
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          (snapshot.data["challenge_name"] == null)
                              ? ""
                              : snapshot.data["challenge_name"],
                          style: textStyle(),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18.0)),
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            (snapshot.data["challenge_description"] == null)
                                ? ""
                                : snapshot.data["challenge_description"],
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize:
                                  MediaQuery.of(context).size.width / 29.0,
                            ),
                          )),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18.0)),
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Started on ${snapshot.data["challenge_date"]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width / 29.0,
                            ),
                          )),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(18.0)),
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Goal ${snapshot.data["goal"]} steps",
                            style: TextStyle(
                              color: Colors.orange[600],
                              fontSize:
                                  MediaQuery.of(context).size.width / 20.0,
                            ),
                          )),
                      MaterialButton(
                        onPressed: () async {
                          bool a = await JoinChallenge().joinChallenge(
                              widget.docId,
                              snapshot.data["challenge_name"],
                              snapshot.data["goal"],
                              snapshot.data["image_link"]);
                          if (a) {
                            Get.snackbar("You", "Joined succusfully");
                            Future.delayed(Duration(seconds: 3)).then(
                                (value) => Get.to(() => NavigationBarScreen()));
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          height: MediaQuery.of(context).size.height / 18.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              color: Colors.orange[600]),
                          child: Text(
                            "Join",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height / 35.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: SpinKitChasingDots(color: Colors.orange[600]),
                );
        },
      ),
    );
  }

  TextStyle textStyle() => TextStyle(
        color: Colors.orange[600],
        fontSize: MediaQuery.of(context).size.height / 20,
        //letterSpacing: 1.5,
        fontWeight: FontWeight.w500,
      );
}
