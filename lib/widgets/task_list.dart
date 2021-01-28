import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

import '../models/task.dart';
import '../utils.dart';
import '../widgets/task_item.dart';

class TaskList extends StatefulWidget {
  TaskList({Key key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final tasksProvider = Utils.tasksProvider;
  List<Task> tasks;

  Future<bool> tasksInitialized;

  @override
  void initState() {
    super.initState();

    // Retrieve tasks from database
    tasksInitialized = Utils.tasksProvider.initializeTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([tasksInitialized]),
        builder: (context, AsyncSnapshot<List<bool>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              padding: EdgeInsets.all(15),
              itemCount: Utils.tasksProvider.tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskItem(
                  task: Utils.tasksProvider.tasks[index],
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
