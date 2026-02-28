import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/book.dart';
import '../../../providers/book_provider.dart';
import '../../../providers/recommendation_provider.dart';
import '../../widgets/book_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestsellers = ref.watch(bestsellersProvider);
    final newBooks = ref.watch(newBooksProvider);
    final recommended = ref.watch(recommendedBooksProvider);
    final reasons = ref.watch(recommendationReasonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ikda(읽다)', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(bestsellersProvider);
          ref.invalidate(newBooksProvider);
        },
        child: ListView(
          children: [
            // 맞춤 추천 배너
            _recommendationBanner(context, recommended, reasons),
            _asyncSection(context, '베스트셀러', bestsellers),
            _asyncSection(context, '신간', newBooks),
          ],
        ),
      ),
    );
  }

  Widget _recommendationBanner(BuildContext context, List<Book> books, Map<int, String> reasons) {
    if (books.isEmpty) return const SizedBox.shrink();
    final top3 = books.take(3).toList();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.push('/recommendations'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primaryContainer, theme.colorScheme.tertiaryContainer],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 6),
                Text('맞춤 추천', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                const Spacer(),
                Text('더보기 →', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: top3.map((book) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: book.coverUrl,
                          height: 90, width: 60, fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(book.title, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )).toList(),
            ),
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
