import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/book.dart';
import '../data/services/aladin_service.dart';
import '../data/services/mock_data_service.dart';

/// 베스트셀러 (알라딘 API)
final bestsellersProvider = FutureProvider<List<Book>>((ref) async {
  try {
    return await AladinService.bestsellers();
  } catch (_) {
    return MockDataService.bestsellers; // fallback
  }
});

/// 신간 (알라딘 API)
final newBooksProvider = FutureProvider<List<Book>>((ref) async {
  try {
    return await AladinService.newBooks();
  } catch (_) {
    return MockDataService.newBooks;
  }
});

/// 검색
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Book>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  try {
    return await AladinService.search(query);
  } catch (_) {
    return MockDataService.searchBooks(query);
  }
});

/// 책 상세 (ID로 로컬 캐시 → 알라딘 fallback)
final bookDetailProvider = FutureProvider.family<Book, int>((ref, id) async {
  // 먼저 베스트셀러/신간에서 찾기
  final best = ref.read(bestsellersProvider).valueOrNull ?? [];
  final news = ref.read(newBooksProvider).valueOrNull ?? [];
  final all = [...best, ...news];
  final cached = all.where((b) => b.id == id);
  if (cached.isNotEmpty) return cached.first;

  // 목 데이터 fallback
  try {
    return MockDataService.getBook(id);
  } catch (_) {
    return Book(id: id, title: '로딩 중...', author: '', publisher: '', coverUrl: '');
  }
});
