import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/book.dart';
import '../data/services/mock_data_service.dart';

/// 더미 추천 데이터 — 나중에 협업 필터링으로 교체
final recommendedBooksProvider = Provider<List<Book>>((ref) {
  // 현재: 목 데이터에서 평점 높은 순으로 추천
  final books = List<Book>.from(MockDataService.books)
    ..sort((a, b) => (b.avgRating ?? 0).compareTo(a.avgRating ?? 0));
  return books.take(10).toList();
});

/// 추천 이유 (더미)
final recommendationReasonsProvider = Provider<Map<int, String>>((ref) {
  return {
    15: '과학 카테고리를 좋아하는 유저들이 극찬한 책',
    14: '당신이 좋아한 "아몬드"를 높게 평가한 유저들의 픽',
    18: '비슷한 취향의 유저 89%가 ⭐ 4.5 이상 준 책',
    12: '"코스모스"를 좋아한 유저들이 함께 읽은 책',
    16: '이번 달 비슷한 취향 유저들의 인기 도서',
    22: '한강 작가 팬들이 가장 많이 읽은 책',
    13: '소설 카테고리 취향 매칭률 94%',
    17: '"어린 왕자"를 좋아한 유저들의 다음 선택',
    21: '과학 카테고리 유저들의 숨은 명작',
    19: '인문 분야 취향이 비슷한 유저 추천 1위',
  };
});
