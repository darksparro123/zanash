import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/services/set_goal_service.dart';

class SetGoalDialog {
  TextEditingController steps = TextEditingController();
  final formKey = GlobalKey<FormState>();
  setGoalDialog(BuildContext context) {
    return Get.dialog(Dialog(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(35, 36, 70, 1),
          borderRadius: BorderRadius.circular(18.0),
        ),
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 24.0,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) => val.isEmpty ? "Set a goal" : null,
                  controller: steps,
                  decoration: InputDecoration(
                      labelText: "Steps",
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontSize: MediaQuery.of(context).size.width / 24.0,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber[700]),
                      )),
                ),
              ),
            ),
            MaterialButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    bool a = await SetGoal().setStepGoal(steps.text);
                    if (a) {
                      Navigator.pop(context);
                      Get.snackbar("Goal", "set succesfully");
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber[700],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    "Set a goal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  alignment: Alignment.center,
                ))
          ],
        ),
      ),
    ));
  }

  setWeightGoalDialog(BuildContext context) {
    return Get.dialog(Dialog(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(35, 36, 70, 1),
          borderRadius: BorderRadius.circular(18.0),
        ),
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: formKey,
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 24.0,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) => val.isEmpty ? "Set a goal" : null,
                  controller: steps,
                  decoration: InputDecoration(
                      labelText: "Kg's",
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontSize: MediaQuery.of(context).size.width / 24.0,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber[700]),
                      )),
                ),
              ),
            ),
            MaterialButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    bool a = await SetGoal().setWeightGoal(steps.text);
                    if (a) {
                      Navigator.pop(context);
                      Get.snackbar("Goal", "set succesfully");
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber[700],
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    "Set a goal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  alignment: Alignment.center,
                ))
          ],
        ),
      ),
    ));
  }
}
