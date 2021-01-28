import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../providers/location_provider.dart';
import '../utils.dart';
import '../constants.dart';
import '../models/task.dart';

class Map extends StatefulWidget {
  Map({
    Key key,
    this.onLongPress,
    this.taskId,
    this.notificationDistanceNotifier,
  });

  final void Function(LatLng) onLongPress;
  final int taskId;
  final ValueNotifier notificationDistanceNotifier;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  List<Marker> _taskMarkers = [];
  List<CircleMarker> _circleMarkers = [];
  double _zoom = 13.0;

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Utils.tasksProvider;
    final locationProvider = Utils.locationProvider;

    if (this.widget.taskId != null) {
      final task = tasksProvider.findById(this.widget.taskId);

      this._taskMarkers.add(task.marker);
      this._circleMarkers.add(
            new CircleMarker(
                point: task.coords,
                color: kMarkerColor.withOpacity(0.15),
                borderStrokeWidth: 3.0,
                borderColor: kMarkerColor,
                radius: task.notificationDistance * 1609.34,
                useRadiusInMeter: true),
          );
    }

    _addUserCurrentLocationMarker(locationProvider);

    return ValueListenableBuilder(
      valueListenable: this.widget.notificationDistanceNotifier,
      builder: (BuildContext context, value, Widget child) {
        if (this._circleMarkers.isNotEmpty) {
          this._circleMarkers = [
            new CircleMarker(
                point: this._circleMarkers[0].point,
                color: kMarkerColor.withOpacity(0.15),
                borderStrokeWidth: 3.0,
                borderColor: kMarkerColor,
                radius: value * 1609.34,
                useRadiusInMeter: true),
          ];
        }

        return FlutterMap(
          options: MapOptions(
            center: locationProvider.convertPositionToLatLng(
              LocationProvider.userCurrentLocation,
            ),
            zoom: _zoom,
            interactive: true,
            onPositionChanged: (position, hasGesture) {
              // zoom is 13.0 by default
              if (hasGesture && position.zoom != _zoom) {
                setState(() {
                  _zoom = position.zoom;
                });
              }
            },
            onLongPress: (LatLng coords) {
              this.widget.onLongPress(coords);
              setState(() {
                this._taskMarkers = [
                  new Marker(
                    point: coords,
                    builder: (context) => new Container(
                      child: Icon(
                        Icons.place,
                        size: kMarkerSize,
                        color: kMarkerColor,
                      ),
                    ),
                  ),
                ];

                this._circleMarkers = [
                  new CircleMarker(
                    point: coords,
                    color: kMarkerColor.withOpacity(0.15),
                    borderStrokeWidth: 3.0,
                    borderColor: kMarkerColor,
                    radius: value * 1609.34,
                    useRadiusInMeter: true,
                  ),
                ];
              });
            },
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/andheav/ckgpv6ndq4p4f19pmmxbb2var/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW5kaGVhdiIsImEiOiJja2Z4OXZrejExYjNkMnFtdHA2MDhxc2RuIn0.KFVljV08oJ4BWf5jOiOLYA',
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoiYW5kaGVhdiIsImEiOiJja2Z4OXZrejExYjNkMnFtdHA2MDhxc2RuIn0.KFVljV08oJ4BWf5jOiOLYA',
                'id': 'mapbox.mapbox-streets-v7'
              },
            ),
            new MarkerLayerOptions(
              markers: this._taskMarkers,
            ),
            new CircleLayerOptions(
              circles: this._circleMarkers,
            )
          ],
        );
      },
    );
  }

  void _addUserCurrentLocationMarker(LocationProvider locationProvider) {
    this._taskMarkers.add(
          new Marker(
            point: locationProvider
                .convertPositionToLatLng(LocationProvider.userCurrentLocation),
            builder: (context) => new Container(
              child: Icon(
                Icons.circle,
                size: 20.0,
                color: Colors.lightBlue,
              ),
            ),
          ),
        );
  }
}
