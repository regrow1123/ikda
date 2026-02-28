# 읽다 (ikda) — Technical Design Document

## 1. 아키텍처 개요

```
┌─────────────────────────────────────────┐
│           Flutter App (Dart)            │
│      iOS / Android / Web                │
├─────────────────────────────────────────┤
│  State Management: Riverpod             │
│  Routing: GoRouter                      │
│  HTTP: Dio                              │
└──────────────┬──────────────────────────┘
               │
       ┌───────┴───────┐
       │               │
┌──────▼──────┐  ┌─────▼──────┐
│  Supabase   │  │ 알라딘 API  │
│  (Backend)  │  │ 네이버 API  │
└─────────────┘  └────────────┘
```

---

## 2. 기술 스택

| 레이어 | 기술 |
|--------|------|
| Frontend | Flutter 3.x, Dart |
| State | Riverpod 2.x |
| Routing | GoRouter |
| Backend | Supabase (PostgreSQL, Auth, Storage, Edge Functions) |
| 책 데이터 | 알라딘 Open API, 네이버 검색 API |
| CI/CD | GitHub Actions |
| 배포 | Firebase Hosting (Web), App Store, Play Store |

---

## 3. Supabase 데이터베이스 스키마

### 3.1 profiles
```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

### 3.2 books (캐시)
```sql
CREATE TABLE books (
  id BIGSERIAL PRIMARY KEY,
  aladin_id TEXT UNIQUE,        -- 알라딘 ISBN/ItemId
  isbn13 TEXT UNIQUE,
  title TEXT NOT NULL,
  author TEXT,
  publisher TEXT,
  pub_date DATE,
  cover_url TEXT,
  description TEXT,
  category TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

### 3.3 user_books (내 책장)
```sql
CREATE TYPE book_status AS ENUM ('reading', 'completed', 'want_to_read');

CREATE TABLE user_books (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  book_id BIGINT REFERENCES books(id) ON DELETE CASCADE,
  status book_status NOT NULL DEFAULT 'want_to_read',
  rating NUMERIC(2,1) CHECK (rating >= 0.5 AND rating <= 5.0),
  read_date DATE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, book_id)
);
```

### 3.4 reviews
```sql
CREATE TABLE reviews (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  book_id BIGINT REFERENCES books(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  has_spoiler BOOLEAN DEFAULT false,
  likes_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, book_id)
);
```

### 3.5 review_likes
```sql
CREATE TABLE review_likes (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  review_id BIGINT REFERENCES reviews(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, review_id)
);
```

### 3.6 follows
```sql
CREATE TABLE follows (
  follower_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  following_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (follower_id, following_id),
  CHECK (follower_id != following_id)
);
```

---

## 4. Row Level Security (RLS)

```sql
-- profiles: 누구나 읽기, 본인만 수정
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read" ON profiles FOR SELECT USING (true);
CREATE POLICY "Own update" ON profiles FOR UPDATE USING (auth.uid() = id);

-- user_books: 누구나 읽기, 본인만 CUD
ALTER TABLE user_books ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read" ON user_books FOR SELECT USING (true);
CREATE POLICY "Own insert" ON user_books FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Own update" ON user_books FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Own delete" ON user_books FOR DELETE USING (auth.uid() = user_id);

-- reviews: 동일 패턴
-- review_likes: 동일 패턴
-- follows: 동일 패턴
```

---

## 5. API 연동

### 5.1 알라딘 API
- **검색:** `GET /ItemSearch.aspx?Query={keyword}&QueryType=Keyword&Output=JS`
- **상세:** `GET /ItemLookUp.aspx?ItemId={id}&Output=JS`
- **베스트셀러:** `GET /ItemList.aspx?QueryType=Bestseller&Output=JS`
- **신간:** `GET /ItemList.aspx?QueryType=ItemNewAll&Output=JS`
- TTB 키 필요 (무료 발급)

### 5.2 네이버 책 검색 API
- **검색:** `GET /v1/search/book.json?query={keyword}`
- Client ID/Secret 필요 (무료)
- 알라딘 검색 결과가 부족할 때 보조로 사용

### 5.3 책 데이터 플로우
1. 유저가 검색 → 알라딘 API 호출
2. 결과에서 책 선택 → `books` 테이블에 캐싱 (없으면 INSERT)
3. 이후 해당 책 참조는 내부 `book_id` 사용

---

## 6. Flutter 프로젝트 구조

```
lib/
├── main.dart
├── app/
│   ├── app.dart              # MaterialApp, GoRouter
│   └── theme.dart            # 테마 정의
├── core/
│   ├── constants/
│   ├── utils/
│   └── extensions/
├── data/
│   ├── models/               # Freezed 모델
│   │   ├── book.dart
│   │   ├── review.dart
│   │   ├── user_book.dart
│   │   └── profile.dart
│   ├── repositories/         # Supabase/API 호출
│   │   ├── auth_repository.dart
│   │   ├── book_repository.dart
│   │   ├── review_repository.dart
│   │   ├── user_book_repository.dart
│   │   └── social_repository.dart
│   └── services/
│       ├── aladin_service.dart
│       └── naver_book_service.dart
├── providers/                # Riverpod providers
│   ├── auth_provider.dart
│   ├── book_provider.dart
│   ├── review_provider.dart
│   └── social_provider.dart
└── presentation/
    ├── screens/
    │   ├── auth/
    │   ├── home/              # 탐색 탭
    │   ├── search/
    │   ├── book_detail/
    │   ├── my_bookshelf/
    │   ├── profile/
    │   ├── feed/              # 소셜 피드
    │   └── review/
    └── widgets/
        ├── book_card.dart
        ├── rating_bar.dart
        ├── review_card.dart
        └── user_avatar.dart
```

---

## 7. 주요 패키지

```yaml
dependencies:
  flutter_riverpod: ^2.5.0
  go_router: ^14.0.0
  supabase_flutter: ^2.5.0
  dio: ^5.4.0
  freezed_annotation: ^2.4.0
  flutter_rating_bar: ^4.0.1
  cached_network_image: ^3.3.0
  intl: ^0.19.0
  hive_flutter: ^1.1.0       # 오프라인 캐싱

dev_dependencies:
  freezed: ^2.5.0
  json_serializable: ^6.8.0
  build_runner: ^2.4.0
```

---

## 8. 네비게이션 구조

```
BottomNavigationBar:
├── 홈 (탐색)        → /home
├── 검색             → /search
├── 내 책장          → /bookshelf
├── 피드 (소셜)      → /feed
└── 프로필 (내)      → /profile

기타:
├── 책 상세          → /book/:id
├── 리뷰 작성        → /book/:id/review
├── 유저 프로필      → /user/:id
└── 로그인/가입      → /auth
```

---

## 9. 인덱스

```sql
CREATE INDEX idx_user_books_user ON user_books(user_id);
CREATE INDEX idx_user_books_book ON user_books(book_id);
CREATE INDEX idx_reviews_book ON reviews(book_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_created ON reviews(created_at DESC);
CREATE INDEX idx_follows_follower ON follows(follower_id);
CREATE INDEX idx_follows_following ON follows(following_id);
CREATE INDEX idx_books_isbn ON books(isbn13);
```

---

## 10. Phase 2 기술 고려사항

- **추천 엔진:** Supabase Edge Function + PostgreSQL 기반 협업 필터링, 또는 별도 Python 서비스 (scikit-surprise)
- **알림:** Supabase Realtime + FCM/APNs
- **검색 고도화:** Supabase Full-Text Search 또는 Meilisearch
