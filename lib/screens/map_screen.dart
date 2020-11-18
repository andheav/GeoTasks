import 'package:flutter/material.dart';

import '../constants.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('GeoTasks'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        child: Center(
          child: Text('Map Screen'),
        ),
      ),
    );
  }
}
