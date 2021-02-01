import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:mpasabuy/bloc/auth/auth_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_state.dart';
import 'package:mpasabuy/bloc/item/cart.dart';
import 'package:mpasabuy/bloc/item/cartitem.dart';
import 'package:mpasabuy/service/cart_service.dart';
import 'package:mpasabuy/util/app.dart';
import 'package:mpasabuy/util/bclipper.dart';
import 'package:url_launcher/url_launcher.dart';

class CartList extends StatefulWidget {
  @override
  _CartList createState() => _CartList();
}

class _CartList extends State<CartList> {
  static const _pageSize = 20;

  final PagingController<int, Cart> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // ignore: close_sinks
      var _authBloc = BlocProvider.of<AuthBlock>(context);
      var state = (_authBloc.state as Success).userData;
      var email = state['email'];

      var service = CartService();
      final newItems = await service.carts(email, _pageSize, pageKey);
      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.lightBlue,
          title: const Text('Cart History'),
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
                clipper: BackgroundClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(color: Colors.lightBlue),
                )),
            PagedListView<int, Cart>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Cart>(
                  itemBuilder: (context, cart, index) => InkWell(
                        onTap: () async {
                          //if shipping/payment/recieved show reciept
                          if (cart.status == 2 ||
                              cart.status == 3 ||
                              cart.status == 4) {
                            final url = AppUtil.urlBackend +
                                '/cart/print/' +
                                cart.id.toString();
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          } else {
                            Navigator.of(context)
                                .pushNamed('/cartDetail', arguments: cart.id);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Card(
                            color: Colors.white60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Transaction No. ${cart.id.toString()}', //''
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                      Text(
                                        dateFormat(cart.dateCreated),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                      Text(
                                        AppUtil.status(cart.status),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
            )
          ],
        ));
  }
}

String dateFormat(DateTime dt) {
  final f = new DateFormat('MMMM dd yyyy');
  return f.format(dt);
}
