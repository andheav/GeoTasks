import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_tasks/providers/tasks_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

import '../utils.dart';
import '../models/task.dart';

class LocationProvider with ChangeNotifier {
  static Position userCurrentLocation;
  StreamSubscription<Position> positionStream;

  LocationProvider() {
    // Get User Current Location
    this.getUserLocation().then(
      (location) {
        if (location == null) {
          print("location is null");
        } else {
          print("current location: " +
              "${location.latitude}, " +
              "${location.longitude}");

          LocationProvider.userCurrentLocation = location;
        }
      },
    );
  }

  LatLng convertPositionToLatLng(Position data) {
    if (data == null) {
      return new LatLng(0.0, 0.0);
    } else {
      return new LatLng(data.latitude, data.longitude);
    }
  }

  void listenOnLocationChange() {
    if (positionStream == null) {
      positionStream = Geolocator.getPositionStream(
        intervalDuration: Duration(seconds: 5),
      ).listen((Position position) {
        userCurrentLocation = position;
        notifyListeners();

        print("location changed: $position");

        final Map<LatLng, Task> coordsMap = Utils.tasksProvider.coordsMap;
        if (coordsMap != null && coordsMap.length > 0) {
          for (LatLng coords in coordsMap.keys) {
            if (coordsMap[coords].notificationDistance <=
                this.getDistanceBetweenPoints(
                  position.latitude,
                  position.longitude,
                  coords.latitude,
                  coords.longitude,
                )) {
              print("Task ${coordsMap[coords].id} triggered!");
            }
          }
        }
      }, cancelOnError: true);
    }
  }

  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  double getDistanceToTask(Task task) {
    return Geolocator.distanceBetween(
        LocationProvider.userCurrentLocation.latitude,
        LocationProvider.userCurrentLocation.longitude,
        task.coords.latitude,
        task.coords.longitude);
  }

  double getDistanceBetweenPoints(
      double lat1, double long1, double lat2, double long2) {
    return Geolocator.distanceBetween(lat1, long1, lat2, long2);
  }
}
