import 'package:flutter/material.dart';
import 'package:mpasabuy/page/cart/cart_detail.dart';
import 'package:mpasabuy/page/cart/cart_list.dart';
import 'package:mpasabuy/page/cart/checkout.dart';
import 'package:mpasabuy/page/item/item_profile.dart';

import 'package:mpasabuy/page/login.dart';
import 'package:mpasabuy/page/home/home.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/itemDescription':
        return MaterialPageRoute(builder: (_) => ItemDetail(args: args));
      case '/cart':
        return MaterialPageRoute(builder: (_) => CartList());
      case '/cartDetail':
        return MaterialPageRoute(builder: (_) => CartDetail(cartId: args));
      case '/checkout':
        return MaterialPageRoute(builder: (_) => Checkout(cartId: args));

        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
