import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import '../models/task.dart';
import '../db/database_helpers.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _tasks = [];
  Map<LatLng, Task> _coordsMap;

  List<Task> get tasks {
    return _tasks;
  }

  Map<LatLng, Task> get coordsMap {
    return _coordsMap;
  }

  Future<bool> initializeTasks() async {
    _tasks = await DatabaseHelper.getAllTasks();
    _tasks.sort((a, b) => a.id.compareTo(b.id));
    _createCoordsMap(_tasks);
    return _tasks.length > 0;
  }

  Task findById(int id) {
    return _tasks.firstWhere((task) => task.id == id);
  }

  int getNewTaskId() {
    return _tasks.last.id + 1;
  }

  void addTask(Task newTask) {
    _tasks.add(newTask);

    DatabaseHelper.addTask(newTask).then(
      (success) => success
          ? print("New task with ID<${newTask.id}> added to database.")
          : print(
              "Error when attempting to add new task with ID<${newTask.id}> to database."),
    );

    notifyListeners();
  }

  void updateTask(Task updateTask) async {
    int index = _tasks.indexOf(updateTask);
    _tasks.removeAt(index);
    _tasks.insert(index, updateTask);

    DatabaseHelper.updateTask(updateTask).then(
      (success) => success
          ? print("Task with ID<${updateTask.id}> updated in database.")
          : print(
              "Error when attempting to update task with ID<${updateTask.id}> in database."),
    );

    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);

    DatabaseHelper.deleteTask(task).then(
      (success) => success
          ? print("Task with ID<${task.id}> removed from database.")
          : print(
              "Error when attempting to remove task with ID<${task.id}> from database."),
    );

    notifyListeners();
  }

  Map<LatLng, Task> _createCoordsMap(List<Task> tasks) {
    Map<LatLng, Task> tempCoordsMap = new Map<LatLng, Task>();
    for (Task task in tasks) {
      tempCoordsMap[task.coords] = task;
    }

    _coordsMap = tempCoordsMap;
  }
}
