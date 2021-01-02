import 'dart:convert';

import 'package:http/http.dart';
import 'package:userCritiqs/model/Comment.dart';

import '../main.dart';

class CommentService {
  Future<Response> addComment(String body, String authorId, int reviewId) {
    return post(
      "https://uservoice20201218092231.azurewebsites.net/api/Comments",
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

  Future<Response> deleteComment(int id) async {
    String jwt = await storage.read(key: "jwt");

    Response response = await delete(
        'https://uservoice20201218092231.azurewebsites.net/api/Comments/$id',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + jwt
        });

    return response;
  }

  Future<Response> updateComment(String body, int id) async {
    String jwt = await storage.read(key: "jwt");

    Response response = await put(
        'https://uservoice20201218092231.azurewebsites.net/api/Comments/$id',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + jwt
        },
        body: jsonEncode({'id': id, 'body': body}));

    return response;
  }

  Future<List<Comment>> getComments(int reviewId) async {
    Response response = await get(
        'https://uservoice20201218092231.azurewebsites.net/api/Comments?reviewId=$reviewId');

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
