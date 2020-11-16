import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_tasks/providers/tasks_provider.dart';

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
        title: Text('${currentTask.title} Settings'),
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
                          CustomTextInputField(
                            title: 'Title',
                            hintText: currentTask.title == null ||
                                    currentTask.title.length == 0
                                ? 'Enter a title for the task...'
                                : currentTask.title,
                            onChanged: (value) => {
                              tasksProvider.modifyTaskTitle(
                                  currentTask.id, value),
                            },
                          ),

                          SizedBox(height: 25.0),

                          // Description
                          CustomTextInputField(
                            title: 'Description',
                            hintText: currentTask.description == null ||
                                    currentTask.description.length == 0
                                ? 'Enter a description for the task...'
                                : currentTask.description,
                            onChanged: (value) => {
                              tasksProvider.modifyTaskDescription(
                                  currentTask.id, value),
                            },
                          ),

                          SizedBox(height: 25.0),

                          // // Location
                          // CustomTextInputField(
                          //   title: 'Location',
                          //   hintText: 'Enter the location of the task...',
                          //   onChanged: (value) => {},
                          // ),

                          // SizedBox(height: 20.0),

                          // Start Time
                          Text(
                            'Start Time',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'hint text',
                              border: InputBorder.none,
                            ),
                          ),

                          SizedBox(height: 20.0),

                          // End Time
                          Text(
                            'End Time',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'hint text',
                              border: InputBorder.none,
                            ),
                          ),
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

class CustomTextInputField extends StatelessWidget {
  final String title;
  final String hintText;
  final int minLines;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const CustomTextInputField(
      {Key key,
      this.title,
      this.hintText,
      this.minLines,
      this.maxLines,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          child: TextField(
            style: TextStyle(fontSize: 18.0),
            onChanged: this.onChanged,
            minLines: this.minLines,
            maxLines: this.maxLines,
            decoration: InputDecoration(
              hintText: this.hintText,
            ),
          ),
        ),
      ],
    );
  }
}
