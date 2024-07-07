import 'package:flutter/material.dart';
import 'dart:math';

import 'package:test_animation/screens/plant_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlantScreen(),
    );
  }
}
