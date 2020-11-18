import 'package:flutter/material.dart';
import 'package:geo_tasks/models/task.dart';
import 'package:latlong/latlong.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _tasks = [
    Task(
      id: 1,
      title: 'Drop package off',
      description: 'Package is 8.2 lbs. Talk to Jess aj aj aj aj aj aj aja aja',
      coords: new LatLng(42.493910, -90.679660),
    ),
    Task(
      id: 2,
      title: 'Get Eggs',
      description: '',
      coords: new LatLng(42.497162, -90.667300),
    ),
    Task(
      id: 3,
      title: 'Task 3',
      description: 'This is Task 3',
      coords: new LatLng(42.486951, -90.667071),
    ),
    Task(
      id: 4,
      title: 'Task 4',
      description: 'This is Task 4',
      coords: new LatLng(42.503996, -90.709987),
    ),
    Task(
      id: 5,
      title: 'Task 5',
      description: 'This is Task 5',
      coords: new LatLng(42.507497, -90.689502),
    ),
    Task(
      id: 6,
      title: 'Task 6',
      description: 'This is Task 6',
      coords: new LatLng(42.48328, -90.694537),
    ),
  ];

  List<Task> get tasks {
    return [..._tasks];
  }

  Task findById(int id) {
    return _tasks.firstWhere((task) => task.id == id);
  }

  // TODO: This will eventually need to depend on the task IDs in a database.
  // Can't always assume that the last task in the list FOR THIS USER
  // will be the most recent task.
  int getNewTaskId() {
    return _tasks.last.id + 1;
  }

  void addTask(Task newTask) {
    _tasks.add(newTask);
    notifyListeners();
  }

  void modifyTaskTitle(int taskId, String newTitle) {
    _tasks.firstWhere((task) => task.id == taskId).title = newTitle;
    notifyListeners();
  }

  void modifyTaskDescription(int taskId, String newDescription) {
    _tasks.firstWhere((task) => task.id == taskId).description = newDescription;
    notifyListeners();
  }

  void modifyTaskCoords(int taskId, LatLng newCoords) {
    _tasks.firstWhere((task) => task.id == taskId).coords = newCoords;
    notifyListeners();
  }

  void modifyTaskAnyTimeOfDay(int taskId, bool newValue) {
    _tasks.firstWhere((task) => task.id == taskId).anyTimeOfDay = newValue;
    notifyListeners();
  }

  void modifyTaskAnyTime(int taskId, bool newValue) {
    _tasks.firstWhere((task) => task.id == taskId).anyTime = newValue;
    notifyListeners();
  }

  void modifyTaskStartDate(int taskId, DateTime newDate) {
    _tasks.firstWhere((task) => task.id == taskId).startDate = newDate;
    notifyListeners();
  }

  void modifyTaskStartTime(int taskId, TimeOfDay newTime) {
    _tasks.firstWhere((task) => task.id == taskId).startTime = newTime;
    notifyListeners();
  }

  void modifyTaskEndDate(int taskId, DateTime newDate) {
    _tasks.firstWhere((task) => task.id == taskId).endDate = newDate;
    notifyListeners();
  }

  void modifyTaskEndTime(int taskId, TimeOfDay newTime) {
    _tasks.firstWhere((task) => task.id == taskId).endTime = newTime;
    notifyListeners();
  }
}
