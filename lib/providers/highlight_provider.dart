import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/highlight.dart';
import '../data/services/mock_data_service.dart';

/// 내 하이라이트 목록
final myHighlightsProvider = StateNotifierProvider<HighlightListNotifier, List<Highlight>>((ref) {
  return HighlightListNotifier();
});

/// 특정 책의 하이라이트
final bookHighlightsProvider = Provider.family<List<Highlight>, int>((ref, bookId) {
  final all = ref.watch(myHighlightsProvider);
  return all.where((h) => h.bookId == bookId).toList();
});

class HighlightListNotifier extends StateNotifier<List<Highlight>> {
  HighlightListNotifier() : super(MockDataService.highlights);

  void add(Highlight h) {
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

  void update(Highlight h) {
    state = state.map((e) => e.id == h.id ? h : e).toList();
  }

  void remove(int id) {
    state = state.where((e) => e.id != id).toList();
  }
}
