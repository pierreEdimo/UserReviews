import 'dart:convert';

import 'package:http/http.dart';
import 'package:userCritiqs/model/Item.dart';

class ItemService {
  Future<List<Item>> getItems() async {
    Response response = await get(
        "https://uservoice20200910121949.azurewebsites.net/api/Items");

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Item> items =
          body.map((dynamic item) => Item.fromJson(item)).toList();

      return items;
    } else {
      throw "Can't get Items";
    }
  }

  Future<List<Item>> getItemsFromCategory(int categoryId) async {
    Response response = await get(
        "https://uservoice20200910121949.azurewebsites.net/api/Items/GetitemFromCategory?categoryId=$categoryId");

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Item> items =
          body.map((dynamic item) => Item.fromJson(item)).toList();

      return items;
    } else {
      throw "can't get the Items";
    }
  }

  Future<List<Item>> searchItems(String name) async {
    Response response = await get(
        "https://uservoice20200910121949.azurewebsites.net/api/Items?name=$name");

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Item> items =
          body.map((dynamic item) => Item.fromJson(item)).toList();

      return items;
    } else {
      throw "can't get the Items";
    }
  }
}
