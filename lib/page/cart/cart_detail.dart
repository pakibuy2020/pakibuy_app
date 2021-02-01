import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mpasabuy/bloc/auth/auth_bloc.dart';
import 'package:mpasabuy/bloc/auth/auth_state.dart';
import 'package:mpasabuy/bloc/item/cartitem.dart';
import 'package:mpasabuy/page/item/item_profile.dart';
import 'package:mpasabuy/service/cart_service.dart';
import 'package:mpasabuy/util/app.dart';

class CartDetail extends StatefulWidget {
  int cartId;

  CartDetail({Key key, @required this.cartId}) : super(key: key);

  @override
  _CartDetailState createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  static const _pageSize = 20;
  int status;
  var service = CartService();

  final PagingController<int, CartItem> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // ignore: close_sinks
      var _authBloc = BlocProvider.of<AuthBlock>(context);
      var state = (_authBloc.state as Success).userData;
      var email = state['email'];

      var status_cart = await service.getCartDetail(widget.cartId, email);

      setState(() {
        status = status_cart.status;
      });

      final newItems =
          await service.cartItems(email, _pageSize, pageKey, widget.cartId);
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
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Cart Items')],
        ),
        actions: <Widget>[
          this.status != 5
              ? FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/checkout', arguments: widget.cartId);
                  },
                  child: Text("Checkout"),
                  shape:
                      CircleBorder(side: BorderSide(color: Colors.transparent)),
                )
              : Text('')
        ],
      ),
      body: PagedListView<int, CartItem>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<CartItem>(
            itemBuilder: (context, item, index) =>
                cartItem(context, item, item.id)),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

Widget cartItem(BuildContext context, CartItem item, int cartId) {
  return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/itemDescription',
            arguments:
                ItemDetailArguments(item: item.product, cartItemId: cartId));
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(AppUtil.urlBackend +
                item.product
                    .coverPhoto), // no matter how big it is, it won't overflow
          ),
          title: Text(item.product.name +
              ' ( ' +
              item.qty.toString() +
              ' * Php. ' +
              item.product.price +
              ')'),
        ),
      ));
}
