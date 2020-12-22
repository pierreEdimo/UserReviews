import 'package:userCritiqs/model/RegisterModel.dart';

class Review {
  final int id;
  final int note;
  final int itemId;
  final String body;
  final String authorId;
  final int numberOfComments;
  final RegisterModel author;

  Review(
      {this.body,
      this.id,
      this.note,
      this.itemId,
      this.author,
      this.authorId,
      this.numberOfComments});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        id: json['id'] as int,
        body: json['body'] as String,
        note: json['note'] as int,
        authorId: json['authorId'],
        numberOfComments: json['numberOfComments'] as int,
        author: RegisterModel.fromJson(json['author']),
        itemId: json['itemId'] as int);
  }
}
