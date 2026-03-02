import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/highlight.dart';
import '../data/services/mock_data_service.dart';

final _supabase = Supabase.instance.client;

// 더미 유저 ID (Auth 구현 전)
const _dummyUserId = '00000000-0000-0000-0000-000000000001';

/// 내 하이라이트 목록
final myHighlightsProvider = StateNotifierProvider<HighlightListNotifier, List<Highlight>>((ref) {
  return HighlightListNotifier()..loadFromDb();
});

/// 특정 책의 하이라이트
final bookHighlightsProvider = Provider.family<List<Highlight>, int>((ref, bookId) {
  final all = ref.watch(myHighlightsProvider);
  return all.where((h) => h.bookId == bookId).toList();
});

class HighlightListNotifier extends StateNotifier<List<Highlight>> {
  HighlightListNotifier() : super([]);

  Future<void> loadFromDb() async {
    try {
      final res = await _supabase
          .from('highlights')
          .select()
          .eq('user_id', _dummyUserId)
          .order('created_at', ascending: false);

      state = (res as List).map((e) => Highlight.fromJson(e)).toList();
    } catch (_) {
      // DB 연결 실패 시 목 데이터 사용
      state = MockDataService.highlights;
    }
  }

  Future<void> add(Highlight h) async {
    try {
      // 더미 유저 프로필이 없으면 생성
      await _ensureDummyProfile();

      final data = h.copyWith(userId: _dummyUserId).toJson();
      final res = await _supabase
          .from('highlights')
          .insert(data)
          .select()
          .single();

      final saved = Highlight.fromJson(res).copyWith(
        bookTitle: h.bookTitle,
        bookCoverUrl: h.bookCoverUrl,
        bookAuthor: h.bookAuthor,
      );
      state = [saved, ...state];
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ Highlight insert 실패: $e');
      // DB 실패 시 로컬에만 추가
      final newH = Highlight(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: h.userId,
        bookId: h.bookId,
        quote: h.quote,
        myNote: h.myNote,
        pageNumber: h.pageNumber,
        chapterContext: h.chapterContext,
        mood: h.mood,
        llmConversation: h.llmConversation,
        llmSummary: h.llmSummary,
        illustrationUrl: h.illustrationUrl,
        illustrationPrompt: h.illustrationPrompt,
        isPublic: h.isPublic,
        bookTitle: h.bookTitle,
        bookCoverUrl: h.bookCoverUrl,
        bookAuthor: h.bookAuthor,
      );
      state = [newH, ...state];
    }
  }

  Future<void> update(Highlight h) async {
    try {
      await _supabase
          .from('highlights')
          .update(h.toJson())
          .eq('id', h.id);
    } catch (_) {}
    state = state.map((e) => e.id == h.id ? h : e).toList();
  }

  Future<void> remove(int id) async {
    try {
      await _supabase.from('highlights').delete().eq('id', id);
    } catch (_) {}
    state = state.where((e) => e.id != id).toList();
  }

  Future<void> _ensureDummyProfile() async {
    // 더미 프로필은 DB에 직접 생성됨 (auth.users FK 제약)
    // 여기서는 아무것도 안 함
  }
}
