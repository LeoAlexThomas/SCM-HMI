import 'package:flutter/material.dart';

class SizeConfig {
  static late double screen_width;
  static late double screen_height;
  static late double font_height;

  static void initSizeConfig(context) {
    screen_width = MediaQuery.of(context).size.width / 100;
    screen_height = MediaQuery.of(context).size.height / 100;
    font_height = MediaQuery.of(context).size.height * 0.01;
  }
}
