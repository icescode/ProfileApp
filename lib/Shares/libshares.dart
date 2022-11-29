import 'package:flutter/material.dart';

class MyCustomColor {
  static green() {
    return const Color.fromARGB(160, 148, 244, 194);
  }

  static greenDeep() {
    return const Color.fromARGB(95, 106, 221, 169);
  }

  static gray() {
    return const Color.fromARGB(159, 49, 51, 50);
  }

  //rgb(37, 150, 190)
  static blue() {
    return const Color.fromARGB(255, 93, 212, 255);
  }

  static grayLight() {
    return const Color.fromARGB(39, 40, 38, 38);
  }

  static grayDeep() {
    const Color.fromARGB(255, 48, 47, 47);
  }

  static size28() {
    double retval = 28.00;
    return retval;
  }
}

/*
  static const double fontHuge = 64.0;
  static const double fontBig = 32.0;
  static const double fontMedium = 24.0;
  static const double fontStandar = 20.0;
  static const double miniDivider = 20.0;
  static const double bigDivider = 100.0;

*/
class MyFontSize {
  static fontHuge() {
    return 64.00;
  }

  static fontBig() {
    return 32.00;
  }

  static fontMedium() {
    return 24.00;
  }

  static fontStandar() {
    return 20.00;
  }

  static fontNormal() {
    return 18.00;
  }

  static fontSmall() {
    return 14.00;
  }
}
