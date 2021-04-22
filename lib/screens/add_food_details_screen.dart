import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zaanassh/screens/add_foods.dart';
import 'package:zaanassh/screens/show_meal.dart';

class AddFoodDetailsScreen extends StatefulWidget {
  @override
  _AddFoodDetailsScreenState createState() => _AddFoodDetailsScreenState();
}

class _AddFoodDetailsScreenState extends State<AddFoodDetailsScreen> {
  bool hasBreakfast = true;
  bool hasLunch = true;
  bool hasDinner = true;

  Stream<List> mealStream() async* {
    yield [hasBreakfast, hasLunch, hasDinner];
  }

  //set today
  String setTodayDate() {
    String monthname = "";
    DateTime now = new DateTime.now();
    switch (now.month.toString()) {
      case "1":
        monthname = "January";
        break;
      case "2":
        monthname = "February";
        break;
      case "3":
        monthname = "March";
        break;
      case "4":
        monthname = "April";
        break;
      case "5":
        monthname = "May";
        break;
      case "6":
        monthname = "June";
        break;
      case "7":
        monthname = "July";
        break;
      case "8":
        monthname = "August";
        break;
      case "9":
        monthname = "September";
        break;
      case "10":
        monthname = "October";
        break;
      case "11":
        monthname = "November";

        break;
      case "12":
        monthname = "December";
        break;

      default:
        monthname = "";
    }

    return monthname + "-" + now.day.toString().padLeft(2, "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        centerTitle: true,
        title: Text(
          "Food",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /* new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              height: 180.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                //itemExtent: 180.0,
                itemCount: 30,

                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text(
                      index.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 18.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          )*/

          Container(
            alignment: Alignment.center,
            child: Text(
              "${setTodayDate()}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width / 18.0,
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .collection("food")
                  .doc(DateFormat.yMMMd().format(DateTime.now()) + " Breakfast")
                  .snapshots(),
              builder: (context, snapshot) {
                // print(snapshot.data[0]);
                return (snapshot.hasData)
                    ? InkWell(
                        onTap: () {
                          Get.to(() => ShowMeal(
                                docId: snapshot.data.id,
                                meal: "Breakfast",
                              ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/breakfast.png"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (!snapshot.data.exists)
                                      ? "Add Breakfast"
                                      : "Breakfast",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            16.0,
                                  ),
                                ),
                                (!snapshot.data.exists)
                                    ? Text(
                                        "Recommend 543 under",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      )
                                    : Text(
                                        "Completed",
                                        style: TextStyle(
                                          color: Colors.amber[600],
                                        ),
                                      ),
                                SizedBox(height: 10.0),
                                (!snapshot.data.exists)
                                    ? TextButton(
                                        child: Text(
                                          "+ Add",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                18.0,
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(() => AddFood(
                                                meal: "Breakfast",
                                              ));
                                        },
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${snapshot.data["total_calories"]} KCAL",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.4,
                                              ),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text("544 KCAL UNDER",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    25.0,
                                              ))
                                        ],
                                      )
                              ],
                            )
                          ],
                        ),
                      )
                    : Center(child: CircularProgressIndicator());
              }),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .collection("food")
                  .doc(DateFormat.yMMMd().format(DateTime.now()) + " Lunch")
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                return (snapshot.hasData)
                    ? InkWell(
                        onTap: () {
                          Get.to(ShowMeal(
                            meal: "Lunch",
                            docId: snapshot.data.id,
                          ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/lunch.png"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (!snapshot.data.exists)
                                      ? "Add Lunch"
                                      : "Lunch",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            16.0,
                                  ),
                                ),
                                (!snapshot.data.exists)
                                    ? Text(
                                        "Recommend 830 To 1170Kcal",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      )
                                    : Text(
                                        "Completed",
                                        style: TextStyle(
                                          color: Colors.amber[600],
                                        ),
                                      ),
                                SizedBox(height: 10.0),
                                (!snapshot.data.exists)
                                    ? TextButton(
                                        child: Text(
                                          "+ Add",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                18.0,
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(() => AddFood(
                                                meal: "Lunch",
                                              ));
                                        },
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${snapshot.data["total_calories"]} KCAL",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.4,
                                              ),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text("1170 KCAL UNDER",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    25.0,
                                              ))
                                        ],
                                      )
                              ],
                            )
                          ],
                        ),
                      )
                    : Center(child: CircularProgressIndicator());
              }),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .collection("food")
                  .doc(DateFormat.yMMMd().format(DateTime.now()) + " Dinner")
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.hasData)
                    ? InkWell(
                        onTap: () {
                          if (snapshot != null) {
                            Get.to(
                              () => ShowMeal(
                                meal: "Dinner",
                                docId: snapshot.data.id,
                              ),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/dinner.png"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (!snapshot.data.exists)
                                      ? "Add Dinner"
                                      : "Dinner",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    fontSize:
                                        MediaQuery.of(context).size.width /
                                            16.0,
                                  ),
                                ),
                                (!snapshot.data.exists)
                                    ? Text(
                                        "Recommend 1030 To 1570Kcal",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                        ),
                                      )
                                    : Text(
                                        "Completed",
                                        style: TextStyle(
                                          color: Colors.amber[600],
                                        ),
                                      ),
                                SizedBox(height: 10.0),
                                (!snapshot.data.exists)
                                    ? TextButton(
                                        child: Text(
                                          "+ Add",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                18.0,
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(() => AddFood(
                                                meal: "Dinner",
                                              ));
                                        },
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${snapshot.data["total_calories"]} KCAL",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.4,
                                              ),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text("1570 KCAL UNDER",
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    25.0,
                                              ))
                                        ],
                                      ),
                              ],
                            )
                          ],
                        ),
                      )
                    : Center(child: CircularProgressIndicator());
              })
        ],
      ),
    );
  }
}
