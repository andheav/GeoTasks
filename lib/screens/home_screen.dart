import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/task_list.dart';
import '../providers/location_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: constraints.maxHeight * 0.10,
                    decoration: BoxDecoration(color: kPrimaryColor),
                    // // TEMPORARY FOR TESTING
                    // child: Center(
                    //   child: Text(
                    //     LocationProvider.userCurrentLocation != null
                    //         ? "Current Location: ${LocationProvider.userCurrentLocation.latitude.toStringAsFixed(5)}, ${LocationProvider.userCurrentLocation.longitude.toStringAsFixed(5)}"
                    //         : "",
                    //     style: TextStyle(color: Colors.white, fontSize: 18),
                    //   ),
                    // ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: constraints.maxHeight * 0.10 - 20,
                    ),
                    padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular((30.0)),
                      ),
                    ),
                    height: constraints.maxHeight * 0.90 + 20,
                    child: TaskList(),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
