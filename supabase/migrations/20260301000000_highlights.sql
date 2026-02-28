-- updated_at 자동 갱신 함수
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 문구 스크랩 (하이라이트) 테이블
CREATE TABLE IF NOT EXISTS highlights (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  book_id BIGINT NOT NULL,  -- 알라딘 itemId
  quote TEXT NOT NULL,       -- 발췌 문구
  my_note TEXT,              -- 내 메모
  page_number INT,           -- 페이지 번호 (선택)
  chapter_context TEXT,      -- 챕터/맥락 (선택)
  mood TEXT,                 -- 감정 태그 (감동, 슬픔, 영감 등)
  llm_conversation JSONB DEFAULT '[]'::jsonb,  -- LLM 대화 기록
  llm_summary TEXT,          -- LLM이 생성한 성찰 요약
  illustration_url TEXT,     -- SD 생성 일러스트 URL
  illustration_prompt TEXT,  -- SD에 사용된 프롬프트
  voice_memo_url TEXT,       -- 음성 메모 URL (향후)
  is_public BOOLEAN DEFAULT false,  -- 피드 공개 여부
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 인덱스
CREATE INDEX idx_highlights_user_id ON highlights(user_id);
CREATE INDEX idx_highlights_book_id ON highlights(book_id);
CREATE INDEX idx_highlights_created_at ON highlights(created_at DESC);

-- RLS
ALTER TABLE highlights ENABLE ROW LEVEL SECURITY;

CREATE POLICY "highlights_select" ON highlights
  FOR SELECT USING (user_id = auth.uid() OR is_public = true);

CREATE POLICY "highlights_insert" ON highlights
  FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "highlights_update" ON highlights
  FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "highlights_delete" ON highlights
  FOR DELETE USING (user_id = auth.uid());

-- updated_at 자동 갱신 트리거
CREATE TRIGGER highlights_updated_at
  BEFORE UPDATE ON highlights
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
