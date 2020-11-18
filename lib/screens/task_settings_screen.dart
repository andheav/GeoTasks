import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_tasks/models/task.dart';
import 'package:geo_tasks/providers/tasks_provider.dart';
import 'package:geo_tasks/utils.dart';

import "package:latlong/latlong.dart";
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/map.dart';

class TaskSettingsScreen extends StatelessWidget {
  TaskSettingsScreen({this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    final currentTask = tasksProvider.findById(taskId);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Task Settings'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        backgroundColor: kPrimaryColor,
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
                          currentTask.marker = new Marker(point: coords),
                        },
                        taskMarkers:
                            new List<Marker>.from([currentTask.marker]),
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
                            initialValue: currentTask.title,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              hintText: "Enter Title...",
                            ),
                            onChanged: (value) => {
                              tasksProvider.modifyTaskTitle(
                                currentTask.id,
                                value,
                              )
                            },
                          ),

                          SizedBox(height: 25.0),

                          // Description
                          TextFormField(
                            initialValue: currentTask.description,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              hintText: "Enter Description...",
                            ),
                            onChanged: (value) => {
                              tasksProvider.modifyTaskDescription(
                                currentTask.id,
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
                                value: currentTask.anyTime,
                                onChanged: (value) => {
                                  tasksProvider.modifyTaskAnyTime(
                                      taskId, value),
                                },
                              ),
                            ],
                          ),

                          (() {
                            if (currentTask.anyTime != null && currentTask.anyTime) {
                              return SizedBox();
                            } else {
                              return Column(
                                children: [
                                  // Any Time Of Day (boolean)
                                  AnyTimeOfDaySelector(
                                    taskId: taskId,
                                  ),

                                  // Start Date + Time
                                  StartDateAndTimeSelector(
                                    taskId: taskId,
                                  ),

                                  // End Date + Time
                                  EndDateAndTimeSelector(
                                    taskId: taskId,
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
}
