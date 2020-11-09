import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'task.dart';

class TaskList extends StatelessWidget {
  TaskList({Key key, this.tasks}) : super(key: key);

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(15),
        itemCount: this.tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(child: this.tasks[index]),
          );
        });
  }
}
