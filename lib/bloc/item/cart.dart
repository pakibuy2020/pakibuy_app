import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mpasabuy/bloc/item/cartitem.dart';

class Cart extends Equatable {
  Cart({
    this.id,
    this.customerEmail,
    this.status,
    this.dateCreated,
    this.cartitem,
  });

  int id;
  String customerEmail;
  int status;
  DateTime dateCreated;
  List<CartItem> cartitem;

  @override
  List<Object> get props => [id, customerEmail, status, dateCreated, cartitem];

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        customerEmail: json["customer_email"],
        status: json["status"],
        dateCreated: DateTime.parse(json["date_created"]),
        cartitem: List<CartItem>.from(
            json["cartitem"].map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_email": customerEmail,
        "status": status,
        "date_created": dateCreated.toIso8601String(),
        "cartitem": List<dynamic>.from(cartitem.map((x) => x.toJson())),
      };

  static List<Cart> itemFromJson(String str) =>
      List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));
}
