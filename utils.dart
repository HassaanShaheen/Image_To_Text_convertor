// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.blueGrey.shade300,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 1,
    );
  }
}