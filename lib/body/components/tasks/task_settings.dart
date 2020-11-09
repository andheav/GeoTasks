import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_tasks/body/components/tasks/task.dart';

import "package:latlong/latlong.dart";

import '../../../constants.dart';
import '../map/map.dart';

class TaskSettings extends StatelessWidget {
  TaskSettings({this.task});

  Task task;

  updateTitle(String title) {
    this.task.title = title;
  }

  updateDescription(String description) {
    this.task.description = description;
  }

  updateMarker(Marker marker) {
    this.task.marker = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('${task.title} Settings'),
          centerTitle: true,
          leading: BackButton(
            onPressed: () => {
              Navigator.pop(context, this.task),
            },
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: Body(
          task: task,
          updateTitle: updateTitle,
          updateDescription: updateDescription,
          updateMarker: updateMarker,
        ));
  }
}

class Body extends StatelessWidget {
  const Body({
    Key key,
    this.task,
    this.updateTitle,
    this.updateDescription,
    this.updateMarker,
  }) : super(key: key);

  final Task task;
  final ValueChanged<String> updateTitle;
  final ValueChanged<String> updateDescription;
  final ValueChanged<Marker> updateMarker;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                        this.updateMarker(new Marker(point: coords)),
                      },
                      taskMarkers: new List<Marker>.from([this.task.marker]),
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
                          hintText: this.task.title == null ||
                                  this.task.title.length == 0
                              ? 'Enter a title for the task...'
                              : this.task.title,
                          onChanged: (value) => {
                            this.updateTitle(value),
                          },
                        ),

                        SizedBox(height: 25.0),

                        // Description
                        CustomTextInputField(
                          title: 'Description',
                          hintText: this.task.description == null ||
                                  this.task.description.length == 0
                              ? 'Enter a description for the task...'
                              : this.task.description,
                          onChanged: (value) => {
                            this.updateDescription(value),
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
