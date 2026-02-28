import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/book_provider.dart';
import '../../widgets/book_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  Timer? _debounce;

  void _onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('검색')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: '책 제목, 저자 검색',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: query.isEmpty
              ? const Center(child: Text('검색어를 입력하세요', style: TextStyle(color: Colors.grey)))
              : results.when(
                  data: (books) => books.isEmpty
                    ? const Center(child: Text('검색 결과가 없어요'))
                    : LayoutBuilder(
                      builder: (context, constraints) {
                        final cols = (constraints.maxWidth / 160).floor().clamp(2, 6);
                        return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          childAspectRatio: 0.48,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: books.length,
                        itemBuilder: (_, i) => BookCard(book: books[i]),
                      );
                      },
                    ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('검색 실패: $e')),
                ),
          ),
        ],
      ),
    );
  }
}
