import 'dart:convert';

import 'package:mpasabuy/bloc/item/cart.dart';
import 'package:mpasabuy/bloc/item/cartitem.dart';
import 'package:mpasabuy/util/app.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CartService {
  String url = AppUtil.urlBackend;

  Future<void> addToCart(String email, int sku, String qty) async {
    // ignore: unnecessary_brace_in_string_interps
    final response = await http.post('${url}/api/cart/item/add',
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'customer_email': email,
          'product_sku': sku,
          'qty': qty
        }));

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<CartItem> checkItem(String email, int sku) async {
    final response =
        await http.get('${url}/api/cart/checkitem/${email}/${sku}');
    if (response.statusCode == 200) {
      final cart = CartItem.fromJson(jsonDecode(response.body));
      return cart;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> removeItem(int id) async {
    print('deleting ' + id.toString());
    var response = await http.delete('${url}/api/cart/item/remove/${id}');
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> updateQty(int cartItemId, int qty) async {
    print('item count is now ${qty}');

    final response = await http.put('${url}/api/cart/item/update',
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            <String, dynamic>{'cart_item_id': cartItemId, 'qty': qty}));

    if (response.statusCode == 202) {
      print('updated qty');
    } else {
      throw Exception('Failed to update qty');
    }
  }

  Future<List<Cart>> carts(String email, size, page) async {
    final response =
        await http.get('${url}/api/cart/list/${email}/${size}/${page}');
    if (response.statusCode == 200) {
      return Cart.itemFromJson(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<CartItem>> cartItems(String email, size, page, cartId) async {
    final response = await http
        .get('${url}/api/cart/items/${email}/${cartId}/${size}/${page}');
    if (response.statusCode == 200) {
      final cartItems = CartItem.itemFromJson(response.body);
      return cartItems;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Cart> getCartDetail(int cartId, String email) async {
    final response = await http.get('${url}/api/cart/view/${email}/${cartId}');
    if (response.statusCode == 200) {
      final cart = Cart.fromJson(jsonDecode(response.body));
      return cart;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<String> gcashPayment(cart_id, amount, net, address, contact) async {
    final response = await http.post('${url}/api/cart/payment/gcash/',
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'cart_id': cart_id.toString(),
          'amount': double.parse(amount).toStringAsFixed(2),
          'net': double.parse(net).toStringAsFixed(2),
          'address': address,
          'contact': contact
        }));

    Map<String, dynamic> json = jsonDecode(response.body);
    print(json['checkout_url']);
    url = json['checkout_url'];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> codPayment(cart_id, amount, net, address, contact) async {
    final response = await http.post('${url}/api/cart/payment/cod/',
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'cart_id': cart_id.toString(),
          'amount': double.parse(amount).toStringAsFixed(2),
          'net': double.parse(net).toStringAsFixed(2),
          'address': address,
          'contact': contact
        }));
  }
}
