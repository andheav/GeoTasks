import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../constants.dart';
import '../models/task.dart';
import '../db/database_helpers.dart';

class TasksProvider with ChangeNotifier {
  DatabaseHelper _db;

  List<Task> _tasks = [];
  Map<LatLng, Task> _coordsMap;

  TasksProvider() {
    _db = DatabaseHelper.instance;
  }

  List<Task> get tasks {
    return _tasks;
  }

  Map<LatLng, Task> get coordsMap {
    return _coordsMap;
  }

  Future<bool> initializeTasks() async {
    return await _db.queryAllTasks().then((tasks) {
      if (tasks != null) {
        for (Task task in tasks) {
          task.marker = new Marker(
            point: task.coords,
            builder: (context) => new Container(
              child: Icon(
                Icons.place,
                size: kMarkerSize,
                color: kMarkerColor,
              ),
            ),
          );
        }
        _tasks = tasks;

        this.createCoordsMap(tasks);
      }
    }).then((value) => true);
  }

  Task findById(int id) {
    return _tasks.firstWhere((task) => task.id == id);
  }

  Future<int> getNewTaskId() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int newId = await helper.getNewTaskId();
    return newId;
  }

  void addTask(Task newTask) {
    _tasks.add(newTask);

    _db.insertTask(newTask).then((newTaskId) =>
        print("New Task with ID<$newTaskId> added to database."));

    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);

    _db.deleteTask(task.id).then(
          (success) => success
              ? 'Task ${task.id} removed from database.'
              : 'ERROR: Task ${task.id} could not be removed from database.',
        );

    notifyListeners();
  }

  Map<LatLng, Task> createCoordsMap(List<Task> tasks) {
    Map<LatLng, Task> tempCoordsMap = new Map<LatLng, Task>();
    for (Task task in tasks) {
      tempCoordsMap[task.coords] = task;
    }

    _coordsMap = tempCoordsMap;
  }

  void modifyTaskTitle(int taskId, String newTitle) {
    _tasks.firstWhere((task) => task.id == taskId).title = newTitle;

    _db.updateTaskLocation(taskId, newTitle).then(
          (success) => success
              ? 'Task $taskId title updated to $newTitle'
              : 'ERROR: Task $taskId title could not be updated',
        );

    notifyListeners();
  }

  void modifyTaskDescription(int taskId, String newDescription) {
    _tasks.firstWhere((task) => task.id == taskId).description = newDescription;

    _db.updateTaskLocation(taskId, newDescription).then(
          (success) => success
              ? 'Task $taskId description updated to $newDescription'
              : 'ERROR: Task $taskId description could not be updated',
        );

    notifyListeners();
  }

  void modifyTaskCoords(int taskId, LatLng newCoords) {
    _tasks.firstWhere((task) => task.id == taskId).coords = newCoords;

    String coordsStr =
        newCoords.latitude.toString() + ',' + newCoords.longitude.toString();

    _db.updateTaskLocation(taskId, coordsStr).then(
          (success) => success
              ? 'Task $taskId coords updated to $coordsStr'
              : 'ERROR: Task $taskId coords could not be updated',
        );

    notifyListeners();
  }

  void modifyTaskAnyTimeOfDay(int taskId, bool newValue) {
    _tasks.firstWhere((task) => task.id == taskId).anyTimeOfDay = newValue;

    _db.updateTaskAnyTimeOfDay(taskId, newValue.toString()).then(
          (success) => success
              ? 'Task $taskId AnyTimeOfDay updated to ${newValue.toString()}'
              : 'ERROR: Task $taskId AnyTimeOfDay could not be updated',
        );

    notifyListeners();
  }

  void modifyTaskAnyTime(int taskId, bool newValue) {
    _tasks.firstWhere((task) => task.id == taskId).anyTime = newValue;

    _db.updateTaskAnyTime(taskId, newValue.toString()).then(
          (success) => success
              ? 'Task $taskId AnyTime updated to ${newValue.toString()}}'
              : 'ERROR: Task $taskId AnyTime could not be updated',
        );

    notifyListeners();
  }

  void modifyTaskStartDate(int taskId, DateTime newDate) {
    _tasks.firstWhere((task) => task.id == taskId).startDate = newDate;

    _db.updateTaskStartDate(taskId, newDate.toIso8601String()).then(
          (success) => success
              ? 'Task $taskId StartDate updated to ${newDate.toIso8601String()}}'
              : 'ERROR: Task $taskId StartDate could not be updated',
        );

    notifyListeners();
  }

  void modifyTaskStartTime(int taskId, TimeOfDay newTime) {
    _tasks.firstWhere((task) => task.id == taskId).startTime = newTime;

    _db.updateTaskStartTime(taskId, newTime.toString()).then(
          (success) => success
              ? 'Task $taskId StartTime updated to ${newTime.toString()}}'
              : 'ERROR: Task $taskId StartTime could not be updated',
        );

    notifyListeners();
  }

  void modifyTaskEndDate(int taskId, DateTime newDate) {
    _tasks.firstWhere((task) => task.id == taskId).endDate = newDate;

    _db.updateTaskStartDate(taskId, newDate.toIso8601String()).then(
          (success) => success
              ? 'Task $taskId EndDate updated to ${newDate.toIso8601String()}}'
              : 'ERROR: Task $taskId EndDate could not be updated',
        );
    notifyListeners();
  }

  void modifyTaskEndTime(int taskId, TimeOfDay newTime) {
    _tasks.firstWhere((task) => task.id == taskId).endTime = newTime;

    _db.updateTaskStartTime(taskId, newTime.toString()).then(
          (success) => success
              ? 'Task $taskId EndTime updated to ${newTime.toString()}}'
              : 'ERROR: Task $taskId EndTime could not be updated',
        );

    notifyListeners();
  }

  void modifyTaskLocation(int taskId, String newLocation) {
    _tasks.firstWhere((task) => task.id == taskId).location = newLocation;

    _db.updateTaskLocation(taskId, newLocation).then((success) => {
          print("$taskId updated: $success"),
          success
              ? 'Task $taskId location updated to $newLocation'
              : 'ERROR: Task $taskId location could not be updated'
        });

    notifyListeners();
  }

  void modifyTaskNotificationDistance(int taskId, double notificationDistance) {
    _tasks.firstWhere((task) => task.id == taskId).notificationDistance =
        notificationDistance;

    _db
        .updateTaskNotificationDistance(taskId, notificationDistance.toString())
        .then((success) => {
              print("$taskId updated: $success"),
              success
                  ? 'Task $taskId location updated to $notificationDistance'
                  : 'ERROR: Task $taskId location could not be updated'
            });

    notifyListeners();
  }
}
