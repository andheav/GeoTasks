import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_tasks/body/components/tasks/task_settings.dart';
import 'package:latlong/latlong.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

// ignore: must_be_immutable
class Task extends StatefulWidget {
  final int id;
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;
  Marker marker;
  // final ValueChanged<Task> updateTask;

  Task(
    this.id,
    String title,
    String description,
    LatLng coords,
  ) {
    this.title = title;
    this.description = description;
    this.marker = new Marker(
      point: coords,
      builder: (context) => new Container(
        child: Icon(
          Icons.pin_drop_sharp,
          size: 40.0,
          color: Colors.pink,
        ),
      ),
    );
  }

  getTitle() {
    return this.title;
  }

  setTitle(String title) {
    this.title = title;
  }

  getDescription() {
    return this.description;
  }

  setDescription(String description) {
    this.description = description;
  }

  getStartTime() {
    return this.startTime;
  }

  setStartTime(DateTime startTime) {
    this.startTime = startTime;
  }

  getEndTime() {
    return this.endTime;
  }

  setEndTime(DateTime endTime) {
    this.endTime = endTime;
  }

  _TaskState createState() => new _TaskState();
}

class _TaskState extends State<Task> {
  double fontSize = 20.0;
  double verticalSpacing = 15.0;
  String title;
  String description;
  Marker marker;

  void updateTitle(String title) {
    setState(() {
      this.title = title;
    });
  }

  void updateDescription(String description) {
    setState(() {
      this.description = description;
    });
  }

  void updateMarker(Marker marker) {
    setState(() {
      this.marker = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    updateTitle(widget.title);
    updateDescription(widget.description);
    updateMarker(widget.marker);

    return GestureDetector(
      onTap: () => {
        navigateToSettingsPage(context),
      },
      child: Container(
        margin: EdgeInsets.only(bottom: verticalSpacing),
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${widget.title}',
              style: TextStyle(fontSize: fontSize, color: kAltTextColor),
            ),
            SizedBox(width: 25.0),
            Text(
              '${widget.description.length <= 20 ? widget.description : widget.description.substring(0, 20) + '...'}',
              style: TextStyle(fontSize: fontSize - 6, color: kAltTextColor),
            ),
          ],
        ),
      ),
    );
  }

  navigateToSettingsPage(BuildContext context) async {
    final modifiedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskSettings(
          task: widget,
        ),
      ),
    ) as Task;

    updateTitle(modifiedTask.title);
    updateDescription(modifiedTask.description);
    updateMarker(modifiedTask.marker);
  }
}
