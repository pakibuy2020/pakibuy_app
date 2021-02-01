import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpasabuy/page/home/random_item.dart';
import 'package:mpasabuy/util/bclipper.dart';

import 'latest_item.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Stack(children: [
        ClipPath(
            clipper: BackgroundClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(color: Colors.lightBlue),
            )),
        // Positioned(child: searchWidget())
      ]),

      // first item section
      RandomItem(),

      // second item section
      LatestItem()
    ]));
  }
}
