import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../constants.dart';
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

  void deleteTask(Task task) {
    _tasks.remove(task);

    DatabaseHelper.deleteTask(task).then(
      (success) => success
          ? print("Task with ID<${task.id}> removed from database.")
          : print(
              "Error when attempting to remove task with ID<${task.id}> from database."),
    );

    // _db.deleteTask(task.id).then(
    //       (success) => success
    //           ? 'Task ${task.id} removed from database.'
    //           : 'ERROR: Task ${task.id} could not be removed from database.',
    //     );

    notifyListeners();
  }

  Map<LatLng, Task> createCoordsMap(List<Task> tasks) {
    Map<LatLng, Task> tempCoordsMap = new Map<LatLng, Task>();
    for (Task task in tasks) {
      tempCoordsMap[task.coords] = task;
    }

    _coordsMap = tempCoordsMap;
  }

  void updateTaskTitle(int taskId, String newTitle) {
    _tasks.firstWhere((task) => task.id == taskId).title = newTitle;

    // _db.updateTaskLocation(taskId, newTitle).then(
    //       (success) => success
    //           ? 'Task $taskId title updated to $newTitle'
    //           : 'ERROR: Task $taskId title could not be updated',
    //     );

    notifyListeners();
  }

  void updateTaskDescription(int taskId, String newDescription) {
    _tasks.firstWhere((task) => task.id == taskId).description = newDescription;

    // _db.updateTaskLocation(taskId, newDescription).then(
    //       (success) => success
    //           ? 'Task $taskId description updated to $newDescription'
    //           : 'ERROR: Task $taskId description could not be updated',
    //     );

    notifyListeners();
  }

  void updateTaskCoords(int taskId, LatLng newCoords) {
    _tasks.firstWhere((task) => task.id == taskId).coords = newCoords;

    String coordsStr =
        newCoords.latitude.toString() + ',' + newCoords.longitude.toString();

    // _db.updateTaskLocation(taskId, coordsStr).then(
    //       (success) => success
    //           ? 'Task $taskId coords updated to $coordsStr'
    //           : 'ERROR: Task $taskId coords could not be updated',
    //     );

    notifyListeners();
  }

  // void updateTaskAnyTimeOfDay(int taskId, bool newValue) {
  //   _tasks.firstWhere((task) => task.id == taskId).anyTimeOfDay = newValue;

  //   _db.updateTaskAnyTimeOfDay(taskId, newValue.toString()).then(
  //         (success) => success
  //             ? 'Task $taskId AnyTimeOfDay updated to ${newValue.toString()}'
  //             : 'ERROR: Task $taskId AnyTimeOfDay could not be updated',
  //       );

  //   notifyListeners();
  // }

  // void updateTaskAnyTime(int taskId, bool newValue) {
  //   _tasks.firstWhere((task) => task.id == taskId).anyTime = newValue;

  //   _db.updateTaskAnyTime(taskId, newValue.toString()).then(
  //         (success) => success
  //             ? 'Task $taskId AnyTime updated to ${newValue.toString()}}'
  //             : 'ERROR: Task $taskId AnyTime could not be updated',
  //       );

  //   notifyListeners();
  // }

  // void updateTaskStartDate(int taskId, DateTime newDate) {
  //   _tasks.firstWhere((task) => task.id == taskId).startDate = newDate;

  //   _db.updateTaskStartDate(taskId, newDate.toIso8601String()).then(
  //         (success) => success
  //             ? 'Task $taskId StartDate updated to ${newDate.toIso8601String()}}'
  //             : 'ERROR: Task $taskId StartDate could not be updated',
  //       );

  //   notifyListeners();
  // }

  // void updateTaskStartTime(int taskId, TimeOfDay newTime) {
  //   _tasks.firstWhere((task) => task.id == taskId).startTime = newTime;

  //   _db.updateTaskStartTime(taskId, newTime.toString()).then(
  //         (success) => success
  //             ? 'Task $taskId StartTime updated to ${newTime.toString()}}'
  //             : 'ERROR: Task $taskId StartTime could not be updated',
  //       );

  //   notifyListeners();
  // }

  // void updateTaskEndDate(int taskId, DateTime newDate) {
  //   _tasks.firstWhere((task) => task.id == taskId).endDate = newDate;

  //   _db.updateTaskStartDate(taskId, newDate.toIso8601String()).then(
  //         (success) => success
  //             ? 'Task $taskId EndDate updated to ${newDate.toIso8601String()}}'
  //             : 'ERROR: Task $taskId EndDate could not be updated',
  //       );
  //   notifyListeners();
  // }

  // void updateTaskEndTime(int taskId, TimeOfDay newTime) {
  //   _tasks.firstWhere((task) => task.id == taskId).endTime = newTime;

  //   _db.updateTaskStartTime(taskId, newTime.toString()).then(
  //         (success) => success
  //             ? 'Task $taskId EndTime updated to ${newTime.toString()}}'
  //             : 'ERROR: Task $taskId EndTime could not be updated',
  //       );

  //   notifyListeners();
  // }

  // void updateTaskLocation(int taskId, String newLocation) {
  //   _tasks.firstWhere((task) => task.id == taskId).location = newLocation;

  //   _db.updateTaskLocation(taskId, newLocation).then((success) => {
  //         print("$taskId updated: $success"),
  //         success
  //             ? 'Task $taskId location updated to $newLocation'
  //             : 'ERROR: Task $taskId location could not be updated'
  //       });

  //   notifyListeners();
  // }

  void updateTaskNotificationRadius(int taskId, double notificationDistance) {
    _tasks.firstWhere((task) => task.id == taskId).notificationRadius =
        notificationDistance;

    // _db
    //     .updateTaskNotificationDistance(taskId, notificationDistance.toString())
    //     .then((success) => {
    //           print("$taskId updated: $success"),
    //           success
    //               ? 'Task $taskId location updated to $notificationDistance'
    //               : 'ERROR: Task $taskId location could not be updated'
    //         });

    notifyListeners();
  }
}
