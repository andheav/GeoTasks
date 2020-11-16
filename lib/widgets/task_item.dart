import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_tasks/screens/task_settings_screen.dart';

import '../constants.dart';

// ignore: must_be_immutable
class TaskItem extends StatelessWidget {
  final double fontSize = 20.0;
  final double verticalSpacing = 15.0;
  final int id;
  final String title;
  final String description;
  final Marker marker;

  const TaskItem({Key key, this.id, this.title, this.description, this.marker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        navigateToTaskSettingsScreen(context),
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
              '${this.title}',
              style: TextStyle(fontSize: fontSize, color: kAltTextColor),
            ),
            SizedBox(width: 25.0),
            Text(
              '${this.description.length <= 20 ? this.description : this.description.substring(0, 20) + '...'}',
              style: TextStyle(fontSize: fontSize - 6, color: kAltTextColor),
            ),
          ],
        ),
      ),
    );
  }

  navigateToTaskSettingsScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskSettingsScreen(taskId: this.id),
      ),
    );
  }
}
