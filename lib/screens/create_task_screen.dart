import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';

import '../constants.dart';
import '../models/task.dart';
import '../providers/tasks_provider.dart';
import '../widgets/map.dart';
import '../utils.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  Task newTask = new Task.emptyTask();
  List<String> possibleAddresses = [];

  String _notificationDistanceValue = "1 mi";
  List<String> _notificationDistanceItems = [
    '0.25 mi',
    '0.5 mi',
    '1 mi',
    '2 mi',
    '3 mi',
    '4 mi',
    '5 mi',
  ];

  ValueNotifier _notificationDistanceChanged = ValueNotifier(1.0);

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Utils.tasksProvider;

    setState(() {
      tasksProvider.getNewTaskId().then((newId) {
        newTask.id = newId;
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text('Create a Task'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        leading: BackButton(
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              size: 30.0,
            ),
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
                        notificationDistanceNotifier:
                            _notificationDistanceChanged,
                        onLongPress: (LatLng coords) {
                          if (coords != null) {
                            _setTaskCoords(coords);
                            _setTaskMarker(
                              new Marker(
                                point: coords,
                                builder: (context) => new Container(
                                  child: Icon(
                                    Icons.place,
                                    size: kMarkerSize,
                                    color: kMarkerColor,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            TextFormField(
                              initialValue: newTask.title,
                              style: TextStyle(fontSize: 18.0),
                              textInputAction: TextInputAction.done,
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
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
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

                            DropdownButtonFormField(
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[700],
                              ),
                              value: _notificationDistanceValue,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              isExpanded: true,
                              onChanged: (String value) {
                                if (value != _notificationDistanceValue) {
                                  _notificationDistanceChanged.value =
                                      double.parse(value.replaceAll(' mi', ''));

                                  _setTaskNotificationDistance(value);
                                }
                              },
                              items: _notificationDistanceItems
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),

                            // Location
                            // Use the MapBox GeoCoding API here!
                            // TextFormField(
                            //   initialValue: newTask.location != null
                            //       ? newTask.location
                            //       : "",
                            //   style: TextStyle(fontSize: 18.0),
                            //   decoration: InputDecoration(
                            //     hintText: "Enter Location...",
                            //   ),
                            //   // onChanged: (value) => {
                            //   //   _findAddressesFromQuery(value),
                            //   // },
                            //   onSaved: (value) => {
                            //     _setTaskCoords(_decodeLocationToCoords(value)),
                            //     _setTaskLocation(value),
                            //   },
                            // ),

                            SizedBox(height: 20.0),

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
                                                context,
                                                newTask,
                                                tasksProvider),
                                            child: Text(
                                              Utils.formatTime(
                                                  newTask.startTime),
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
                                                context,
                                                newTask,
                                                tasksProvider),
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

  void _setTaskLocation(String newLocation) {
    setState(() {
      newTask.location = newLocation;
    });
  }

  void _setTaskMarker(Marker newMarker) {
    setState(() {
      newTask.marker = newMarker;
    });
  }

  void _setTaskNotificationDistance(String value) {
    setState(() {
      newTask.notificationDistance = double.parse(value.replaceAll(' mi', ''));
      _notificationDistanceValue = value;
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

  LatLng _decodeLocationToCoords(String value) {
    Geocoder.local.findAddressesFromQuery(value).then((value) {
      return value.first.coordinates;
    });
  }

  String _findAddressesFromQuery(String value) {
    Geocoder.local.findAddressesFromQuery(value).then((value) {
      possibleAddresses = [value[0].addressLine, value[1].addressLine];
      print(possibleAddresses);
    });
  }
}
