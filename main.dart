import 'package:flutter/material.dart';
import 'package:semesterproject/Image_text.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: 'image_text',
    routes: {
      'image_text': (context)=>const Image_to_text(),
    },
  ));
}