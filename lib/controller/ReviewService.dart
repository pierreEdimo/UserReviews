import 'dart:convert';

import 'package:http/http.dart';
import 'package:userCritiqs/model/Review.dart';

import '../main.dart';

class ReviewService {
  Future<List<Review>> getReviews(int itemId) async {
    Response response = await get(
        'https://uservoice20201218092231.azurewebsites.net/api/Reviews?itemId=$itemId&&sortOrder=desc');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Review> reviews =
          body.map((dynamic review) => Review.fromJson(review)).toList();

      return reviews;
    } else {
      throw "can't get reviews";
    }
  }

  Future<Response> deleteReview(int id) async {
    String jwt = await storage.read(key: "jwt");

    Response response = await delete(
        'https://uservoice20201218092231.azurewebsites.net/api/Reviews/$id',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + jwt
        });

    print(response.statusCode);
    return response;
  }

  Future<Response> updateReview(String body, int reviewNote, int id) async {
    String jwt = await storage.read(key: "jwt");

    Response response = await put(
        'https://uservoice20201218092231.azurewebsites.net/api/Reviews/$id',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + jwt
        },
        body: jsonEncode({'id': id, 'body': body, 'reviewNote': reviewNote}));

    return response;
  }

  Future<List<Review>> getReviewsFromAuthor(String authorId) async {
    Response response = await get(
        'https://uservoice20201218092231.azurewebsites.net/api/Reviews/GetReviewFromAuthor?authorId=$authorId&&sortOrder=desc');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Review> reviews =
          body.map((dynamic review) => Review.fromJson(review)).toList();

      return reviews;
    } else {
      throw "can't get reviews";
    }
  }

  Future<Response> addReview(
      String body, String authorId, int note, int itemId) {
    return post(
      "https://uservoice20201218092231.azurewebsites.net/api/Reviews",
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'body': body,
          'authorId': authorId,
          'ReviewNote': note,
          'itemId': itemId,
        },
      ),
    );
  }
}
