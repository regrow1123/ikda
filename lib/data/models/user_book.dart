enum BookStatus { reading, completed, wantToRead }

class UserBook {
  final int id;
  final int bookId;
  final BookStatus status;
  final double? rating;
  final DateTime? readDate;
  final String? bookTitle;
  final String? bookCoverUrl;
  final String? bookAuthor;

  const UserBook({
    required this.id,
    required this.bookId,
    required this.status,
    this.rating,
    this.readDate,
    this.bookTitle,
    this.bookCoverUrl,
    this.bookAuthor,
  });
}
