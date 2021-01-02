import 'package:userCritiqs/model/UserModel.dart';

class Review {
  final int id;
  final int itemId;
  final String body;
  final String authorId;
  final int numberOfComments;
  final int reviewNote;
  final RegisterModel author;

  Review(
      {this.body,
      this.id,
      this.itemId,
      this.author,
      this.authorId,
      this.reviewNote,
      this.numberOfComments});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        id: json['id'] as int,
        body: json['body'] as String,
        authorId: json['authorId'],
        reviewNote: json['reviewNote'],
        numberOfComments: json['numberOfComments'] as int,
        author: RegisterModel.fromJson(json['author']),
        itemId: json['itemId'] as int);
  }
}
