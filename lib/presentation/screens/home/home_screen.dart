import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/book_provider.dart';
import '../../widgets/book_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestsellers = ref.watch(bestsellersProvider);
    final newBooks = ref.watch(newBooksProvider);
    final allBooks = ref.watch(allBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('읽다', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          _section(context, '🔥 베스트셀러', bestsellers),
          _section(context, '📖 신간', newBooks),
          _section(context, '전체 도서', allBooks),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: books.length,
            separatorBuilder: (_ , _a) => const SizedBox(width: 12),
            itemBuilder: (_, i) => BookCard(book: books[i]),
          ),
        ),
      ],
    );
  }
}
