import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../constants.dart';
import 'components/map/map.dart';
import 'components/tasks/task.dart';
import 'components/tasks/task_list.dart';

import '../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Task> tasks = List.from([
    new Task(1, 'Task 1', 'This is Task 1', new LatLng(42.493910, -90.679660)),
    new Task(2, 'Task 2', 'This is Task 2 and this is a long description',
        new LatLng(42.497162, -90.667300)),
    new Task(3, 'Task 3', 'This is Task 3', new LatLng(42.486951, -90.667071)),
    new Task(4, 'Task 4', 'This is Task 4', new LatLng(42.503996, -90.709987)),
    new Task(5, 'Task 5', 'This is Task 5', new LatLng(42.507497, -90.689502)),
    new Task(6, 'Task 6', 'This is Task 6', new LatLng(42.48328, -90.694537)),
  ]);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Map(
                      onLongPress: (LatLng latlng) => {},
                      taskMarkers: this.tasks.map((e) => e.marker).toList(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: constraints.maxHeight * 0.6 - 20,
                    ),
                    padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular((30.0)),
                      ),
                    ),
                    height: constraints.maxHeight * 0.4 + 20,
                    child: TaskList(
                      tasks: this.tasks,
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
