import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_bloc.dart';
import 'package:mpasabuy/bloc/item/cart/cart_bloc.dart';
import 'package:mpasabuy/page/login.dart';

import 'package:mpasabuy/util/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _authBloc = AuthBlock();
  var _cartBloc = CartBloc();
  @override
  Widget build(BuildContext context) {
    //global access
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _authBloc,
        ),
        BlocProvider(
          create: (context) => _cartBloc,
        )
      ],
      child: MaterialApp(
        onGenerateRoute: RouterGenerator.generateRoute,
        home: Login(),
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    _cartBloc.close();
    super.dispose();
  }
}
