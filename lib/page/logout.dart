import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_event.dart';
import 'package:mpasabuy/bloc/auth/auth_state.dart';

class LogOut extends StatefulWidget {
  @override
  _LogOutState createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBlock, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.of(context).pushNamed('/login');
        }
      },
      child: BlocBuilder<AuthBlock, AuthState>(
        builder: (context, state) {
          return IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              return BlocProvider.of<AuthBlock>(context).add(LogOutEvent());
            },
          );
        },
      ),
    );
  }
}
