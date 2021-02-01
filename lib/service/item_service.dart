import 'package:mpasabuy/bloc/item/item.dart';
import 'package:http/http.dart' as http;
import 'package:mpasabuy/util/app.dart';

class ItemService {
  String url = AppUtil.urlBackend;

  Future<List<Item>> fetchFeaturedItem() async {
    final response = await http.get('${url}/api/product/featured');
    if (response.statusCode == 200) {
      // print(response.body);
      List<Item> items = Item.itemFromJson(response.body);

      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<Item>> fetchLatestItem() async {
    final response = await http.get('${url}/api/product/latest');
    if (response.statusCode == 200) {
      // print(response.body);
      List<Item> items = Item.itemFromJson(response.body);

      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<Item>> fetchPagedItems(size, page) async {
    final response = await http.get('${url}/api/product/all/${size}/${page}');
    print(response.body);
    if (response.statusCode == 200) {
      return Item.itemFromJson(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }
}
