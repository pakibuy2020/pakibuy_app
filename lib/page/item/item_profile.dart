import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_state.dart';
import 'package:mpasabuy/bloc/item/cart/cart_bloc.dart';
import 'package:mpasabuy/bloc/item/cart/cart_event.dart';
import 'package:mpasabuy/bloc/item/cart/cart_state.dart';
import 'package:mpasabuy/bloc/item/item.dart';
import 'package:mpasabuy/util/app.dart';

class ItemDetailArguments {
  final int cartItemId;
  final Item item;
  const ItemDetailArguments({this.cartItemId, this.item});
}

class ItemDetail extends StatefulWidget {
  ItemDetailArguments args;

  ItemDetail({Key key, @required this.args}) : super(key: key);

  @override
  _ItemDetail createState() => _ItemDetail();
}

class _ItemDetail extends State<ItemDetail> {
  var qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var rating = 3.0;
    // ignore: close_sinks
    var _authBloc = BlocProvider.of<AuthBlock>(context);
    var state = (_authBloc.state as Success).userData;
    var email = state['email'];

    BlocProvider.of<CartBloc>(context)
        .add(CheckCartItem(email: email, sku: widget.args.item.sku));

    return BlocListener<CartBloc, CartState>(
        listener: (cx, state) {
          if (state is CartOperationSuccess) {
            Navigator.of(context).pushNamed('/home');
          }
        },
        child: Scaffold(
            floatingActionButton: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state is CartLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        if (state is CartCheckFound) {
                          var cartId = state.id;
                          //show remove from cart
                          return FloatingActionButton(
                            onPressed: () {
                              BlocProvider.of<CartBloc>(context)
                                  .add(RemoveItemFromCart(cartId: cartId));
                            },
                            child: Icon(Icons.remove_shopping_cart),
                            backgroundColor: Colors.redAccent,
                          );
                        } else {
                          return FloatingActionButton(
                            onPressed: () {
                              // ignore: close_sinks
                              if (_authBloc.state is Success) {
                                var state =
                                    (_authBloc.state as Success).userData;
                                BlocProvider.of<CartBloc>(context).add(
                                    AddToCartEvent(
                                        email: state['email'],
                                        sku: widget.args.item.sku,
                                        qty: this.qtyController.text));
                              }
                            },
                            child: Icon(Icons.add_shopping_cart),
                            backgroundColor: Colors.blue,
                          );
                        }
                      }
                    },
                  ),
                ),
                updateButton(
                  widget.args.cartItemId,
                  _authBloc,
                  context,
                )
              ],
            ),
            body: Center(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.lightBlue,
                    expandedHeight: 350.00,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                          AppUtil.urlBackend + widget.args.item.coverPhoto,
                          fit: BoxFit.cover),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    ListTile(
                      title: Text("Php. ${widget.args.item.price}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.00,
                              color: Colors.red)),
                      subtitle: Text(widget.args.item.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),

                    // qty
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        if (state is CartLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (state is CartCheckFound) {
                            var _qty = state.qty;
                            return textField(qtyController, _qty.toString());
                          } else {
                            return textField(qtyController, '1');
                          }
                        }
                      },
                    ),

                    // item description
                    Container(
                        margin: const EdgeInsets.only(
                            left: 15, top: 5, bottom: 20, right: 15),
                        child: ExpandableText(
                          widget.args.item.description,
                          expandText: 'show more',
                          collapseText: 'show less',
                          maxLines: 3,
                          linkColor: Colors.blue,
                        )),
                  ]))
                ],
              ),
            )));
  }

  Widget updateButton(cartItemId, _authBloc, context) {
    return cartItemId != null
        ? Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              child: Icon(Icons.edit),
              heroTag: cartItemId,
              onPressed: () {
                if (_authBloc.state is Success) {
                  BlocProvider.of<CartBloc>(context).add(UpdateQty(
                      cartItemId: cartItemId,
                      qty: int.parse(this.qtyController.text)));
                }
              },
            ),
          )
        : SizedBox();
  }
}

Widget textField(TextEditingController qtyController, String qty) {
  return Container(
      width: 50.0,
      margin: const EdgeInsets.only(left: 15, top: 5, bottom: 20, right: 15),
      child: TextField(
          controller: qtyController..text = qty,
          decoration: InputDecoration(
              labelText: "Quantity", prefixIcon: Icon(Icons.shopping_basket)),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ]));
}
