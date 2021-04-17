import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:zaanassh/services/save_user_data.dart';

class ProfilePageScreen extends StatefulWidget {
  @override
  _ProfilePageScreenState createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  final firebase = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  TextEditingController name = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  SaveUserData saveUserData = SaveUserData();
  String gender = "";
  String dateOfBirth = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 60.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                  stream: firebase
                      .collection("users")
                      .doc(auth.currentUser.email)
                      .collection("user_data")
                      .doc("name")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SpinKitChasingDots(color: Colors.orange[600]),
                      );
                    }
                    //   print(snapshot.data["name"]);
                    return (snapshot.data.exists)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name : ${snapshot.data["name"]}",
                                style: TextStyle(
                                  color: Colors.orange[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25.0,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Get.dialog(Dialog(
                                    backgroundColor:
                                        Color.fromRGBO(19, 20, 41, 1),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: TextFormField(
                                                  controller: name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            22.0,
                                                  ),
                                                  decoration: inputDecoration(
                                                      "  Name")),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                print("Clicked");
                                                bool a = await saveUserData
                                                    .saveName(name.text);
                                                print(a);
                                                if (a) {
                                                  Get.snackbar("Name",
                                                      "Added Succusfully");
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    25.0,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.orange[600],
                                                ),
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.orange[600],
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 28.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: TextFormField(
                                    controller: name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.0,
                                    ),
                                    decoration: inputDecoration("  Name")),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  bool a =
                                      await saveUserData.saveName(name.text);
                                  print(a);
                                  if (a) {
                                    Get.snackbar("Name", "Added Succusfully");
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 6.0,
                                  height:
                                      MediaQuery.of(context).size.height / 30.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.orange[600],
                                  ),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  }),
              StreamBuilder(
                  stream: firebase
                      .collection("users")
                      .doc(auth.currentUser.email)
                      .collection("user_data")
                      .doc("city")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SpinKitChasingDots(color: Colors.orange[600]),
                      );
                    }
                    //   print(snapshot.data["name"]);
                    return (snapshot.data.exists)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "City : ${snapshot.data["city"]}",
                                style: TextStyle(
                                  color: Colors.orange[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25.0,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Get.dialog(Dialog(
                                    backgroundColor:
                                        Color.fromRGBO(19, 20, 41, 1),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: TextFormField(
                                                  controller: city,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            22.0,
                                                  ),
                                                  decoration: inputDecoration(
                                                      "  City")),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                print("Clicked");
                                                bool a = await saveUserData
                                                    .saveCity(city.text);
                                                print(a);
                                                if (a) {
                                                  Get.snackbar("city",
                                                      "Added Succusfully");
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    25.0,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.orange[600],
                                                ),
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.orange[600],
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 28.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 1.9,
                                child: TextFormField(
                                    controller: city,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.0,
                                    ),
                                    decoration: inputDecoration("  City")),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  bool a =
                                      await saveUserData.saveCity(city.text);
                                  print(a);
                                  if (a) {
                                    Get.snackbar("City", "Added Succusfully");
                                  }
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 6.0,
                                  height:
                                      MediaQuery.of(context).size.height / 30.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.orange[600],
                                  ),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  }),
              StreamBuilder(
                  stream: firebase
                      .collection("users")
                      .doc(auth.currentUser.email)
                      .collection("user_data")
                      .doc("country")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SpinKitChasingDots(color: Colors.orange[600]),
                      );
                    }
                    //   print(snapshot.data["name"]);
                    return (snapshot.data.exists)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Country : ${snapshot.data["country"]}",
                                style: TextStyle(
                                  color: Colors.orange[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25.0,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Get.dialog(Dialog(
                                    backgroundColor:
                                        Color.fromRGBO(19, 20, 41, 1),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: TextFormField(
                                                  controller: country,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            22.0,
                                                  ),
                                                  decoration: inputDecoration(
                                                      "  Country")),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                print("Clicked");
                                                bool a = await saveUserData
                                                    .saveCountry(country.text);
                                                print(a);
                                                if (a) {
                                                  Get.snackbar("Country",
                                                      "Added Succusfully");
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    25.0,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.orange[600],
                                                ),
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.orange[600],
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 28.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 1.9,
                                child: TextFormField(
                                    controller: country,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.0,
                                    ),
                                    decoration: inputDecoration("  Country")),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  bool a = await saveUserData
                                      .saveCountry(country.text);
                                  print(a);
                                  if (a) {
                                    Get.snackbar(
                                        "Country", "Added Succusfully");
                                  }
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 6.0,
                                  height:
                                      MediaQuery.of(context).size.height / 30.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.orange[600],
                                  ),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  }),
              StreamBuilder(
                  stream: firebase
                      .collection("users")
                      .doc(auth.currentUser.email)
                      .collection("user_data")
                      .doc("gender")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SpinKitChasingDots(color: Colors.orange[600]),
                      );
                    }
                    //   print(snapshot.data["name"]);
                    return (snapshot.data.exists)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Gender : ${snapshot.data["gender"]}",
                                style: TextStyle(
                                  color: Colors.orange[600],
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25.0,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Get.dialog(Dialog(
                                    backgroundColor:
                                        Color.fromRGBO(19, 20, 41, 1),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: DropdownButtonFormField(
                                                  dropdownColor: Color.fromRGBO(
                                                      19, 20, 41, 1),
                                                  items: [
                                                    DropdownMenuItem(
                                                        child: Text("Male"),
                                                        value: "Male"),
                                                    DropdownMenuItem(
                                                      child: Text("Female"),
                                                      value: "Female",
                                                    )
                                                  ],
                                                  onChanged: (val) {
                                                    setState(() {
                                                      gender = val;
                                                    });
                                                  },
                                                  //controller: name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            22.0,
                                                  ),
                                                  decoration: inputDecoration(
                                                      "  Name")),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                print("Clicked");
                                                bool a = await saveUserData
                                                    .saveGender(gender);
                                                print(a);
                                                if (a) {
                                                  Get.snackbar("Gender",
                                                      "Added Succusfully");
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    25.0,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.orange[600],
                                                ),
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.orange[600],
                                  ),
                                  width: MediaQuery.of(context).size.width / 5,
                                  height:
                                      MediaQuery.of(context).size.height / 28.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 2,
                                child: DropdownButtonFormField(
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val;
                                      });
                                    },
                                    dropdownColor:
                                        Color.fromRGBO(19, 20, 41, 1),
                                    items: [
                                      DropdownMenuItem(
                                        child: Text("Male"),
                                        value: "Male",
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Female"),
                                        value: "Female",
                                      ),
                                    ],
                                    //controller: name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22.0,
                                    ),
                                    decoration: inputDecoration("  Gender")),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  bool a =
                                      await saveUserData.saveGender(gender);
                                  print(a);
                                  if (a) {
                                    Get.snackbar("Gender", "Added Succusfully");
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 5.0,
                                  height:
                                      MediaQuery.of(context).size.height / 28.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.orange[600],
                                  ),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  }),
              StreamBuilder(
                  stream: firebase
                      .collection("users")
                      .doc(auth.currentUser.email)
                      .collection("user_data")
                      .doc("age")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SpinKitChasingDots(color: Colors.orange[600]),
                      );
                    }
                    //   print(snapshot.data["name"]);

                    return (snapshot.data.exists)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "DOB ${snapshot.data["age"]}",
                                style: TextStyle(
                                  color: Colors.orange[600],
                                ),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  Get.dialog(
                                    Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(19, 20, 41, 1),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.0,
                                              child: DateTimePicker(
                                                decoration: inputDecoration(
                                                    "Date of Birth"),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                type: DateTimePickerType.date,
                                                dateMask: 'd MMM, yyyy',
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2030),
                                                onChanged: (val) {
                                                  dateOfBirth = val;
                                                },
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                bool a = await saveUserData
                                                    .saveAge(dateOfBirth);
                                                print(a);
                                                if (a) {
                                                  Get.snackbar("D.O.B",
                                                      "Added Succusfully");
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5.0,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    28.0,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.orange[600],
                                                ),
                                                child: Text(
                                                  "Update",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 5.0,
                                  height:
                                      MediaQuery.of(context).size.height / 28.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.orange[600],
                                  ),
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.0,
                                child: DateTimePicker(
                                  decoration: inputDecoration("Date of Birth"),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  type: DateTimePickerType.date,
                                  dateMask: 'd MMM, yyyy',
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2030),
                                  onChanged: (val) {
                                    dateOfBirth = val;
                                  },
                                ),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  bool a =
                                      await saveUserData.saveAge(dateOfBirth);
                                  print(a);
                                  if (a) {
                                    Get.snackbar("DOB", "Added Succusfully");
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 5.0,
                                  height:
                                      MediaQuery.of(context).size.height / 28.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.orange[600],
                                  ),
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) => InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.orange[600],
        fontSize: MediaQuery.of(context).size.width / 22.0,
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.orange[600],
        ),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.orange[600],
        ),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
        color: Colors.orange[600],
      )));
}
