class Comment {
  final int id;
  final int reviewId;
  final String body;

  Comment({this.id, this.reviewId, this.body});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'] as int,
        reviewId: json['reviewId'] as int,
        body: json['body'] as String);
  }
}
