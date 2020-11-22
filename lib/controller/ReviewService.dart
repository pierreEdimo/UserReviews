import 'dart:convert';

import 'package:http/http.dart';
import 'package:userCritiqs/model/Review.dart';

class ReviewService {
  Future<List<Review>> getReviews(int itemId) async {
    Response response = await get(
        'https://uservoice20200910121949.azurewebsites.net/api/Reviews?itemId=$itemId');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Review> reviews =
          body.map((dynamic review) => Review.fromJson(review)).toList();

      return reviews;
    } else {
      throw "can't get reviews";
    }
  }

  Future<List<Review>> getReviewsFromAuthor(String authorId) async {
    Response response = await get(
        'https://uservoice20200910121949.azurewebsites.net/api/Reviews/GetReviewFromAuthor?authorId=$authorId');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Review> reviews =
          body.map((dynamic review) => Review.fromJson(review)).toList();

      return reviews;
    } else {
      throw "can't get reviews";
    }
  }

  Future<Response> addReview(String body, String authorId, int itemId) {
    return post(
      "https://uservoice20200910121949.azurewebsites.net/api/Reviews",
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'body': body,
          'authorId': authorId,
          'itemId': itemId,
        },
      ),
    );
  }
}
