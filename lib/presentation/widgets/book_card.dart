import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool showRating;

  const BookCard({super.key, required this.book, this.showRating = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/book/${book.id}'),
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: book.coverUrl,
                width: 120,
                height: 170,
                fit: BoxFit.cover,
                placeholder: (_ , _a) => Container(
                  width: 120, height: 170,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.book, size: 40),
                ),
                errorWidget: (_ , _a, _b) => Container(
                  width: 120, height: 170,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.book, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              book.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              book.author,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (showRating && book.avgRating != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.star, size: 12, color: Colors.amber[700]),
                  const SizedBox(width: 2),
                  Text(
                    book.avgRating!.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
