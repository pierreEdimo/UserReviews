import 'package:userCritiqs/model/UserModel.dart';

class Comment {
  final int id;
  final int reviewId;
  final String body;
  final String authorId;
  final RegisterModel author;

  Comment({this.id, this.reviewId, this.body, this.author, this.authorId});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'] as int,
        reviewId: json['reviewId'] as int,
        authorId: json['authorId'] as String,
        author: RegisterModel.fromJson(json['author']),
        body: json['body'] as String);
  }
}
