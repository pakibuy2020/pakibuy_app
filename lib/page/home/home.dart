import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_state.dart';
import 'package:mpasabuy/page/account/account.dart';
import 'package:mpasabuy/page/home/dashboard.dart';
import 'package:mpasabuy/page/item/all_items.dart';
import 'package:mpasabuy/page/logout.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [Dashboard(), AllItems(), Account()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    var _authBloc = BlocProvider.of<AuthBlock>(context);
    var state = (_authBloc.state as Success).userData;
    var photo = state['picture']['data']['url'];
    var email = state['email'];

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.lightBlue,
          leading: new Padding(
            padding: const EdgeInsets.all(5.0),
            child: new CircleAvatar(
              backgroundImage: new NetworkImage(photo),
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pasabuy App',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
              Text(
                email,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              tooltip: 'Show Cart',
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
            ),
            LogOut(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          // backgroundColor: Color(0xFF10161d),
          // selectedItemColor: Color(0xFFFF9900),
          unselectedItemColor: Colors.black,
          items: [
            //you should at least have 2 items with the icon and title or you will have an error
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.category),
            //   title: Text("Category"),
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              title: Text("Products"),
            ),
          ],
        ),
        body: _children[_currentIndex]);
  }
}

Padding searchWidget() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.all(20.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black,
        ),
        hintText: "Search...",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}
