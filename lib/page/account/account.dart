import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpasabuy/util/bclipper.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
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
      ])
    ]));
  }
}
