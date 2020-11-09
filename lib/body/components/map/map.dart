import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class Map extends StatefulWidget {
  Map({Key key, this.onLongPress, this.taskMarkers});

  final void Function(LatLng) onLongPress;
  final List<Marker> taskMarkers;

  @override
  _MapState createState() => new _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: new LatLng(42.493910, -90.679660),
        interactive: true,
        onLongPress: widget.onLongPress,
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
          markers: widget.taskMarkers == [] ? [] : widget.taskMarkers,
        ),
      ],
    );
  }

  onMapCreated() {}

  onMapClick() {}
}
