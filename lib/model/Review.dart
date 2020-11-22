class Review {
  final int id;
  final int note;
  final int itemId;
  final String body;
  final String authorId;
  final int numberOfComments;

  Review(
      {this.body,
      this.id,
      this.note,
      this.itemId,
      this.authorId,
      this.numberOfComments});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        id: json['id'] as int,
        body: json['body'] as String,
        note: json['note'] as int,
        authorId: json['authorId'],
        numberOfComments: json['numberOfComments'] as int,
        itemId: json['itemId'] as int);
  }
}
