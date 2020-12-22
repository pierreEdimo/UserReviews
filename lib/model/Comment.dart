import 'package:userCritiqs/model/RegisterModel.dart';

class Comment {
  final int id;
  final int reviewId;
  final String body;
  final RegisterModel author;

  Comment({
    this.id,
    this.reviewId,
    this.body,
    this.author,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'] as int,
        reviewId: json['reviewId'] as int,
        author: RegisterModel.fromJson(json['author']),
        body: json['body'] as String);
  }
}
