class Highlight {
  final int id;
  final String userId;
  final int bookId;
  final String quote;
  final String? myNote;
  final int? pageNumber;
  final String? chapterContext;
  final String? mood;
  final List<Map<String, dynamic>> llmConversation;
  final String? llmSummary;
  final String? illustrationUrl;
  final String? illustrationPrompt;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // 연결된 책 정보 (UI 표시용)
  final String? bookTitle;
  final String? bookCoverUrl;
  final String? bookAuthor;

  Highlight({
    this.id = 0,
    required this.userId,
    required this.bookId,
    required this.quote,
    this.myNote,
    this.pageNumber,
    this.chapterContext,
    this.mood,
    this.llmConversation = const [],
    this.llmSummary,
    this.illustrationUrl,
    this.illustrationPrompt,
    this.isPublic = false,
    DateTime? createdAt,
    this.updatedAt,
    this.bookTitle,
    this.bookCoverUrl,
    this.bookAuthor,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Highlight.fromJson(Map<String, dynamic> json) {
    return Highlight(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as String? ?? '',
      bookId: json['book_id'] as int? ?? 0,
      quote: json['quote'] as String? ?? '',
      myNote: json['my_note'] as String?,
      pageNumber: json['page_number'] as int?,
      chapterContext: json['chapter_context'] as String?,
      mood: json['mood'] as String?,
      llmConversation: (json['llm_conversation'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      llmSummary: json['llm_summary'] as String?,
      illustrationUrl: json['illustration_url'] as String?,
      illustrationPrompt: json['illustration_prompt'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'book_id': bookId,
        'quote': quote,
        'my_note': myNote,
        'page_number': pageNumber,
        'chapter_context': chapterContext,
        'mood': mood,
        'llm_conversation': llmConversation,
        'llm_summary': llmSummary,
        'illustration_url': illustrationUrl,
        'illustration_prompt': illustrationPrompt,
        'is_public': isPublic,
      };

  Highlight copyWith({
    int? id,
    String? userId,
    int? bookId,
    String? quote,
    String? myNote,
    int? pageNumber,
    String? chapterContext,
    String? mood,
    List<Map<String, dynamic>>? llmConversation,
    String? llmSummary,
    String? illustrationUrl,
    String? illustrationPrompt,
    bool? isPublic,
    String? bookTitle,
    String? bookCoverUrl,
    String? bookAuthor,
  }) {
    return Highlight(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      quote: quote ?? this.quote,
      myNote: myNote ?? this.myNote,
      pageNumber: pageNumber ?? this.pageNumber,
      chapterContext: chapterContext ?? this.chapterContext,
      mood: mood ?? this.mood,
      llmConversation: llmConversation ?? this.llmConversation,
      llmSummary: llmSummary ?? this.llmSummary,
      illustrationUrl: illustrationUrl ?? this.illustrationUrl,
      illustrationPrompt: illustrationPrompt ?? this.illustrationPrompt,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt,
      updatedAt: updatedAt,
      bookTitle: bookTitle ?? this.bookTitle,
      bookCoverUrl: bookCoverUrl ?? this.bookCoverUrl,
      bookAuthor: bookAuthor ?? this.bookAuthor,
    );
  }
}
