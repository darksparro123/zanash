import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/screens/add_food_details_screen.dart';
import 'package:zaanassh/screens/add_foods.dart';
import 'package:zaanassh/services/save_daily_foods.dart';

class AddNutritients extends StatefulWidget {
  final String foodId;
  final String foodName;
  final String calories;
  final String meal;
  AddNutritients({
    @required this.foodId,
    @required this.foodName,
    @required this.calories,
    @required this.meal,
  });
  @override
  _AddNutritientsState createState() => _AddNutritientsState();
}

class _AddNutritientsState extends State<AddNutritients> {
  final formKey = GlobalKey<FormState>();
  TextEditingController carboHydrate = TextEditingController();
  TextEditingController protein = TextEditingController();
  TextEditingController fat = TextEditingController();
  TextEditingController saturatedFat = TextEditingController();
  TextEditingController transFat = TextEditingController();
  TextEditingController cholestrerol = TextEditingController();
  TextEditingController sodium = TextEditingController();
  TextEditingController potassium = TextEditingController();
  TextEditingController dietryFiber = TextEditingController();
  TextEditingController sugars = TextEditingController();
  TextEditingController vitaminA = TextEditingController();
  TextEditingController calcium = TextEditingController();
  TextEditingController vitaminC = TextEditingController();
  TextEditingController iron = TextEditingController();
  List<Map> nutrutentList = [];
  nav(int index) async {
    if (index == 1) {
      print("save clicked");
      setState(() {
        nutrutentList.add({"food_name": widget.foodName});
        nutrutentList.add({"carbohydrate": carboHydrate.text});
        nutrutentList.add({"fat": fat.text});
        nutrutentList.add({"protein": protein.text});
        nutrutentList.add({"satured_fat": saturatedFat.text});
        nutrutentList.add({"trans_fat": transFat.text});
        nutrutentList.add({"cholestrtol": cholestrerol.text});
        nutrutentList.add({"sodium": sodium.text});
        nutrutentList.add({"potasium": potassium.text});

        nutrutentList.add({"sugars": sugars.text});
        nutrutentList.add({"vitamin_a": vitaminA.text});
        nutrutentList.add({"vitamin_c": vitaminC.text});
        nutrutentList.add({"calcium": calcium.text});
        nutrutentList.add({"iron": iron.text});
      });
      print(nutrutentList);
      Get.to(() => AddFood(
            meal: "",
            nutitientsList: nutrutentList,
          ));
      /*bool a = await SaveFoodDetails()
          .setFood(widget.meal, nutrutentList, widget.calories);
      if (a) {
        Get.snackbar("Food Details", "Saved Succusfully");
        Get.to(() => AddFoodDetailsScreen());
      }*/
    } else {
      print("cancel clicked");
      setState(() {
        nutrutentList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        title: Text(
          "Add Nutritients",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0,
          ),
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                alignment: Alignment.center,
                child: Column(children: [
                  Text(
                    "Food : ${widget.foodName}",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: MediaQuery.of(context).size.width / 18.0),
                  ),
                  Text(
                    "Total Calories : ${widget.calories}",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: MediaQuery.of(context).size.width / 18.0),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Carbohydrate",
                      style: nutStyle(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: carboHydrate,
                              style: inpStyle(),
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "g",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total fat",
                      style: nutStyle(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: fat,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "g",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Protein",
                      style: nutStyle(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: protein,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "g",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Saturated Fat",
                      style: nutStyle(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: saturatedFat,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "g",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trains Fat",
                      style: nutStyle(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: transFat,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "g",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cholesterol",
                      style: nutStyle(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: cholestrerol,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "mg",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sodium",
                      style: nutStyle(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: TextFormField(
                                  style: inpStyle(),
                                  controller: sodium,
                                  decoration: inputDecoration(),
                                ),
                              ),
                            ),
                            Text(
                              "mg",
                              style: nutStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Potassium",
                      style: nutStyle(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: potassium,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "mg",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sugars",
                      style: nutStyle(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 100.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: sugars,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "g",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Vitamin A ",
                          style: nutStyle(),
                        ),
                        TextSpan(
                          text: "(100% = 5000IU ) ",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 8,
                    ),
                    SizedBox(
                      width: 75.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: vitaminA,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "%",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Vitamin C ",
                          style: nutStyle(),
                        ),
                        TextSpan(
                          text: "( 100% = 60mg) *",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 8,
                    ),
                    SizedBox(
                      width: 75.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: vitaminC,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "%",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Calcium ",
                          style: nutStyle(),
                        ),
                        TextSpan(
                          text: "( 100% = 100mg) *",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 75.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: calcium,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "%",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Iron ",
                          style: nutStyle(),
                        ),
                        TextSpan(
                          text: "( 100% = 18mg) *",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                    SizedBox(
                      width: 75.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: inpStyle(),
                              controller: iron,
                              decoration: inputDecoration(),
                            ),
                          ),
                          Text(
                            "%",
                            style: nutStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "* Percent Daily Values are based on a 2000 calorie diet.Your daily values may be higher or lower depending on your calorie needs.",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(35, 36, 70, 1),
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: nav,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.close,
                ),
                label: "Cancel"),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.save,
              ),
              label: "Save",
            ),
          ]),
    );
  }

  TextStyle nutStyle() => TextStyle(
        color: Colors.amber[900],
        fontSize: MediaQuery.of(context).size.width / 22.0,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w700,
        //backgroundColor: Colors.white.withOpacity(0.1),
      );
  TextStyle inpStyle() => TextStyle(
        color: Colors.white,
        fontSize: MediaQuery.of(context).size.width / 20.0,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w700,
      );
  InputDecoration inputDecoration() => InputDecoration(
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.amber,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      );
}
