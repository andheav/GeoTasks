import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_tasks/constants.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/foundation.dart';

class Task {
  int id;
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;
  LatLng coords;
  Marker marker;

  Task({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.coords,
  }) {
    this.marker = new Marker(
      point: this.coords,
      builder: (context) => new Container(
        child: Icon(
          Icons.pin_drop_sharp,
          size: 40.0,
          color: kMarkerColor,
        ),
      ),
    );
  }
}
