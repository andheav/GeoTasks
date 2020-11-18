import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_tasks/constants.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/foundation.dart';

class Task {
  int id;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool anyTimeOfDay;
  bool anyTime;
  LatLng coords;
  Marker marker;

  Task.emptyTask() {
    this.id = -1;
    this.title = "";
    this.description = "";
    this.startDate = DateTime.now();
    this.endDate = DateTime.now();
    this.startTime = TimeOfDay.now();
    this.endTime = TimeOfDay.now();
    this.anyTimeOfDay = false;
    this.anyTime = true;
    this.coords = null;
    this.marker = null;
  }

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
    this.anyTime = false;
    this.anyTimeOfDay = false;
  }
}
