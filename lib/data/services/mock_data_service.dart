import '../models/book.dart';
import '../models/review.dart';
import '../models/user_book.dart';
import '../models/profile.dart';

class MockDataService {
  static final List<Book> books = [
    Book(id: 1, title: '아몬드', author: '손원평', publisher: '창비', coverUrl: 'https://picsum.photos/seed/book1/200/300', description: '감정을 느끼지 못하는 소년 윤재의 이야기. 편도체가 남들보다 작아 태어날 때부터 감정을 느끼지 못하는 열여섯 살 윤재.', category: '소설', avgRating: 4.3, ratingCount: 1250),
    Book(id: 2, title: '82년생 김지영', author: '조남주', publisher: '민음사', coverUrl: 'https://picsum.photos/seed/book2/200/300', description: '대한민국에서 가장 흔한 이름을 가진 여자, 김지영의 이야기.', category: '소설', avgRating: 4.1, ratingCount: 3400),
    Book(id: 3, title: '달러구트 꿈 백화점', author: '이미예', publisher: '팩토리나인', coverUrl: 'https://picsum.photos/seed/book3/200/300', description: '잠들어야만 입장할 수 있는 신비로운 상점, 달러구트 꿈 백화점.', category: '소설', avgRating: 4.5, ratingCount: 2100),
    Book(id: 4, title: '불편한 편의점', author: '김호연', publisher: '나무옆의자', coverUrl: 'https://picsum.photos/seed/book4/200/300', description: '서울 변두리 편의점에서 일하게 된 노숙자 독고의 이야기.', category: '소설', avgRating: 4.2, ratingCount: 1800),
    Book(id: 5, title: '미드나잇 라이브러리', author: '매트 헤이그', publisher: '인플루엔셜', coverUrl: 'https://picsum.photos/seed/book5/200/300', description: '삶과 죽음 사이 도서관에서 다른 인생들을 경험하는 노라의 이야기.', category: '소설', avgRating: 4.4, ratingCount: 1600),
    Book(id: 6, title: '역행자', author: '자청', publisher: '웅진지식하우스', coverUrl: 'https://picsum.photos/seed/book6/200/300', description: '돈·시간·운명으로부터 자유를 선언한 사람들의 7가지 법칙.', category: '자기계발', avgRating: 3.8, ratingCount: 4200),
    Book(id: 7, title: '원씽', author: '게리 켈러', publisher: '비즈니스북스', coverUrl: 'https://picsum.photos/seed/book7/200/300', description: '복잡한 세상을 이기는 단순함의 힘.', category: '자기계발', avgRating: 4.0, ratingCount: 2800),
    Book(id: 8, title: '트렌드 코리아 2026', author: '김난도', publisher: '미래의창', coverUrl: 'https://picsum.photos/seed/book8/200/300', description: '서울대 소비트렌드분석센터의 2026 전망.', category: '경제/경영', avgRating: 3.9, ratingCount: 1500),
    Book(id: 9, title: '세이노의 가르침', author: '세이노', publisher: '데이원', coverUrl: 'https://picsum.photos/seed/book9/200/300', description: '피가 되고 살이 되는 세이노의 가르침.', category: '자기계발', avgRating: 4.1, ratingCount: 5600),
    Book(id: 10, title: '작별인사', author: '김영하', publisher: '복복서가', coverUrl: 'https://picsum.photos/seed/book10/200/300', description: '가까운 미래, AI와 인간의 경계에서 벌어지는 이야기.', category: '소설', avgRating: 4.0, ratingCount: 900),
    Book(id: 11, title: '도둑맞은 집중력', author: '요한 하리', publisher: '어크로스', coverUrl: 'https://picsum.photos/seed/book11/200/300', description: '집중력을 되찾기 위한 12가지 해법.', category: '인문', avgRating: 4.2, ratingCount: 1100),
    Book(id: 12, title: '물고기는 존재하지 않는다', author: '룰루 밀러', publisher: '곰출판', coverUrl: 'https://picsum.photos/seed/book12/200/300', description: '상실, 사랑 그리고 숨어 있는 삶의 질서에 대한 이야기.', category: '과학', avgRating: 4.6, ratingCount: 2300),
    Book(id: 13, title: '나미야 잡화점의 기적', author: '히가시노 게이고', publisher: '현대문학', coverUrl: 'https://picsum.photos/seed/book13/200/300', description: '과거와 현재를 잇는 편지가 오가는 잡화점의 기적.', category: '소설', avgRating: 4.5, ratingCount: 3200),
    Book(id: 14, title: '해리 포터와 마법사의 돌', author: 'J.K. 롤링', publisher: '문학수첩', coverUrl: 'https://picsum.photos/seed/book14/200/300', description: '마법 세계로 초대받은 해리 포터의 첫 번째 모험.', category: '판타지', avgRating: 4.7, ratingCount: 8900),
    Book(id: 15, title: '코스모스', author: '칼 세이건', publisher: '사이언스북스', coverUrl: 'https://picsum.photos/seed/book15/200/300', description: '우주의 경이로움을 담은 과학 고전.', category: '과학', avgRating: 4.8, ratingCount: 4100),
    Book(id: 16, title: '사피엔스', author: '유발 하라리', publisher: '김영사', coverUrl: 'https://picsum.photos/seed/book16/200/300', description: '유인원에서 사이보그까지, 인류의 대역사.', category: '인문', avgRating: 4.5, ratingCount: 6700),
    Book(id: 17, title: '데미안', author: '헤르만 헤세', publisher: '민음사', coverUrl: 'https://picsum.photos/seed/book17/200/300', description: '자기 자신을 찾아가는 싱클레어의 성장 이야기.', category: '소설', avgRating: 4.3, ratingCount: 5500),
    Book(id: 18, title: '어린 왕자', author: '생텍쥐페리', publisher: '열린책들', coverUrl: 'https://picsum.photos/seed/book18/200/300', description: '사막에 불시착한 비행사와 어린 왕자의 만남.', category: '소설', avgRating: 4.6, ratingCount: 7200),
    Book(id: 19, title: '총, 균, 쇠', author: '재레드 다이아몬드', publisher: '문학사상', coverUrl: 'https://picsum.photos/seed/book19/200/300', description: '인류 문명의 운명을 바꾼 힘의 역사.', category: '인문', avgRating: 4.4, ratingCount: 3800),
    Book(id: 20, title: '클린 코드', author: '로버트 C. 마틴', publisher: '인사이트', coverUrl: 'https://picsum.photos/seed/book20/200/300', description: '애자일 소프트웨어 장인 정신. 깨끗한 코드 작성법.', category: 'IT', avgRating: 4.3, ratingCount: 2100),
    Book(id: 21, title: '이기적 유전자', author: '리처드 도킨스', publisher: '을유문화사', coverUrl: 'https://picsum.photos/seed/book21/200/300', description: '진화론의 새로운 패러다임을 제시한 과학 명저.', category: '과학', avgRating: 4.4, ratingCount: 3500),
    Book(id: 22, title: '채식주의자', author: '한강', publisher: '창비', coverUrl: 'https://picsum.photos/seed/book22/200/300', description: '한 여자의 채식 선언이 불러온 파장. 맨부커상 수상작.', category: '소설', avgRating: 4.2, ratingCount: 4800),
  ];

  static final List<Profile> profiles = [
    Profile(id: 'me', username: 'bookworm', displayName: '책벌레', avatarUrl: 'https://picsum.photos/seed/avatar0/100/100', bio: '하루에 한 권씩 읽는 게 목표 📚', booksCount: 42, reviewsCount: 15, followersCount: 128, followingCount: 67),
    Profile(id: 'u1', username: 'novel_lover', displayName: '소설덕후', avatarUrl: 'https://picsum.photos/seed/avatar1/100/100', bio: '소설만 읽습니다', booksCount: 156, reviewsCount: 89, followersCount: 342, followingCount: 120),
    Profile(id: 'u2', username: 'science_reader', displayName: '과학읽는사람', avatarUrl: 'https://picsum.photos/seed/avatar2/100/100', bio: '과학 서적 전문', booksCount: 78, reviewsCount: 45, followersCount: 210, followingCount: 88),
    Profile(id: 'u3', username: 'bookstagram', displayName: '북스타그램', avatarUrl: 'https://picsum.photos/seed/avatar3/100/100', bio: '예쁜 책 사진 찍기', booksCount: 203, reviewsCount: 167, followersCount: 1520, followingCount: 340),
    Profile(id: 'u4', username: 'midnight_reader', displayName: '밤독서', avatarUrl: 'https://picsum.photos/seed/avatar4/100/100', bio: '밤에 읽는 책이 제일 좋아', booksCount: 95, reviewsCount: 52, followersCount: 88, followingCount: 45),
  ];

  static final List<Review> reviews = [
    Review(id: 1, userId: 'u1', bookId: 1, content: '감정을 느끼지 못하는 주인공의 시선으로 바라보는 세상이 정말 신선했어요. 후반부에 눈물이 났습니다.', likesCount: 34, createdAt: DateTime.now().subtract(const Duration(hours: 2)), username: '소설덕후', avatarUrl: 'https://picsum.photos/seed/avatar1/100/100', bookTitle: '아몬드', bookCoverUrl: 'https://picsum.photos/seed/book1/200/300', bookAuthor: '손원평', rating: 4.5),
    Review(id: 2, userId: 'u2', bookId: 15, content: '칼 세이건의 우주에 대한 경외심이 그대로 전해집니다. 과학책이지만 시처럼 읽히는 책.', likesCount: 56, createdAt: DateTime.now().subtract(const Duration(hours: 5)), username: '과학읽는사람', avatarUrl: 'https://picsum.photos/seed/avatar2/100/100', bookTitle: '코스모스', bookCoverUrl: 'https://picsum.photos/seed/book15/200/300', bookAuthor: '칼 세이건', rating: 5.0),
    Review(id: 3, userId: 'u3', bookId: 3, content: '꿈을 사고파는 백화점이라니! 상상력이 대단해요. 잠들기 전에 읽으면 정말 좋은 꿈 꿀 것 같아요 ✨', likesCount: 89, createdAt: DateTime.now().subtract(const Duration(hours: 8)), username: '북스타그램', avatarUrl: 'https://picsum.photos/seed/avatar3/100/100', bookTitle: '달러구트 꿈 백화점', bookCoverUrl: 'https://picsum.photos/seed/book3/200/300', bookAuthor: '이미예', rating: 4.5),
    Review(id: 4, userId: 'u4', bookId: 12, content: '물고기는 존재하지 않는다니... 제목부터 충격이었는데 내용은 더 충격. 분류학의 역사를 이렇게 흥미진진하게 풀어낼 수 있다니.', likesCount: 42, createdAt: DateTime.now().subtract(const Duration(days: 1)), username: '밤독서', avatarUrl: 'https://picsum.photos/seed/avatar4/100/100', bookTitle: '물고기는 존재하지 않는다', bookCoverUrl: 'https://picsum.photos/seed/book12/200/300', bookAuthor: '룰루 밀러', rating: 4.5),
    Review(id: 5, userId: 'u1', bookId: 22, content: '한강 작가의 문체가 주는 섬뜩한 아름다움. 읽는 내내 불편했지만 눈을 뗄 수 없었어요.', hasSpoiler: true, likesCount: 67, createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)), username: '소설덕후', avatarUrl: 'https://picsum.photos/seed/avatar1/100/100', bookTitle: '채식주의자', bookCoverUrl: 'https://picsum.photos/seed/book22/200/300', bookAuthor: '한강', rating: 4.0),
    Review(id: 6, userId: 'u3', bookId: 18, content: '어른이 되어 다시 읽으니 완전히 다른 책이었어요. "가장 중요한 건 눈에 보이지 않아." 이 문장이 계속 맴돕니다.', likesCount: 123, createdAt: DateTime.now().subtract(const Duration(days: 2)), username: '북스타그램', avatarUrl: 'https://picsum.photos/seed/avatar3/100/100', bookTitle: '어린 왕자', bookCoverUrl: 'https://picsum.photos/seed/book18/200/300', bookAuthor: '생텍쥐페리', rating: 5.0),
    Review(id: 7, userId: 'u2', bookId: 16, content: '인류 역사를 이렇게 거시적으로 바라볼 수 있다니. 읽고 나면 세상을 보는 눈이 달라집니다.', likesCount: 78, createdAt: DateTime.now().subtract(const Duration(days: 3)), username: '과학읽는사람', avatarUrl: 'https://picsum.photos/seed/avatar2/100/100', bookTitle: '사피엔스', bookCoverUrl: 'https://picsum.photos/seed/book16/200/300', bookAuthor: '유발 하라리', rating: 4.5),
    Review(id: 8, userId: 'u4', bookId: 5, content: '삶의 선택지가 무한하다면? 이 질문에 대한 가장 아름다운 답을 이 책에서 찾았어요.', likesCount: 31, createdAt: DateTime.now().subtract(const Duration(days: 4)), username: '밤독서', avatarUrl: 'https://picsum.photos/seed/avatar4/100/100', bookTitle: '미드나잇 라이브러리', bookCoverUrl: 'https://picsum.photos/seed/book5/200/300', bookAuthor: '매트 헤이그', rating: 4.0),
  ];

  static final List<UserBook> userBooks = [
    UserBook(id: 1, bookId: 1, status: BookStatus.completed, rating: 4.5, readDate: DateTime(2026, 2, 15), bookTitle: '아몬드', bookCoverUrl: 'https://picsum.photos/seed/book1/200/300', bookAuthor: '손원평'),
    UserBook(id: 2, bookId: 3, status: BookStatus.completed, rating: 5.0, readDate: DateTime(2026, 2, 10), bookTitle: '달러구트 꿈 백화점', bookCoverUrl: 'https://picsum.photos/seed/book3/200/300', bookAuthor: '이미예'),
    UserBook(id: 3, bookId: 15, status: BookStatus.completed, rating: 4.5, readDate: DateTime(2026, 1, 20), bookTitle: '코스모스', bookCoverUrl: 'https://picsum.photos/seed/book15/200/300', bookAuthor: '칼 세이건'),
    UserBook(id: 4, bookId: 16, status: BookStatus.reading, rating: null, bookTitle: '사피엔스', bookCoverUrl: 'https://picsum.photos/seed/book16/200/300', bookAuthor: '유발 하라리'),
    UserBook(id: 5, bookId: 12, status: BookStatus.reading, rating: null, bookTitle: '물고기는 존재하지 않는다', bookCoverUrl: 'https://picsum.photos/seed/book12/200/300', bookAuthor: '룰루 밀러'),
    UserBook(id: 6, bookId: 14, status: BookStatus.wantToRead, rating: null, bookTitle: '해리 포터와 마법사의 돌', bookCoverUrl: 'https://picsum.photos/seed/book14/200/300', bookAuthor: 'J.K. 롤링'),
    UserBook(id: 7, bookId: 17, status: BookStatus.wantToRead, rating: null, bookTitle: '데미안', bookCoverUrl: 'https://picsum.photos/seed/book17/200/300', bookAuthor: '헤르만 헤세'),
    UserBook(id: 8, bookId: 19, status: BookStatus.wantToRead, rating: null, bookTitle: '총, 균, 쇠', bookCoverUrl: 'https://picsum.photos/seed/book19/200/300', bookAuthor: '재레드 다이아몬드'),
    UserBook(id: 9, bookId: 22, status: BookStatus.completed, rating: 4.0, readDate: DateTime(2026, 1, 5), bookTitle: '채식주의자', bookCoverUrl: 'https://picsum.photos/seed/book22/200/300', bookAuthor: '한강'),
  ];

  static Book getBook(int id) => books.firstWhere((b) => b.id == id);

  static List<Book> searchBooks(String query) {
    final q = query.toLowerCase();
    return books.where((b) =>
      b.title.toLowerCase().contains(q) ||
      b.author.toLowerCase().contains(q) ||
      b.category.toLowerCase().contains(q)
    ).toList();
  }

  static List<Book> get bestsellers => books.where((b) => (b.ratingCount ?? 0) > 2000).toList()
    ..sort((a, b) => (b.ratingCount ?? 0).compareTo(a.ratingCount ?? 0));

  static List<Book> get newBooks => books.take(8).toList();

  static List<Review> getBookReviews(int bookId) =>
    reviews.where((r) => r.bookId == bookId).toList();

  static List<UserBook> getUserBooks(BookStatus status) =>
    userBooks.where((ub) => ub.status == status).toList();

  static Profile get currentUser => profiles.first;
}
