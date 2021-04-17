import 'package:flutter/material.dart';
import 'package:zaanassh/models/messurement_model.dart';

class UnitMessurementScreen extends StatefulWidget {
  @override
  _UnitMessurementScreenState createState() => _UnitMessurementScreenState();
}

class _UnitMessurementScreenState extends State<UnitMessurementScreen> {
  MesurementModel mesurementModel = MesurementModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 20, 41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 20, 41, 1),
        title: Text("unit of mesurement"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 10,
        ),
        child: ListView.builder(
          itemCount: mesurementModel.mesurementList.length,
          itemBuilder: (context, index) {
            return MaterialButton(
              onPressed: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 35.0),
                    child: Text(
                      mesurementModel.mesurementList[index]["mesurement_name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 22.0,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey[500].withOpacity(0.6),
                    child: SizedBox(
                      height: 0.1,
                      width: MediaQuery.of(context).size.width / 1.05,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
