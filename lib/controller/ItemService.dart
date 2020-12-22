import 'dart:convert';

import 'package:http/http.dart';
import 'package:userCritiqs/model/Item.dart';

class ItemService {
  Future<List<Item>> getItems() async {
    Response response = await get(
        "https://uservoice20201218092231.azurewebsites.net/api/Items");

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
        "https://uservoice20201218092231.azurewebsites.net/api/Items/GetitemFromCategory?categoryId=$categoryId");

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
        "https://uservoice20201218092231.azurewebsites.net/api/Items?name=$name");

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Item> items =
          body.map((dynamic item) => Item.fromJson(item)).toList();

      return items;
    } else {
      throw "can't get the Items";
    }
  }

  Future<Item> fetchItembyId(int id) async {
    Response response = await get(
        'https://uservoice20201218092231.azurewebsites.net/api/Items/$id');

    if (response.statusCode == 200) {
      return Item.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Item');
    }
  }
}
