import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mpasabuy/util/bclipper.dart';

import 'package:mpasabuy/bloc/auth/auth_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_state.dart';
import 'package:mpasabuy/bloc/auth/auth_event.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlock, AuthState>(
      listener: (context, state) {
        if (state is Success) {
          Navigator.of(context).pushNamed('/home');
        }
      },
      child: BlocBuilder<AuthBlock, AuthState>(
        builder: (context, state) {
          return background(context, state);
        },
      ),
    );
  }
}

Widget background(BuildContext context, AuthState state) {
  return Scaffold(
    body: SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ClipPath(
            clipper: BackgroundClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(color: Colors.lightBlue),
            )),
        Container(
          padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
          child: renderPage(context, state),
        )
      ],
    )),
  );
}

Widget renderPage(BuildContext context, AuthState state) {
  if (state is Initial || state is LogoutSuccess) {
    return Column(children: <Widget>[
      SizedBox(height: 20.0),
      SizedBox(height: 5.0),
      SizedBox(height: 40.0),
      SizedBox(height: 20.0),
      Container(
        height: 40.0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 1.0),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.0)),
          child: InkWell(
            onTap: () => BlocProvider.of<AuthBlock>(context).add(LoginEvent()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: ImageIcon(AssetImage('assets/facebook.png')),
                ),
                SizedBox(width: 10.0),
                Center(
                  child: Text('Log in with facebook',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat')),
                )
              ],
            ),
          ),
        ),
      )
    ]);
  } else {
    return Center(child: CircularProgressIndicator());
  }
}
