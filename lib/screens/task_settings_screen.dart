import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong/latlong.dart";

import '../utils.dart';
import '../constants.dart';
import '../widgets/map.dart';
import '../models/task.dart';

class TaskSettingsScreen extends StatefulWidget {
  TaskSettingsScreen({this.taskId});

  final int taskId;

  @override
  _TaskSettingsScreenState createState() => _TaskSettingsScreenState();
}

class _TaskSettingsScreenState extends State<TaskSettingsScreen> {
  String _notificationRadiusValue = "Enter Notification Distance...";
  List<String> _notificationDistanceItems = [
    'Enter Notification Distance...',
    '0.25 mi',
    '0.5 mi',
    '1 mi',
    '2 mi',
    '3 mi',
    '4 mi',
    '5 mi',
  ];

  ValueNotifier _notificationRadiusChanged = ValueNotifier(1.0);

  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    // final tasksProvider = Provider.of<TasksProvider>(context);
    final tasksProvider = Utils.tasksProvider;
    final currentTask = tasksProvider.findById(widget.taskId);
    _notificationRadiusChanged = ValueNotifier(currentTask.notificationRadius);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Task Settings'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: _editMode
                ? Icon(
                    Icons.check,
                    size: 30.0,
                  )
                : Icon(
                    Icons.edit,
                    size: 30.0,
                  ),
            onPressed: () {
              if (_editMode) {
                _updateTask(currentTask);

                setState(() {
                  _editMode = false;
                });

                Navigator.pop(context);
              } else {
                setState(() {
                  _editMode = true;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              size: 30.0,
            ),
            onPressed: () {
              _deleteTask(currentTask);
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: kPrimaryColor,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: constraints.maxHeight * 0.35,
                    child: Map(
                      taskId: currentTask.id,
                      notificationDistanceNotifier: _notificationRadiusChanged,
                      onLongPress: (LatLng coords) => {
                        currentTask.marker = new Marker(
                          point: coords,
                          builder: (context) => new Container(
                            child: Icon(
                              Icons.place,
                              size: kMarkerSize,
                              color: kMarkerColor,
                            ),
                          ),
                        ),
                      },
                      // taskMarkers: new List<Marker>.from([currentTask.marker]),
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
                            enabled: _editMode,
                            initialValue: currentTask.title,
                            style: TextStyle(fontSize: 18.0),
                            enableInteractiveSelection: true,
                            decoration: InputDecoration(
                                hintText: "Enter Title...",
                                icon: Icon(
                                  Icons.title,
                                  color: kPrimaryColorLight,
                                )),
                            onChanged: (value) => {
                              setState(() {
                                currentTask.title = value;
                              })
                            },
                          ),

                          SizedBox(height: 25.0),

                          // Description
                          TextFormField(
                            enabled: _editMode,
                            initialValue: currentTask.description,
                            style: TextStyle(fontSize: 18.0),
                            enableInteractiveSelection: true,
                            decoration: InputDecoration(
                              hintText: "Enter Description...",
                              icon: Icon(
                                Icons.subject,
                                color: kPrimaryColorLight,
                              ),
                            ),
                            onChanged: (value) => {
                              setState(() {
                                currentTask.description = value;
                              })
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
                            value: _convertNotifDistToString(
                                currentTask.notificationRadius),
                            disabledHint: Text(
                              _convertNotifDistToString(
                                  currentTask.notificationRadius),
                            ),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            isExpanded: true,
                            onChanged: !_editMode
                                ? null
                                : (String value) {
                                    _evaluateNotificationRadius(
                                        value, currentTask);
                                  },
                            items: _notificationDistanceItems
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 20.0),

                          // This field should probably eventually just be a dropdown that has two options:
                          // Remind Me... [Any Time, Specific Time]
                          // If Any Time, then hide the lower fields like it currently does,
                          // If Specific Time, then show the lower fields
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       'Remind Me Any Time',
                          //       style: TextStyle(
                          //         fontSize: 18.0,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //     ),
                          //     Switch(
                          //       value: currentTask.anyTime,
                          //       activeColor: kPrimaryColorLight,
                          //       onChanged: (value) => {
                          //         tasksProvider.modifyTaskAnyTime(
                          //             widget.taskId, value),
                          //       },
                          //     ),
                          //   ],
                          // ),

                          // (() {
                          //   if (currentTask.anyTime != null &&
                          //       currentTask.anyTime) {
                          //     return SizedBox();
                          //   } else {
                          //     return Column(
                          //       children: [
                          //         // Any Time Of Day (boolean)
                          //         AnyTimeOfDaySelector(
                          //           taskId: widget.taskId,
                          //         ),

                          //         // Start Date + Time
                          //         StartDateAndTimeSelector(
                          //           taskId: widget.taskId,
                          //         ),

                          //         // End Date + Time
                          //         EndDateAndTimeSelector(
                          //           taskId: widget.taskId,
                          //         ),
                          //       ],
                          //     );
                          //   }
                          // }()),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  void _updateTask(Task currentTask) {
    var tasksProvider = Utils.tasksProvider;
    tasksProvider.updateTask(currentTask);
  }

  void _deleteTask(Task currentTask) {
    var tasksProvider = Utils.tasksProvider;
    tasksProvider.deleteTask(currentTask);
  }

  void _evaluateNotificationRadius(String value, Task currentTask) {
    if (value != "Enter Notification Distance...") {
      final radius = double.parse(value.replaceAll(' mi', ''));
      _notificationRadiusChanged.value = radius;

      setState(() {
        _notificationRadiusValue = value;
        currentTask.notificationRadius = radius;
      });
    }
  }

  String _convertNotifDistToString(double dist) {
    return "${dist >= 1 ? dist.toStringAsFixed(0) : dist.toString()} mi";
  }
}
