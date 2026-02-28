import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/recommendation_provider.dart';

class RecommendationScreen extends ConsumerWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(recommendedBooksProvider);
    final reasons = ref.watch(recommendationReasonsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('맞춤 추천'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (_, i) {
          final book = books[i];
          final reason = reasons[book.id] ?? '당신의 독서 취향에 맞는 책';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => context.push('/book/${book.id}'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 순위 뱃지
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${i + 1}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: i < 3 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    // 표지
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: book.coverUrl,
                        width: 60, height: 86, fit: BoxFit.cover,
                        errorWidget: (_, _a, _b) => Container(
                          width: 60, height: 86,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.book),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // 정보
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(book.author, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 6),
                          // 추천 이유
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome, size: 14, color: theme.colorScheme.primary),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    reason,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontSize: 11,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (book.avgRating != null)
                            Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.amber[700]),
                                const SizedBox(width: 2),
                                Text(book.avgRating!.toStringAsFixed(1), style: theme.textTheme.bodySmall),
                                Text(' · ${book.category}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
