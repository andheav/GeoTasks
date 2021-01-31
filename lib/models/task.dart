import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/foundation.dart';

import '../constants.dart';
import '../db/database_helpers.dart' as db;

class Task {
  int id;
  String title;
  String description;
  LatLng coords;
  Marker marker;
  double notificationRadius;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool anyTimeOfDay;
  bool anyTime;
  String location;
  

  Task.emptyTask() {
    this.id = -1;
    this.title = "";
    this.description = "";
    this.coords = null;
    this.marker = null;
    this.notificationRadius = 1.0;
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
          Icons.place,
          size: kMarkerSize,
          color: kMarkerColor,
        ),
      ),
    );
    this.notificationRadius = 1.0;
  }

  Task.fromMap(Map<String, dynamic> map) {
    this.id = map[db.columnId];
    this.title = map[db.columnTitle];
    this.description = map[db.columnDescription];
    this.coords = parseLatLngString(
      map[db.columnCoords] != null
        ? map[db.columnCoords]
        : '0.0,0.0');
    this.notificationRadius = 
      map[db.columnNotificationRadius] != null
        ? map[db.columnNotificationRadius]
        : -1.0;
    
    this.marker = new Marker(
      point: this.coords,
      builder: (context) => new Container(
        child: Icon(
          Icons.place,
          size: kMarkerSize,
          color: kMarkerColor,
        ),
      ),
    );
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      db.columnId: this.id,
      db.columnTitle: this.title,
      db.columnDescription: this.description,
      db.columnCoords: '${this.coords.latitude},${this.coords.longitude}',
      db.columnNotificationRadius: this.notificationRadius,
    };
    return map;
  }

  LatLng parseLatLngString(String latlng) {
    List<String> latAndLngArray = latlng.split(',');
    String lat = latAndLngArray[0];
    String lng = latAndLngArray[1];
    return new LatLng(double.parse(lat), double.parse(lng));
  }
}
