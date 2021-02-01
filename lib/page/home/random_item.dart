import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpasabuy/bloc/item/item.dart';

import 'package:mpasabuy/bloc/item/random_item/item_block.dart';
import 'package:mpasabuy/bloc/item/random_item/item_event.dart';
import 'package:mpasabuy/bloc/item/random_item/item_state.dart';
import 'package:mpasabuy/page/item/item_profile.dart';
import 'package:mpasabuy/util/app.dart';

class RandomItem extends StatefulWidget {
  @override
  _RandomItemState createState() => _RandomItemState();
}

class _RandomItemState extends State<RandomItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) => ItemBloc()..add(LoadAll()),
        child: page(context),
      ),
    );
  }
}

Widget page(BuildContext context) {
  return Container(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Featured Item",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
      ),
      Container(
        width: double.infinity,
        height: 270.0,
        child: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            if (state is LoadAllSuccess) {
              if (state.items.length > 0) {
                List<Item> listItems = state.items;
                return ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        listItems.map((e) => itemCard(e, context)).toList());
              } else {
                return Center(child: Text('No item'));
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )
    ],
  ));
}

Widget itemCard(Item item, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).pushNamed('/itemDescription',
          arguments: ItemDetailArguments(item: item, cartItemId: null));
    },
    child: Container(
        margin: new EdgeInsets.only(right: 10),
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: 150.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Image(
              image: NetworkImage(AppUtil.urlBackend + item.coverPhoto),
              width: 170.0,
              height: 160.0,
              alignment: Alignment.center,
            ),
            Text(
              item.name,
              style: TextStyle(fontSize: 10.0),
            ),
            Text(
              'SKU : ${item.sku.toString()}',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
            Text(
              'Php ${item.price}',
              style: TextStyle(
                  fontSize: 16.0,
                  color: Color(
                    0xFFFF9900,
                  )),
            ),
          ],
        )),
  );
}
