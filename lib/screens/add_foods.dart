import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/add_nutritients.dart';
import 'package:zaanassh/screens/navigation_bar.dart';
import 'package:zaanassh/services/save_daily_foods.dart';

class AddFood extends StatefulWidget {
  final String meal;
  final List<Map> nutitientsList;
  AddFood({@required this.meal, this.nutitientsList});
  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  List<Widget> foodList = [];
  List<Map> foodData = [];
  String food1 = "";
  String food2 = "";
  String food3 = "";
  String food4 = "";
  String food5 = "";
  String food6 = "";
  String food7 = "";

  String calories1 = "0";
  String calories2 = "0";
  String calories3 = "0";
  String calories4 = "0";
  String calories5 = "0";
  String calories6 = "0";
  String calories7 = "0";
  @override
  void initState() {
    setFoodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        title: Text(
          "Add Food Items",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width / 22.0),
            ),
            onPressed: () async {
              int totalColries = 0;
              setState(() {
                foodData.add({"food1_name": food1, "calories1": calories1});
                foodData.add({"food2_name": food2, "calories2": calories2});
                foodData.add({"food3_name": food3, "calories3": calories3});
                foodData.add({"food4_name": food4, "calories4": calories4});
                foodData.add({"food5_name": food5, "calories5": calories5});
                foodData.add({"food6_name": food6, "calories6": calories6});
                foodData.add({"food7_name": food7, "calories7": calories7});

                totalColries = int.parse(calories1) +
                    int.parse(calories2) +
                    int.parse(calories3) +
                    int.parse(calories4) +
                    int.parse(calories5) +
                    int.parse(calories6) +
                    int.parse(calories7);
              });
              bool a = await SaveFoodDetails()
                  .setFood(widget.meal, foodData, totalColries.toString());
              if (a) {
                Get.to(() => NavigationBarScreen());
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 20.0,
                ),
                child: Text(
                  "Food",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 1.4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            (food1 == "") ? "Food 01" : food1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 50.0,
                          ),
                          (calories1 == "0")
                              ? IconButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    foodName.text = "";
                                    calories.text = "";
                                    Get.dialog(alertDialog(1));
                                  },
                                  icon: Icon(Icons.add),
                                )
                              : Text(
                                  "$calories1 KCal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                )
                        ],
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.4),
                        child: SizedBox(
                          height: 1.0,
                          width: 400,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            (food2 == "") ? "Food 02" : food2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 50.0,
                          ),
                          (calories2 == "0")
                              ? IconButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    foodName.text = "";
                                    calories.text = "";
                                    Get.dialog(alertDialog(2));
                                  },
                                  icon: Icon(Icons.add),
                                )
                              : Text(
                                  "$calories2 KCal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                )
                        ],
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.4),
                        child: SizedBox(
                          height: 1.0,
                          width: 400,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            (food3 == "") ? "Food 03" : food3,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 50.0,
                          ),
                          (calories3 == "0")
                              ? IconButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    foodName.text = "";
                                    calories.text = "";
                                    Get.dialog(alertDialog(3));
                                  },
                                  icon: Icon(Icons.add),
                                )
                              : Text(
                                  "$calories3 KCal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                )
                        ],
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.4),
                        child: SizedBox(
                          height: 1.0,
                          width: 400,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            (food4 == "") ? "Food 04" : food4,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 50.0,
                          ),
                          (calories4 == "0")
                              ? IconButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    foodName.text = "";
                                    calories.text = "";
                                    Get.dialog(alertDialog(4));
                                  },
                                  icon: Icon(Icons.add),
                                )
                              : Text(
                                  "$calories4 KCal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                )
                        ],
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.4),
                        child: SizedBox(
                          height: 1.0,
                          width: 400,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            (food5 == "") ? "Food 05" : food5,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 50.0,
                          ),
                          (calories5 == "0")
                              ? IconButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    foodName.text = "";
                                    calories.text = "";
                                    Get.dialog(alertDialog(5));
                                  },
                                  icon: Icon(Icons.add),
                                )
                              : Text(
                                  "$calories5 KCal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                )
                        ],
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.4),
                        child: SizedBox(
                          height: 1.0,
                          width: 400,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            (food6 == "") ? "Food 06" : food6,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 50.0,
                          ),
                          (calories6 == "0")
                              ? IconButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    foodName.text = "";
                                    calories.text = "";
                                    Get.dialog(alertDialog(6));
                                  },
                                  icon: Icon(Icons.add),
                                )
                              : Text(
                                  "$calories6 KCal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                )
                        ],
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.4),
                        child: SizedBox(
                          height: 1.0,
                          width: 400,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            (food7 == "") ? "Food 07" : food7,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                          SizedBox(
                            width: 50.0,
                          ),
                          (calories7 == "0")
                              ? IconButton(
                                  color: Colors.orange,
                                  onPressed: () {
                                    foodName.text = "";
                                    calories.text = "";
                                    Get.dialog(alertDialog(7));
                                  },
                                  icon: Icon(Icons.add),
                                )
                              : Text(
                                  "$calories7 KCal",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                )
                        ],
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.4),
                        child: SizedBox(
                          height: 1.0,
                          width: 400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setFoodList() {
    for (int i = 1; i < 8; i++) {
      setState(() {
        foodList.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Food $i",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                  ),
                  IconButton(
                    color: Colors.orange,
                    onPressed: () {},
                    icon: Icon(Icons.add),
                  )
                ],
              ),
              Container(
                color: Colors.white.withOpacity(0.4),
                child: SizedBox(
                  height: 1.0,
                  width: 400,
                ),
              )
            ],
          ),
        ));
      });
    }
  }

  TextEditingController foodName = TextEditingController();
  TextEditingController calories = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Widget alertDialog(int index) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 1.9,
          decoration: BoxDecoration(
            color: Color.fromRGBO(35, 36, 70, 1),
            borderRadius: BorderRadius.circular(
              18.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "fill this field" : null,
                        controller: foodName,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Food name",
                          labelStyle: TextStyle(
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                      Container(
                          color: Colors.white.withOpacity(0.2),
                          child: SizedBox(
                            height: 1.0,
                            width: MediaQuery.of(context).size.width / 1.3,
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? "fill this field" : null,
                        controller: calories,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Calories",
                          labelStyle: TextStyle(
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                      Container(
                          color: Colors.white.withOpacity(0.2),
                          child: SizedBox(
                            height: 1.0,
                            width: MediaQuery.of(context).size.width / 1.3,
                          )),
                    ],
                  ),
                  /* MaterialButton(
                    onPressed: () {
                      /* if (formKey.currentState.validate()) {
                        Get.to(
                          () => AddNutritients(
                            foodId: index.toString(),
                            foodName: foodName.text,
                            calories: calories.text,
                            meal: widget.meal,
                          ),
                        );
                      }*/

                      switch (index) {
                        case 1:
                          setState(() {
                            food1 = foodName.text;
                            calories1 = calories.text;
                          });
                          break;
                        case 2:
                          setState(() {
                            food2 = foodName.text;
                            calories2 = calories.text;
                          });
                          break;
                        case 3:
                          setState(() {
                            food3 = foodName.text;
                            calories3 = calories.text;
                          });
                          break;
                        case 4:
                          setState(() {
                            food4 = foodName.text;
                            calories4 = calories.text;
                          });
                          break;
                        case 5:
                          setState(() {
                            food5 = foodName.text;
                            calories5 = calories.text;
                          });
                          break;
                        case 6:
                          setState(() {
                            food6 = foodName.text;
                            calories6 = calories.text;
                          });

                          break;
                        case 7:
                          setState(() {
                            food7 = foodName.text;
                            calories7 = calories.text;
                          });
                          break;
                        default:
                          print("invalid id");
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange[800],
                          borderRadius: BorderRadius.circular(18.0)),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.height / 15.0,
                      alignment: Alignment.start,
                      child: Text(
                        "Add nutritients",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 23,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),*/
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: MediaQuery.of(context).size.height / 15.0,
                          decoration: BoxDecoration(
                            color: Colors.orange[600],
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width / 22.0,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          switch (index) {
                            case 1:
                              setState(() {
                                food1 = foodName.text;
                                calories1 = calories.text;
                              });
                              break;
                            case 2:
                              setState(() {
                                food2 = foodName.text;
                                calories2 = calories.text;
                              });
                              break;
                            case 3:
                              setState(() {
                                food3 = foodName.text;
                                calories3 = calories.text;
                              });
                              break;
                            case 4:
                              setState(() {
                                food4 = foodName.text;
                                calories4 = calories.text;
                              });
                              break;
                            case 5:
                              setState(() {
                                food5 = foodName.text;
                                calories5 = calories.text;
                              });
                              break;
                            case 6:
                              setState(() {
                                food6 = foodName.text;
                                calories6 = calories.text;
                              });

                              break;
                            case 7:
                              setState(() {
                                food7 = foodName.text;
                                calories7 = calories.text;
                              });
                              break;
                            default:
                              print("invalid id");
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: MediaQuery.of(context).size.height / 15.0,
                          decoration: BoxDecoration(
                            color: Colors.orange[600],
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width / 22.0,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
