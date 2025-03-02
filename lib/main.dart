import 'package:flutter/material.dart';
import 'pages/emission_calculator_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmissionCalculatorPage(),
    );
  }
}
