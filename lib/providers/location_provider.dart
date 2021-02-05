import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geo_tasks/providers/tasks_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

import '../utils.dart';
import '../models/task.dart';

class LocationProvider with ChangeNotifier {
  static Position userCurrentLocation;
  StreamSubscription<Position> _positionStream;

  LocationProvider() {
    // Get User Current Location
    this._getUserLocation().then(
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
    if (_positionStream == null) {
      _positionStream = Geolocator.getPositionStream(
        intervalDuration: Duration(seconds: 5),
      ).listen((Position position) {
        userCurrentLocation = position;
        notifyListeners();

        print("location changed: $position");

        final Map<LatLng, Task> coordsMap = Utils.tasksProvider.coordsMap;
        if (coordsMap != null && coordsMap.length > 0) {
          for (LatLng coords in coordsMap.keys) {
            final distanceToTask = this._getDistanceBetweenPoints(
              position.latitude,
              position.longitude,
              coords.latitude,
              coords.longitude,
            );

            if (distanceToTask <= coordsMap[coords].notificationRadius) {
              final navigatorKey = GlobalKey<NavigatorState>();
              showAlertDialog(navigatorKey.currentState.overlay.context);
            }
          }
        }
      }, cancelOnError: true);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<Position> _getUserLocation() async {
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

  double _getDistanceToTask(Task task) {
    return Geolocator.distanceBetween(
        LocationProvider.userCurrentLocation.latitude,
        LocationProvider.userCurrentLocation.longitude,
        task.coords.latitude,
        task.coords.longitude);
  }

  double _getDistanceBetweenPoints(
      double lat1, double long1, double lat2, double long2) {
    return Geolocator.distanceBetween(lat1, long1, lat2, long2);
  }
}
