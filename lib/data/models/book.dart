class Book {
  final int id;
  final String title;
  final String author;
  final String publisher;
  final String coverUrl;
  final String description;
  final String category;
  final String? isbn13;
  final DateTime? pubDate;
  final double? avgRating;
  final int? ratingCount;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.coverUrl,
    this.description = '',
    this.category = '',
    this.isbn13,
    this.pubDate,
    this.avgRating,
    this.ratingCount,
  });
}
