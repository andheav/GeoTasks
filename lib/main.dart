import 'package:flutter/material.dart';
import 'package:geo_tasks/constants.dart';
import 'package:geo_tasks/screens/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'GeoTasks',
      theme: ThemeData(primaryColor: kPrimaryColor),
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('GeoTasks'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: HomeScreen(),
    );
  }
}

// Uses Cases/Features:
// - If I am within 5 miles of Discount Tire between the hours of X - X, then notify me
// - Ping user when their car is in motion (Did you remember to do this?)