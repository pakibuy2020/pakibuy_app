import 'package:equatable/equatable.dart';
import 'dart:convert';

class Item extends Equatable {
  int sku;
  String name;
  String price;
  String description;
  String coverPhoto;

  Item({
    this.sku,
    this.name,
    this.price,
    this.description,
    this.coverPhoto,
  });

  @override
  List<Object> get props => [sku, name, coverPhoto, price];

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        sku: json["sku"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        coverPhoto: json["cover_photo"],
      );

  Map<String, dynamic> toJson() => {
        "sku": sku,
        "name": name,
        "price": price,
        "description": description,
        "cover_photo": coverPhoto,
      };

  static List<Item> itemFromJson(String str) =>
      List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));
}
