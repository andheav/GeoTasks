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
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool anyTimeOfDay;
  bool anyTime;
  LatLng coords;
  String location;
  Marker marker;
  double notificationDistance;

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
    this.location = "";
    this.marker = null;
    this.notificationDistance = 1.0;
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
    this.anyTime = false;
    this.anyTimeOfDay = false;
    this.startDate = DateTime.now();
    this.endDate = DateTime.now();
    this.startTime = TimeOfDay.now();
    this.endTime = TimeOfDay.now();
    this.notificationDistance = 1.0;
    this.location = "";
  }

  Task.fromMap(Map<String, dynamic> map) {
    this.id = map[db.columnId];
    this.title = map[db.columnTitle];
    this.description = map[db.columnDescription];
    this.startDate = DateTime.parse(
      map[db.columnStartDate] != null
          ? map[db.columnStartDate]
          : DateTime.now().toIso8601String(),
    );
    this.endDate = DateTime.parse(
      map[db.columnEndDate] != null
          ? map[db.columnEndDate]
          : DateTime.now().toIso8601String(),
    );
    this.startTime = parseTimeOfDayString(map[db.columnStartTime]);
    this.endTime = parseTimeOfDayString(map[db.columnEndTime]);
    this.anyTimeOfDay = 'true' ==
        (map[db.columnAnyTimeOfDay] != null
            ? map[db.columnAnyTimeOfDay].toLowerCase()
            : 'false');
    this.anyTime = 'true' ==
        (map[db.columnAnyTime] != null
            ? map[db.columnAnyTime].toLowerCase()
            : 'false');
    this.coords = parseLatLngString(map[db.columnCoords] != null
        ? map[db.columnCoords]
        : "LatLng(latitude: 0.0, longitude: 0.0)");
    this.notificationDistance = double.parse(
        map[db.columnNotificationDistance] != null
            ? map[db.columnNotificationDistance]
            : "1000000.0");
    this.location = map[db.columnLocation];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      db.columnId: this.id,
      db.columnTitle: this.title,
      db.columnDescription: this.description,
      db.columnStartDate: this.startDate.toIso8601String(),
      db.columnEndDate: this.endDate.toIso8601String(),
      db.columnStartTime: this.startTime.toString(),
      db.columnEndTime: this.endTime.toString(),
      db.columnAnyTimeOfDay: this.anyTimeOfDay.toString(),
      db.columnAnyTime: this.anyTime.toString(),
      db.columnCoords: this.coords.toString(),
      db.columnNotificationDistance: this.notificationDistance.toString(),
      db.columnLocation: this.location
    };
    return map;
  }

  TimeOfDay parseTimeOfDayString(String tod) {
    if (tod != null) {
      String time = tod.split('(')[1];
      time = time.replaceAll(')', '');
      return TimeOfDay(
        hour: int.parse(time.split(":")[0]),
        minute: int.parse(time.split(":")[1]),
      );
    } else {
      return TimeOfDay.now();
    }
  }

  LatLng parseLatLngString(String latlng) {
    latlng = latlng.split('(')[1];
    latlng = latlng.replaceAll(')', '');
    List<String> latAndLngArray = latlng.split(', ');
    int latIndex = latAndLngArray[0].indexOf('latitude:') + 'latitude:'.length;
    int lngIndex =
        latAndLngArray[1].indexOf('longitude:') + 'longitude:'.length;
    String lat = latAndLngArray[0].substring(latIndex);
    String lng = latAndLngArray[1].substring(lngIndex);
    return new LatLng(double.parse(lat), double.parse(lng));
  }
}
