import 'package:flutter/material.dart';

class ConbtactUs extends StatefulWidget {
  @override
  _ConbtactUsState createState() => _ConbtactUsState();
}

class _ConbtactUsState extends State<ConbtactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      appBar: AppBar(
        title: Text(
          "Cotact Us",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(35, 36, 70, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You can contact us from contact@zannash.com.",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20.0),
              )
            ]),
      ),
    );
  }
}
