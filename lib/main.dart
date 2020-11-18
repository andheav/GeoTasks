import 'package:flutter/material.dart';
import 'package:geo_tasks/constants.dart';
import 'package:geo_tasks/providers/tasks_provider.dart';
import 'package:geo_tasks/screens/create_task_screen.dart';
import 'package:geo_tasks/screens/home_screen.dart';
import 'package:geo_tasks/screens/map_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TasksProvider(),
      child: MaterialApp(
        title: 'GeoTasks',
        home: Home(),
      ),
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        title: Text('GeoTasks', style: TextStyle(fontSize: 30.0)),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.map_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Account'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: HomeScreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColorLight,
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTaskScreen(),
            ),
          )
        },
        child: Icon(
          Icons.add,
          size: 30.0,
        ),
      ),
    );
  }
}

// Uses Cases/Features:
// - If I am within 5 miles of Discount Tire between the hours of X - X, then notify me
// - Ping user when their car is in motion (Did you remember to do this?)
