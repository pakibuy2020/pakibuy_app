import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mpasabuy/bloc/item/item.dart';
import 'package:mpasabuy/page/item/item_profile.dart';
import 'package:mpasabuy/service/item_service.dart';
import 'package:mpasabuy/util/app.dart';
import 'package:mpasabuy/util/bclipper.dart';

class AllItems extends StatefulWidget {
  @override
  _AllItemsState createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  static const _pageSize = 20;

  final PagingController<int, Item> _pagingController =
      PagingController(firstPageKey: 1);

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

  _fetchPage(int pageKey) async {
    var service = ItemService();
    try {
      var newItems = await service.fetchPagedItems(_pageSize, pageKey);
      // final newItems = await RemoteApi.getCharacterList(pageKey, _pageSize);
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
    return Stack(children: <Widget>[
      ClipPath(
          clipper: BackgroundClipper(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(color: Colors.lightBlue),
          )),
      Container(
          padding: const EdgeInsets.all(5.0),
          child: CustomScrollView(slivers: [
            PagedSliverGrid<int, Item>(
              pagingController: _pagingController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 100 / 150,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
              ),
              builderDelegate: PagedChildBuilderDelegate<Item>(
                  itemBuilder: (context, item, index) => InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/itemDescription',
                              arguments: ItemDetailArguments(
                                  item: item, cartItemId: null));
                        },
                        child: GridTile(
                          footer: Container(
                            color: Colors.white54,
                            child: ListTile(
                              title: Text("Php. ${item.price}",
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent)),
                              subtitle: Text(item.name,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.overline,
                                      color: Colors.black)),
                            ),
                          ),
                          child: Image(
                            image: NetworkImage(
                                AppUtil.urlBackend + item.coverPhoto),
                            width: 170.0,
                            height: 160.0,
                            alignment: Alignment.center,
                          ),
                        ),
                      )),
            )
          ]))
    ]);
  }
}
