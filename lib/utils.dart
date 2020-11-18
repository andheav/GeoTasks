import 'package:flutter/material.dart';
import 'package:geo_tasks/models/task.dart';
import 'package:geo_tasks/providers/tasks_provider.dart';
import 'package:provider/provider.dart';

class Utils {
  static String getWeekday(int weekday, bool shortened) {
    switch (weekday) {
      case 1:
        return shortened ? "Mon" : "Monday";
        break;
      case 2:
        return shortened ? "Tues" : "Tuesday";
        break;
      case 3:
        return shortened ? "Wed" : "Wednesday";
        break;
      case 4:
        return shortened ? "Thurs" : "Thursday";
        break;
      case 5:
        return shortened ? "Fri" : "Friday";
        break;
      case 6:
        return shortened ? "Sat" : "Saturday";
        break;
      case 7:
        return shortened ? "Sun" : "Sunday";
        break;
      default:
        return "";
        break;
    }
  }

  static String getMonth(int month) {
    switch (month) {
      case 1:
        return "Jan";
        break;
      case 2:
        return "Feb";
        break;
      case 3:
        return "Mar";
        break;
      case 4:
        return "Apr";
        break;
      case 5:
        return "May";
        break;
      case 6:
        return "Jun";
        break;
      case 7:
        return "Jul";
        break;
      case 8:
        return "Aug";
        break;
      case 9:
        return "Sept";
        break;
      case 10:
        return "Oct";
        break;
      case 11:
        return "Nov";
        break;
      case 12:
        return "Dec";
        break;
      default:
        return "";
        break;
    }
  }

  static String formatDate(DateTime date, {bool shortened = false}) {
    return '${Utils.getWeekday(date == null ? DateTime.now().weekday : date.weekday, shortened)}, ${Utils.getMonth(date == null ? DateTime.now().month : date.month)} ${date == null ? DateTime.now().day : date.day}';
  }

  static String formatTime(TimeOfDay time, {bool shortened = false}) {
    return '${time == null ? TimeOfDay.now().hour == 0 ? 12 : TimeOfDay.now().hour % 12 : time.hour == 0 ? 12 : time.hour % 12}' +
        '${time == null ? '' : ':' + time.minute.toString()}' +
        ' ${time == null ? TimeOfDay.now().hour < 12 ? 'AM' : 'PM' : time.hour < 12 ? 'AM' : 'PM'}';
  }
}

class AnyTimeOfDaySelector extends StatelessWidget {
  const AnyTimeOfDaySelector({
    Key key,
    @required this.taskId,
  }) : super(key: key);

  final int taskId;

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    final currentTask = tasksProvider.findById(taskId);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Any Time of Day",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
        Switch(
          value: currentTask.anyTimeOfDay == null
              ? false
              : currentTask.anyTimeOfDay,
          onChanged: (value) =>
              {tasksProvider.modifyTaskAnyTimeOfDay(taskId, value)},
        )
      ],
    );
  }
}

class StartDateAndTimeSelector extends StatelessWidget {
  StartDateAndTimeSelector({
    Key key,
    @required this.taskId,
  }) : super(key: key);

  final int taskId;

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    final currentTask = tasksProvider.findById(taskId);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () =>
              _selectDate(context, currentTask, tasksProvider), // Refer step 3
          child: Text(
            Utils.formatDate(currentTask.startDate),
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Visibility(
          visible: currentTask.anyTimeOfDay == null
              ? true
              : !currentTask.anyTimeOfDay,
          child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () => _selectTime(context, currentTask, tasksProvider),
            child: Text(
              Utils.formatTime(currentTask.startTime),
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        )
      ],
    );
  }

  _selectDate(BuildContext context, Task currentTask,
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
      tasksProvider.modifyTaskStartDate(this.taskId, picked);
  }

  _selectTime(BuildContext context, Task currentTask,
      TasksProvider tasksProvider) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: currentTask.startTime == null
          ? TimeOfDay.now()
          : currentTask.startTime,
    );
    if (picked != null && picked != currentTask.startTime)
      tasksProvider.modifyTaskStartTime(this.taskId, picked);
  }
}

class EndDateAndTimeSelector extends StatelessWidget {
  EndDateAndTimeSelector({
    Key key,
    @required this.taskId,
  }) : super(key: key);

  final int taskId;

  @override
  Widget build(BuildContext context) {
    final tasksProvider = Provider.of<TasksProvider>(context);
    final currentTask = tasksProvider.findById(taskId);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () =>
              _selectDate(context, currentTask, tasksProvider), // Refer step 3
          child: Text(
            Utils.formatDate(currentTask.endDate),
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Visibility(
          visible: currentTask.anyTimeOfDay == null
              ? true
              : !currentTask.anyTimeOfDay,
          child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () => _selectTime(context, currentTask, tasksProvider),
            child: Text(
              Utils.formatTime(currentTask.endTime),
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        )
      ],
    );
  }

  _selectDate(BuildContext context, Task currentTask,
      TasksProvider tasksProvider) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:
          currentTask.endDate == null ? DateTime.now() : currentTask.endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2999),
    );
    if (picked != null && picked != currentTask.endDate)
      tasksProvider.modifyTaskEndDate(this.taskId, picked);
  }

  _selectTime(BuildContext context, Task currentTask,
      TasksProvider tasksProvider) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime:
          currentTask.endTime == null ? TimeOfDay.now() : currentTask.endTime,
    );
    if (picked != null && picked != currentTask.endTime)
      tasksProvider.modifyTaskEndTime(this.taskId, picked);
  }
}