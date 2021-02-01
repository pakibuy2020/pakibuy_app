import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_state.dart';
import 'package:mpasabuy/service/cart_service.dart';

enum PaymentType { gcash, cod }

class Checkout extends StatefulWidget {
  int cartId;

  Checkout({Key key, @required this.cartId}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String totalAmount = '0.00';
  String shipping;
  String netAmount = '0.00';

  bool isDone = false;

  var cartService = CartService();

  final txtAddress = TextEditingController();
  final txtContact = TextEditingController();

  @override
  void initState() {
    super.initState();

    // ignore: close_sinks
    var _authBloc = BlocProvider.of<AuthBlock>(context);
    var state = (_authBloc.state as Success).userData;
    var email = state['email'];

    this.pullData(email);
  }

  void pullData(email) async {
    final carts = await cartService.getCartDetail(widget.cartId, email);
    carts.cartitem.forEach((itm) {
      var currTotal = double.parse(totalAmount);
      var tmpTotalQty = itm.qty * double.parse(itm.product.price);
      var tmpFinal = currTotal + tmpTotalQty;

      if (tmpFinal < 1000) {
        setState(() {
          shipping = 'Php 100.00';
        });
      } else {
        setState(() {
          shipping = 'Free shipping';
        });
      }

      setState(() {
        totalAmount = tmpFinal.toString();
      });
    });

    if (double.parse(totalAmount) < 1000) {
      setState(() {
        netAmount = (100.00 + double.parse(totalAmount)).toString();
      });
    } else {
      setState(() {
        netAmount = totalAmount;
      });
    }

    setState(() {
      isDone = true;
    });
  }

  PaymentType _paymentType = PaymentType.gcash;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.lightBlue,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Checkout')],
          ),
          actions: <Widget>[
            isDone
                ? FlatButton(
                    textColor: Colors.white,
                    onPressed: () async {
                      if (this._paymentType.index == PaymentType.gcash.index) {
                        if (double.parse(this.netAmount) > 100) {
                          setState(() {
                            isDone = false;
                          });
                          await this.cartService.gcashPayment(
                              widget.cartId,
                              this.totalAmount,
                              this.netAmount,
                              this.txtAddress.text,
                              this.txtContact.text);
                          Navigator.of(context).pushNamed('/home');
                        } else {}
                      } else {
                        //cod
                        await this.cartService.codPayment(
                            widget.cartId,
                            this.totalAmount,
                            this.netAmount,
                            this.txtAddress.text,
                            this.txtContact.text);
                        Navigator.of(context).pushNamed('/home');
                      }
                    },
                    child: Text("Proceed"),
                    shape: CircleBorder(
                        side: BorderSide(color: Colors.transparent)),
                  )
                : CircularProgressIndicator(),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      isDone
                          ? Text('Php. ${totalAmount}')
                          : CircularProgressIndicator()
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping Fee',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        isDone
                            ? Text('${shipping}')
                            : CircularProgressIndicator()
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Net Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 5,
                            fontSize: 20,
                          ),
                        ),
                        isDone
                            ? Text('Php. ${netAmount}',
                                style: TextStyle(height: 5, fontSize: 20))
                            : CircularProgressIndicator()
                      ],
                    )),
                Container(
                    child: Card(
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: const Text('Contact Details'),
                        ),
                        TextField(
                          controller: this.txtContact,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Contact Number'),
                        ),
                        TextField(
                          controller: this.txtAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Delivery Address'),
                        ),
                      ],
                    ),
                  ),
                )),
                Container(
                  child: Card(
                    child: Padding(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Mode of Payment'),
                            ),
                            ListTile(
                              title: const Text('Gcash'),
                              leading: Radio(
                                groupValue: _paymentType,
                                value: PaymentType.gcash,
                                onChanged: (PaymentType value) {
                                  setState(() {
                                    _paymentType = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Cash on Delivery'),
                              leading: Radio(
                                groupValue: _paymentType,
                                value: PaymentType.cod,
                                onChanged: (PaymentType value) {
                                  setState(() {
                                    _paymentType = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
