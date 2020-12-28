class Item {
  final int authorId;
  final int categoryId;
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String entryDate;
  final int numberOfReviews;
  final String genre;
  final String releaseDate;
  final String publisher;
  final int note; 

  Item(
      {this.authorId,
      this.id,
      this.categoryId,
      this.name,
      this.description,
      this.numberOfReviews,
      this.publisher,
      this.releaseDate,
      this.note, 
      this.genre,
      this.entryDate,
      this.imageUrl});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        id: json['id'] as int,
        categoryId: json['categoryId'] as int,
        authorId: json['authorId'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String,
        genre: json['genre'] as String,
        publisher: json['publisher'] as String,
        note: json['note'] as int, 
        releaseDate: json['releaseDate'] as String,
        numberOfReviews: json['numberOfReviews'] as int,
        entryDate: json['entryDate'] as String);
  }
}
