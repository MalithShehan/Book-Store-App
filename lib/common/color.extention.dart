import 'package:flutter/material.dart';

class Tcolor {
  static Color get primary => const Color.fromARGB(255, 2, 116, 118);
  static Color get primartLight => const Color.fromARGB(255, 14, 191, 222);
  static Color get text => const Color.fromARGB(255, 26, 26, 26);
  static Color get subTitle => const Color.fromARGB(255, 100, 100, 100).withOpacity(0.4);


  static List<Color> get button => [
        const Color(0xff5ABDBC),
        const Color(0xffA4D8E1),
      ];

  static List<Color> get list => [
        const Color(0xff5ABDBC),
        const Color(0xffA4D8E1),
        const Color(0xffF2F2F2),
        const Color(0xffF2F2F2),
        const Color(0xffF2F2F2),
  ];
}