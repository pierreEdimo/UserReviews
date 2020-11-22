class Category {
  final int id;
  final String name;
  final String imageUrl;
  final int numberOfItems;

  Category({
    this.id,
    this.imageUrl,
    this.numberOfItems,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'] as int,
        imageUrl: json['imageUrl'] as String,
        numberOfItems: json['numberOfItems'] as int,
        name: json['name'] as String);
  }
}
