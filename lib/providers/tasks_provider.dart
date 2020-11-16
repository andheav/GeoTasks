import 'package:flutter/material.dart';
import 'package:geo_tasks/models/task.dart';
import 'package:latlong/latlong.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _tasks = [
    Task(
      id: 1,
      title: 'Task 1',
      description: 'This is Task 1',
      coords: new LatLng(42.493910, -90.679660),
    ),
    Task(
      id: 2,
      title: 'Task 2',
      description: 'This is Task 2 and this is a long description',
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
}
