import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:zaanassh/screens/user_challenges.dart';
import 'package:zaanassh/services/create_challenge_service.dart';

class CreateChallengeScreen extends StatefulWidget {
  @override
  _CreateChallengeScreenState createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  String challengeType = "Public";
  bool type = false;
  bool imagePicked = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  int count = 1;
  int steps = 4000;
  String day;
  void setCount(bool t) {
    if (t) {
      setState(() {
        count++;
      });
    } else {
      setState(() {
        count--;
      });
      if (count < 0) {
        setState(() {
          count = 1;
        });
      }
    }
  }

  void setStepCount(bool t) {
    if (t) {
      setState(() {
        steps += 500;
      });
    } else {
      setState(() {
        steps -= 500;
      });
      if (steps < 2000) {
        setState(() {
          steps = 2000;
        });
      }
    }
  }

  //setChallengType
  void setChallengeType(bool type) {
    if (type) {
      setState(() {
        challengeType = "Public";
      });
    } else {
      setState(() {
        challengeType = "Only Friends";
      });
    }
  }

  String setDate(int count) {
    DateTime tomorrow = DateTime.now().add(Duration(days: count));
    setState(() {
      day = DateFormat("dd/MM/yy").format(tomorrow);
    });
    return day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        title: Text("Create Challenges"),
        centerTitle: true,
        actions: [],
      ),
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$challengeType",
                        style: TextStyle(
                          color: Colors.orange[600],
                          fontSize: MediaQuery.of(context).size.height / 40,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.height / 30.0,
                        child: SwitcherButton(
                          onColor: Colors.orange[600],
                          value: true,
                          onChange: (value) {
                            print(value);
                            setState(() {
                              type = value;
                            });
                            setChallengeType(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  (!imagePicked)
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pick an image to challenge",
                              style: textStyle(),
                            ),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.fileImage),
                              color: Colors.amber[600],
                              onPressed: () {},
                            ),
                          ],
                        )
                      : SizedBox(
                          width: 0,
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: name,
                      validator: (val) =>
                          val.isEmpty ? "Give a name to challenge" : null,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 22.0,
                      ),
                      decoration: inputDecoration("Challenge Name"),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      controller: description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 22.0,
                      ),
                      decoration: inputDecoration("Challenge Details"),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        color: Colors.amber[600],
                        onPressed: () {
                          setCount(false);
                        },
                        icon: Icon(
                          Icons.arrow_left,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            setDate(count),
                            style: textStyle(),
                          ),
                          Text(
                            "Challenge Date",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize:
                                  MediaQuery.of(context).size.height / 45.0,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        color: Colors.amber[600],
                        onPressed: () {
                          setCount(true);
                        },
                        icon: Icon(
                          Icons.arrow_right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        color: Colors.amber[600],
                        onPressed: () {
                          setStepCount(false);
                        },
                        icon: Icon(
                          Icons.arrow_left,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "$steps steps",
                            style: textStyle(),
                          ),
                          Text(
                            "Goal",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize:
                                  MediaQuery.of(context).size.height / 45.0,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        color: Colors.amber[600],
                        onPressed: () {
                          setStepCount(true);
                        },
                        icon: Icon(
                          Icons.arrow_right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 12,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        bool a = await CreateChallenge().createChallenge(
                            name.text, description.text, type, day, steps);
                        if (a) {
                          Get.snackbar("Challenge", "Created Succusfully");
                          Future.delayed(Duration(seconds: 3))
                              .then((value) => Get.to(UserChallengsScreen()));
                        }
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange[600],
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        width: MediaQuery.of(context).size.width / 2.0,
                        height: MediaQuery.of(context).size.height / 20.0,
                        alignment: Alignment.center,
                        child: Text(
                          "Create Challenge",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height / 40.0,
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle textStyle() => TextStyle(
        color: Colors.orange[600],
        fontSize: MediaQuery.of(context).size.height / 40,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w500,
      );
  InputDecoration inputDecoration(String label) => InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey[600],
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
