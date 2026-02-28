class Review {
  final int id;
  final String userId;
  final int bookId;
  final String content;
  final bool hasSpoiler;
  final int likesCount;
  final DateTime createdAt;
  final String username;
  final String? avatarUrl;
  final String? bookTitle;
  final String? bookCoverUrl;
  final String? bookAuthor;
  final double? rating;
  bool isLiked;

  Review({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.content,
    this.hasSpoiler = false,
    this.likesCount = 0,
    required this.createdAt,
    required this.username,
    this.avatarUrl,
    this.bookTitle,
    this.bookCoverUrl,
    this.bookAuthor,
    this.rating,
    this.isLiked = false,
  });
}
