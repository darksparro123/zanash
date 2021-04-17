import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zaanassh/services/set_goal_service.dart';

class SetGoalDialog1 {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  setGoalDialog(BuildContext context, String dialog) {
    return Get.dialog(Dialog(
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Form(
          key: formKey,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: MediaQuery.of(context).size.height / 5,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 25.0),
                    controller: controller,
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val.isEmpty ? "Please enter a value" : null,
                    decoration: InputDecoration(
                      labelText: (dialog == "steps")
                          ? "Enter Steps"
                          : (dialog == "weight")
                              ? "Enter Weight"
                              : "Enter Calories",
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 25.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amber[800],
                        ),
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amber[800],
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amber[800],
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                    onPressed: () async {
                      bool a = false;
                      bool b = false;
                      bool c = false;
                      if (dialog == "steps") {
                        a = await SetGoal().setStepGoal(controller.text);
                      } else if (dialog == "weight") {
                        b = await SetGoal().setWeightGoal(controller.text);
                      } else {
                        c = await SetGoal().setcalorieGoal(controller.text);
                      }
                      if (a || b || c) {
                        print("added sucussfully");
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orange[700],
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 20,
                        alignment: Alignment.center,
                        child: Text("Update",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 25.0))))
              ],
            ),
          ),
        )));
  }
}
