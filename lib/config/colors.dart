import 'package:flutter/material.dart';

List<Map> projectColors = [
  {
    "name": "red",
    "color": "ed0c26",
  },
  {
    "name": "orange",
    "color": "f04e0e",
  },
  {
    "name": "green",
    "color": "32a852",
  },
  {
    "name": "yellow",
    "color": "f0e111",
  },
  {
    "name": "light-green",
    "color": "9bf011",
  },
  {
    "name": "teal",
    "color": "11f0b1",
  },
  {
    "name": "blue",
    "color": "1188f0",
  },
  {
    "name": "deep-blue",
    "color": "1127f0",
  },
  {
    "name": "voilet",
    "color": "6311f0",
  },
  {
    "name": "purple",
    "color": "970ced",
  },
  {
    "name": "pink",
    "color": "ed0c8f",
  },
];

Color covertColor(String rawCode) {
  int colorCode = int.parse('0xFF$rawCode');
  return Color(colorCode);
}

Color kscaffoldColor = const Color(0xFF171717);
Color kBackgroundColor = const Color(0xFF292929);
Color kCardColor = const Color.fromARGB(255, 53, 53, 53);

List randomColors = [
  Colors.deepOrange.shade600,
  Colors.pink.shade600,
  Colors.purple.shade600,
  Colors.green.shade600,
  Colors.red.shade600,
  Colors.orange.shade600,
  Colors.blue.shade600,
  Colors.teal.shade600,
  Colors.yellow.shade600,
  Colors.indigo.shade600,
  Colors.deepOrange.shade800,
  Colors.pink.shade800,
  Colors.green.shade800,
  Colors.blue.shade800,
  Colors.purple.shade800,
  Colors.orange.shade800,
  Colors.indigo.shade800,
  Colors.yellow.shade800,
  Colors.red.shade800,
  Colors.teal.shade800,
  Colors.purple.shade400,
  Colors.deepOrange.shade400,
  Colors.pink.shade400,
  Colors.blue.shade400,
  Colors.green.shade400,
  Colors.yellow.shade400,
  Colors.red.shade400,
  Colors.orange.shade400,
  Colors.indigo.shade400,
  Colors.teal.shade400,
  Colors.purple.shade700,
  Colors.deepOrange.shade700,
  Colors.pink.shade700,
  Colors.blue.shade700,
  Colors.green.shade700,
  Colors.yellow.shade700,
  Colors.red.shade700,
  Colors.orange.shade700,
  Colors.indigo.shade700,
  Colors.teal.shade700,
  Colors.purple.shade200,
  Colors.deepOrange.shade200,
  Colors.pink.shade200,
  Colors.blue.shade200,
  Colors.green.shade200,
  Colors.yellow.shade200,
  Colors.red.shade200,
  Colors.orange.shade200,
  Colors.indigo.shade200,
  Colors.teal.shade200,
  Colors.purple.shade900,
  Colors.deepOrange.shade900,
  Colors.pink.shade900,
  Colors.blue.shade900,
  Colors.green.shade900,
  Colors.yellow.shade900,
  Colors.red.shade900,
  Colors.orange.shade900,
  Colors.indigo.shade900,
  Colors.teal.shade900,
];
