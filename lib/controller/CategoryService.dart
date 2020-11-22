import 'dart:convert';

import 'package:userCritiqs/model/Category.dart';
import 'package:http/http.dart';

class CategoryService {
  Future<List<Category>> getCategories() async {
    Response response = await get(
        "https://uservoice20200910121949.azurewebsites.net/api/Category");

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Category> categories =
          body.map((dynamic category) => Category.fromJson(category)).toList();

      return categories;
    } else {
      throw "can't get categories";
    }
  }
}
