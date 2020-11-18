import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_tasks/constants.dart';
import 'package:geo_tasks/models/task.dart';
import 'package:geo_tasks/providers/tasks_provider.dart';
import 'package:geo_tasks/widgets/map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  Task newTask = new Task.emptyTask();

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);

    setState(() {
      newTask.id = tasksProvider.getNewTaskId();
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Task Settings'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        leading: BackButton(
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => {
              _saveTask(tasksProvider),
              Navigator.pop(context),
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.35,
                      child: Map(
                        onLongPress: (LatLng coords) => {
                          _setTaskCoords(coords),
                          _setTaskMarker(new Marker(point: coords)),
                        },
                        taskMarkers: newTask.marker == null
                            ? new List<Marker>()
                            : new List<Marker>.from([newTask.marker]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: constraints.maxHeight * 0.35 - 25,
                      ),
                      height: constraints.maxHeight * 0.65 + 25,
                      width: constraints.maxWidth,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          TextFormField(
                            initialValue: newTask.title,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              hintText: "Enter Title...",
                            ),
                            onChanged: (value) => {
                              _setTaskTitle(value),
                            },
                          ),

                          SizedBox(height: 25.0),

                          // Description
                          TextFormField(
                            initialValue: newTask.description,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              hintText: "Enter Description...",
                            ),
                            onChanged: (value) => {
                              _setTaskDescription(
                                value,
                              )
                            },
                            minLines: 1,
                            maxLines: 10,
                          ),

                          SizedBox(height: 25.0),

                          // Location
                          // Use the MapBox GeoCoding API here!
                          // TextFormField(
                          //   initialValue: currentTask.coords,
                          //   style: TextStyle(fontSize: 18.0),
                          //   decoration: InputDecoration(
                          //     hintText: "Enter Location...",
                          //   ),
                          //   onChanged: (value) => {
                          //     tasksProvider.modifyTaskCoords(
                          //       currentTask.id,
                          //       value,
                          //     )
                          //   },
                          // ),

                          // SizedBox(height: 20.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Remind Me Any Time',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Switch(
                                value: newTask.anyTime,
                                onChanged: (value) => {
                                  _setTaskAnyTime(value),
                                },
                              ),
                            ],
                          ),

                          (() {
                            if (newTask.anyTime) {
                              return SizedBox();
                            } else {
                              return Column(
                                children: [
                                  // Any Time Of Day (boolean)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Any Time of Day",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Switch(
                                        value: newTask.anyTimeOfDay == null
                                            ? false
                                            : newTask.anyTimeOfDay,
                                        onChanged: (value) => {
                                          _setTaskAnyTimeOfDay(value),
                                        },
                                      )
                                    ],
                                  ),

                                  // Start Date + Time
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () => _selectStartDate(
                                            context,
                                            newTask,
                                            tasksProvider), // Refer step 3
                                        child: Text(
                                          Utils.formatDate(newTask.startDate),
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                      Visibility(
                                        visible: newTask.anyTimeOfDay == null
                                            ? true
                                            : !newTask.anyTimeOfDay,
                                        child: FlatButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () => _selectStartTime(
                                              context, newTask, tasksProvider),
                                          child: Text(
                                            Utils.formatTime(newTask.startTime),
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  // End Date + Time
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FlatButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () => _selectEndDate(
                                            context,
                                            newTask,
                                            tasksProvider), // Refer step 3
                                        child: Text(
                                          Utils.formatDate(newTask.endDate),
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                      Visibility(
                                        visible: newTask.anyTimeOfDay == null
                                            ? true
                                            : !newTask.anyTimeOfDay,
                                        child: FlatButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () => _selectEndTime(
                                              context, newTask, tasksProvider),
                                          child: Text(
                                            Utils.formatTime(newTask.endTime),
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            }
                          }()),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _setTaskTitle(String newTitle) {
    setState(() {
      newTask.title = newTitle;
    });
  }

  void _setTaskDescription(String newDescription) {
    setState(() {
      newTask.description = newDescription;
    });
  }

  void _setTaskStartDate(DateTime newStartDate) {
    setState(() {
      newTask.startDate = newStartDate;
    });
  }

  void _setTaskStartTime(TimeOfDay newStartTime) {
    setState(() {
      newTask.startTime = newStartTime;
    });
  }

  void _setTaskEndDate(DateTime newEndDate) {
    setState(() {
      newTask.endDate = newEndDate;
    });
  }

  void _setTaskEndTime(TimeOfDay newEndTime) {
    setState(() {
      newTask.endTime = newEndTime;
    });
  }

  void _setTaskAnyTimeOfDay(bool newAnyTimeOfDay) {
    setState(() {
      newTask.anyTimeOfDay = newAnyTimeOfDay;
    });
  }

  void _setTaskAnyTime(bool newAnyTime) {
    setState(() {
      newTask.anyTime = newAnyTime;
    });
  }

  void _setTaskCoords(LatLng newCoords) {
    setState(() {
      newTask.coords = newCoords;
    });
  }

  void _setTaskMarker(Marker newMarker) {
    setState(() {
      newTask.marker = newMarker;
    });
  }

  void _saveTask(TasksProvider tasksProvider) {
    tasksProvider.addTask(newTask);
  }

  _selectStartDate(BuildContext context, Task currentTask,
      TasksProvider tasksProvider) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: currentTask.startDate == null
          ? DateTime.now()
          : currentTask.startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
    );
    if (picked != null && picked != currentTask.startDate)
      _setTaskStartDate(picked);
  }

  _selectStartTime(BuildContext context, Task currentTask,
      TasksProvider tasksProvider) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: currentTask.startTime == null
          ? TimeOfDay.now()
          : currentTask.startTime,
    );
    if (picked != null && picked != currentTask.startTime)
      _setTaskStartTime(picked);
  }

  _selectEndDate(BuildContext context, Task currentTask,
      TasksProvider tasksProvider) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
          currentTask.endDate == null ? DateTime.now() : currentTask.endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
    );
    if (picked != null && picked != currentTask.endDate)
      _setTaskEndDate(picked);
  }

  _selectEndTime(BuildContext context, Task currentTask,
      TasksProvider tasksProvider) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime:
          currentTask.endTime == null ? TimeOfDay.now() : currentTask.endTime,
    );
    if (picked != null && picked != currentTask.endTime)
      _setTaskEndTime(picked);
  }
}
