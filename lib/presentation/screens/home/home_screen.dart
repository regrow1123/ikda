import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/book.dart';
import '../../../providers/book_provider.dart';
import '../../widgets/book_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestsellers = ref.watch(bestsellersProvider);
    final newBooks = ref.watch(newBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('읽다', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(bestsellersProvider);
          ref.invalidate(newBooksProvider);
        },
        child: ListView(
          children: [
            _asyncSection(context, '🔥 베스트셀러', bestsellers),
            _asyncSection(context, '📖 신간', newBooks),
          ],
        ),
      ),
    );
  }

  Widget _asyncSection(BuildContext context, String title, AsyncValue<List<Book>> value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        value.when(
          data: (books) => SizedBox(
            height: 240,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: books.length,
              separatorBuilder: (_, _a) => const SizedBox(width: 12),
              itemBuilder: (_, i) => BookCard(book: books[i]),
            ),
          ),
          loading: () => const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => SizedBox(
            height: 100,
            child: Center(child: Text('불러오기 실패: $e')),
          ),
        ),
      ],
    );
  }
}
