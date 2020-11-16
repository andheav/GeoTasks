import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_tasks/providers/tasks_provider.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class Map extends StatelessWidget {
  Map({Key key, this.onLongPress, this.taskMarkers});

  final void Function(LatLng) onLongPress;
  List<Marker> taskMarkers;

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    final taskMarkers = tasksProvider.tasks.map((e) => e.marker).toList();

    if (this.taskMarkers == null) {
      this.taskMarkers = taskMarkers;
    }

    return FlutterMap(
      options: MapOptions(
        center: new LatLng(42.493910, -90.679660),
        interactive: true,
        onLongPress: this.onLongPress,
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
          markers: this.taskMarkers == [] ? [] : this.taskMarkers,
        ),
      ],
    );
  }
}
