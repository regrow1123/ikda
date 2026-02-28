import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/book.dart';
import '../data/services/mock_data_service.dart';

final allBooksProvider = Provider<List<Book>>((ref) => MockDataService.books);

final bestsellersProvider = Provider<List<Book>>((ref) => MockDataService.bestsellers);

final newBooksProvider = Provider<List<Book>>((ref) => MockDataService.newBooks);

final bookDetailProvider = Provider.family<Book, int>((ref, id) => MockDataService.getBook(id));

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<Book>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return MockDataService.books;
  return MockDataService.searchBooks(query);
});
