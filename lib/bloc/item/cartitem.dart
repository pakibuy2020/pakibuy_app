import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mpasabuy/bloc/item/item.dart';

class CartItem extends Equatable {
  CartItem({
    this.id,
    this.qty,
    this.lastModified,
    this.product,
  });

  int id;
  int qty;
  DateTime lastModified;
  Item product;

  @override
  List<Object> get props => [id, qty, lastModified, product];

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        qty: json["qty"],
        lastModified: DateTime.parse(json["last_modified"]),
        product: Item.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qty": qty,
        "last_modified": lastModified.toIso8601String(),
        "product": product.toJson(),
      };

  static List<CartItem> itemFromJson(String str) =>
      List<CartItem>.from(json.decode(str).map((x) => CartItem.fromJson(x)));
}
