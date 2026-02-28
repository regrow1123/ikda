import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../providers/book_provider.dart';
import '../../../providers/review_provider.dart';
import '../../../providers/highlight_provider.dart';
import '../../widgets/review_card.dart';
import '../highlight/highlight_add_screen.dart';

class BookDetailScreen extends ConsumerWidget {
  final int bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookAsync = ref.watch(bookDetailProvider(bookId));
    final reviews = ref.watch(bookReviewsProvider(bookId));
    final theme = Theme.of(context);

    return bookAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('오류: $e'))),
      data: (book) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.surface,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: book.coverUrl,
                          width: 140,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(book.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(book.author, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    Text('${book.publisher} · ${book.category}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 12),
                    if (book.avgRating != null) ...[
                      RatingBarIndicator(
                        rating: book.avgRating!,
                        itemBuilder: (_, _a) => const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 24,
                      ),
                      const SizedBox(height: 4),
                      Text('${book.avgRating!.toStringAsFixed(1)}${book.ratingCount != null ? " (${book.ratingCount}명)" : ""}', style: theme.textTheme.bodySmall),
                    ],
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text('내 책장에 추가'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          label: const Text('리뷰 쓰기'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => HighlightAddScreen(
                                  bookId: book.id,
                                  bookTitle: book.title,
                                  bookAuthor: book.author,
                                  bookCoverUrl: book.coverUrl,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.bookmark_add),
                          label: const Text('문구 스크랩'),
                        ),
                      ],
                    ),
                    if (book.description.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(book.description, style: theme.textTheme.bodyMedium),
                      ),
                    ],
                    const SizedBox(height: 24),
                    // 이 책의 스크랩
                    Builder(builder: (context) {
                      final highlights = ref.watch(bookHighlightsProvider(bookId));
                      if (highlights.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('내 스크랩 ${highlights.length}개', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...highlights.map((h) => Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(h.quote, style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic)),
                                if (h.mood != null) ...[
                                  const SizedBox(height: 4),
                                  Chip(label: Text(h.mood!, style: const TextStyle(fontSize: 11)), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
                                ],
                              ],
                            ),
                          )),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('리뷰 ${reviews.length}개', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            if (reviews.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('아직 리뷰가 없어요. 첫 리뷰를 남겨보세요!')),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ReviewCard(review: reviews[i]),
                  childCount: reviews.length,
                ),
              ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
          ],
        ),
      ),
    );
  }
}
