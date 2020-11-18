import 'package:flutter/material.dart';
import 'package:geo_tasks/providers/tasks_provider.dart';
import 'package:provider/provider.dart';

import 'task_item.dart';

class TaskList extends StatelessWidget {
  TaskList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TasksProvider>(context).tasks;

    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return TaskItem(
          task: tasks[index],
        );
      },
    );
  }
}
