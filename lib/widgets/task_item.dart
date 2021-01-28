import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/task.dart';
import '../screens/task_settings_screen.dart';
import '../utils.dart';
import '../constants.dart';

// ignore: must_be_immutable
class TaskItem extends StatelessWidget {
  final double fontSize = 20.0;
  final double verticalSpacing = 10.0;

  final Task task;

  const TaskItem({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {
        navigateToTaskSettingsScreen(context),
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${this.task.title}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 5.0),
                      (() {
                        return displayDescription();
                      }()),
                      (() {
                        return displayDateAndTime();
                      }()),
                    ],
                  ),
                ),
                SizedBox(width: 75),
                Image(
                  height: 75,
                  width: 75,
                  image: AssetImage("images/map_thumbnail.png"),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  RenderObjectWidget displayDescription() {
    if (this.task.description != null && this.task.description != "") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${this.task.description}',
            style: TextStyle(color: kAltTextColor),
          ),
          SizedBox(height: 20.0),
        ],
      );
    } else {
      return SizedBox(height: 30.0);
    }
  }

  Widget displayDateAndTime() {
    if (this.task.startDate == this.task.endDate) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (() {
            if (this.task.anyTimeOfDay) {
              return Text(
                '${Utils.formatDate(this.task.startDate, shortened: true)}',
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Utils.formatDate(this.task.startDate, shortened: true)}',
                  ),
                  (() {
                    if (this.task.startTime == null ||
                        this.task.endTime == null) {
                      return SizedBox();
                    } else {
                      return Text(
                        '${Utils.formatTime(this.task.startTime)} — ${Utils.formatTime(this.task.endTime)}',
                      );
                    }
                  }()),
                ],
              );
            }
          }())
        ],
      );
    } else {
      if (this.task.anyTimeOfDay) {
        return Text(
            '${Utils.formatDate(this.task.startDate, shortened: true)} — ${Utils.formatDate(this.task.endDate, shortened: true)}');
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${Utils.formatDate(this.task.startDate, shortened: true)}    ${Utils.formatTime(this.task.startTime)} —'),
            Text(
                '${Utils.formatDate(this.task.endDate, shortened: true)}    ${Utils.formatTime(this.task.endTime)}'),
          ],
        );
      }
    }
  }

  navigateToTaskSettingsScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskSettingsScreen(taskId: this.task.id),
      ),
    );
  }
}
