-- ============================================
-- 읽다 (ikda) - Initial Database Schema
-- ============================================

-- 1. profiles
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "Own insert profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Own update profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, username, display_name)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', 'user_' || LEFT(NEW.id::text, 8)),
    COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.raw_user_meta_data->>'full_name', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- 2. books (알라딘 데이터 캐시)
CREATE TABLE books (
  id BIGSERIAL PRIMARY KEY,
  aladin_id TEXT UNIQUE,
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

ALTER TABLE books ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read books" ON books FOR SELECT USING (true);
CREATE POLICY "Authenticated insert books" ON books FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- 3. user_books (내 책장)
CREATE TYPE book_status AS ENUM ('reading', 'completed', 'want_to_read');

CREATE TABLE user_books (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  book_id BIGINT REFERENCES books(id) ON DELETE CASCADE NOT NULL,
  status book_status NOT NULL DEFAULT 'want_to_read',
  rating NUMERIC(2,1) CHECK (rating IS NULL OR (rating >= 0.5 AND rating <= 5.0)),
  read_date DATE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, book_id)
);

ALTER TABLE user_books ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read user_books" ON user_books FOR SELECT USING (true);
CREATE POLICY "Own insert user_books" ON user_books FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Own update user_books" ON user_books FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Own delete user_books" ON user_books FOR DELETE USING (auth.uid() = user_id);

-- 4. reviews
CREATE TABLE reviews (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  book_id BIGINT REFERENCES books(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  has_spoiler BOOLEAN DEFAULT false,
  likes_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, book_id)
);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read reviews" ON reviews FOR SELECT USING (true);
CREATE POLICY "Own insert review" ON reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Own update review" ON reviews FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Own delete review" ON reviews FOR DELETE USING (auth.uid() = user_id);

-- 5. review_likes
CREATE TABLE review_likes (
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  review_id BIGINT REFERENCES reviews(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, review_id)
);

ALTER TABLE review_likes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read review_likes" ON review_likes FOR SELECT USING (true);
CREATE POLICY "Own insert like" ON review_likes FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Own delete like" ON review_likes FOR DELETE USING (auth.uid() = user_id);

-- Trigger: update likes_count on reviews
CREATE OR REPLACE FUNCTION update_review_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE reviews SET likes_count = likes_count + 1 WHERE id = NEW.review_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE reviews SET likes_count = likes_count - 1 WHERE id = OLD.review_id;
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_review_like_change
  AFTER INSERT OR DELETE ON review_likes
  FOR EACH ROW EXECUTE FUNCTION update_review_likes_count();

-- 6. follows
CREATE TABLE follows (
  follower_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  following_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (follower_id, following_id),
  CHECK (follower_id != following_id)
);

ALTER TABLE follows ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read follows" ON follows FOR SELECT USING (true);
CREATE POLICY "Own insert follow" ON follows FOR INSERT WITH CHECK (auth.uid() = follower_id);
CREATE POLICY "Own delete follow" ON follows FOR DELETE USING (auth.uid() = follower_id);

-- ============================================
-- Indexes
-- ============================================
CREATE INDEX idx_user_books_user ON user_books(user_id);
CREATE INDEX idx_user_books_book ON user_books(book_id);
CREATE INDEX idx_reviews_book ON reviews(book_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_created ON reviews(created_at DESC);
CREATE INDEX idx_follows_follower ON follows(follower_id);
CREATE INDEX idx_follows_following ON follows(following_id);
CREATE INDEX idx_books_isbn ON books(isbn13);

-- ============================================
-- Useful views
-- ============================================

-- 책별 평균 평점 & 평점 수
CREATE VIEW book_stats AS
SELECT
  book_id,
  COUNT(*) FILTER (WHERE rating IS NOT NULL) AS rating_count,
  ROUND(AVG(rating), 1) AS avg_rating
FROM user_books
GROUP BY book_id;

-- 소셜 피드: 팔로우한 유저의 최근 리뷰
CREATE VIEW feed_reviews AS
SELECT
  r.*,
  p.username,
  p.display_name,
  p.avatar_url,
  b.title AS book_title,
  b.cover_url AS book_cover_url,
  b.author AS book_author
FROM reviews r
JOIN profiles p ON r.user_id = p.id
JOIN books b ON r.book_id = b.id
ORDER BY r.created_at DESC;
