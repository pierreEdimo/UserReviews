import 'dart:convert';

import 'package:http/http.dart';
import 'package:userCritiqs/model/Comment.dart';

class CommentService {
  Future<Response> addComment(String body, String authorId, int reviewId) {
    return post(
      "https://uservoice20200910121949.azurewebsites.net/api/Comments",
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'body': body,
          'authorId': authorId,
          'reviewId': reviewId,
        },
      ),
    );
  }

  Future<List<Comment>> getComments(int reviewId) async {
    Response response = await get(
        'https://uservoice20200910121949.azurewebsites.net/api/Comments?reviewId=$reviewId');

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      List<Comment> comments =
          body.map((dynamic comment) => Comment.fromJson(comment)).toList();

      return comments;
    } else {
      throw "can't get Comments";
    }
  }
}
