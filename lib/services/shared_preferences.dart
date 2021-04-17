import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefferencesServices {
//save user  profile picture
  static const String IMG_KEY = "IMAGE_KEY";
  //save image to prefferences method
  static Future<bool> saveImageToPrefferences(String value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.setString(IMG_KEY, value);
  }

//get image from preffrences method
  Future<String> getImageFromPreferences() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(IMG_KEY);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }

  //decode image
  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }
}
