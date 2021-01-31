import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

// database table and column names
final String tableTasks = 'tasks';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDescription = 'description';
final String columnCoords = 'coordinates';
final String columnNotificationRadius = 'notificationRadius';

// singleton class to manage the database
class DatabaseHelper {
  static Future<List<Task>> getAllTasks() async {
    FirebaseFirestore _db = FirebaseFirestore.instance;

    List<Task> tasks = new List<Task>();
    QuerySnapshot qs = await _db.collection(tableTasks).get();
    qs.docs.forEach((element) {
      tasks.add(
        Task.fromMap(element.data()),
      );
    });

    return tasks;
  }

  static Future<bool> addTask(Task task) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    DocumentReference df = await _db.collection(tableTasks).add(task.toMap());
    return df.id.length > 0;
  }

  static Future<bool> deleteTask(Task task) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    Query query = _db.collection(tableTasks).where('id', isEqualTo: task.id);
    QuerySnapshot snapshot = await query.get();
    if (snapshot.size != 1) {
      print(
        "ERROR: There is more than one task with ID<${task.id}> in the " +
            "database. The task cannot be deleted.",
      );
      return false;
    } else {
      await _db.collection(tableTasks).doc(snapshot.docs.first.id).delete();
      return true;
    }
  }

  static Future<bool> updateTask(Task task) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    Query query = _db.collection(tableTasks).where('id', isEqualTo: task.id);
    QuerySnapshot snapshot = await query.get();
    if (snapshot.size != 1) {
      print(
        "ERROR: There is more than one task with ID<${task.id}> in the " +
            "database. The task cannot be updated.",
      );
      return false;
    } else {
      await _db.collection(tableTasks).doc(snapshot.docs.first.id).set(
            task.toMap(),
            SetOptions(merge: true),
          );
      return true;
    }
  }

//   // This is the actual database filename that is saved in the docs directory.
//   static final _databaseName = "GeoTasksDatabase.db";
//   // Increment this version when you need to change the schema.
//   static final _databaseVersion = 2;

//   // Make this a singleton class.
//   DatabaseHelper._privateConstructor();
  // static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

//   // Only allow a single open connection to the database.
//   static Database _database;
//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await _initDatabase();
//     return _database;
//   }

//   // open the database
//   _initDatabase() async {
//     // The path_provider plugin gets the right directory for Android or iOS.
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//     // Open the database. Can also add an onUpdate callback parameter.
//     return await openDatabase(path,
//         version: _databaseVersion, onCreate: _onCreate);
//   }

//   // SQL string to create the database
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//           CREATE TABLE $tableTasks (
//             $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
//             $columnTitle TEXT NOT NULL,
//             $columnDescription TEXT,
//             $columnStartDate TEXT,
//             $columnEndDate TEXT,
//             $columnStartTime INTEGER,
//             $columnEndTime INTEGER,
//             $columnAnyTimeOfDay TEXT,
//             $columnAnyTime TEXT,
//             $columnCoords TEXT,
//             $columnNotificationDistance TEXT,
//             $columnLocation TEXT
//           )
//           ''');
//   }

//   // Database helper methods:
//   Future<int> insertTask(Task task) async {
//     Database db = await database;
//     int id = await db.insert(tableTasks, task.toMap());
//     return id;
//   }

//   Future<Task> queryTask(int id) async {
//     Database db = await database;
//     List<Map> maps = await db.query(
//       tableTasks,
//       columns: [
//         columnId,
//         columnTitle,
//         columnDescription,
//         columnStartDate,
//         columnEndDate,
//         columnStartTime,
//         columnEndTime,
//         columnAnyTimeOfDay,
//         columnAnyTime,
//         columnCoords,
//         columnNotificationDistance,
//         columnLocation
//       ],
//       where: '$columnId = ?',
//       whereArgs: [id],
//     );
//     if (maps.length > 0) {
//       return Task.fromMap(maps.first);
//     }
//     return null;
//   }

//   Future<List<Task>> queryAllTasks() async {
//     Database db = await database;
//     List<Map> maps = await db.query(
//       tableTasks,
//       columns: [
//         columnId,
//         columnTitle,
//         columnDescription,
//         columnStartDate,
//         columnEndDate,
//         columnStartTime,
//         columnEndTime,
//         columnAnyTimeOfDay,
//         columnAnyTime,
//         columnCoords,
//         columnNotificationDistance,
//         columnLocation
//       ],
//     );
//     if (maps.length > 0) {
//       List<Task> tasks = new List<Task>();
//       for (int i = 0; i < maps.length; i++) {
//         tasks.add(Task.fromMap(maps[i]));
//       }
//       return tasks;
//     }
//     return null;
//   }

//   Future<bool> deleteTask(int id) async {
//     Database db = await database;
//     int rowsAffected = await db.delete(
//       tableTasks,
//       where: '$columnId = ?',
//       whereArgs: [id],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTask(Task task) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       task.toMap(),
//       where: '$columnId = ?',
//       whereArgs: [task.id],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskTitle(int taskId, String title) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnTitle: title},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskDescription(int taskId, String description) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnDescription: description},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskCoords(int taskId, String coords) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnCoords: coords},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskAnyTimeOfDay(int taskId, String val) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnAnyTimeOfDay: val},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskAnyTime(int taskId, String val) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnAnyTime: val},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskStartDate(int taskId, String startDate) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnStartDate: startDate},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskStartTime(int taskId, String startTime) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnStartTime: startTime},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskEndDate(int taskId, String endDate) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnEndDate: endDate},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskEndTime(int taskId, String endTime) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnEndTime: endTime},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskLocation(int taskId, String location) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnLocation: location},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<bool> updateTaskNotificationDistance(
//       int taskId, String notificationDistance) async {
//     Database db = await database;
//     int rowsAffected = await db.update(
//       tableTasks,
//       {columnNotificationDistance: notificationDistance},
//       where: '$columnId = ?',
//       whereArgs: [taskId],
//     );
//     if (rowsAffected > 0) {
//       return true;
//     }
//     return false;
//   }

//   Future<int> getNewTaskId() async {
//     Database db = await database;
//     List<Map> taskIds = await db.query(
//       tableTasks,
//       columns: [columnId],
//       orderBy: columnId,
//     );
//     if (taskIds.length > 0) {
//       Task lastTask = Task.fromMap(taskIds.last);
//       return lastTask.id + 1;
//     }
//     return null;
//   }
}
