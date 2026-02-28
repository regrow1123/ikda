import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../data/models/review.dart';

class ReviewCard extends StatefulWidget {
  final Review review;
  final bool showBookInfo;

  const ReviewCard({super.key, required this.review, this.showBookInfo = false});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _spoilerRevealed = false;

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info row
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: review.avatarUrl != null
                    ? CachedNetworkImageProvider(review.avatarUrl!)
                    : null,
                  child: review.avatarUrl == null ? const Icon(Icons.person, size: 18) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.username, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        timeago.format(review.createdAt, locale: 'ko'),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (review.rating != null) ...[
                  Icon(Icons.star, size: 16, color: Colors.amber[700]),
                  const SizedBox(width: 2),
                  Text(review.rating!.toStringAsFixed(1), style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ],
            ),

            // Book info (for feed)
            if (widget.showBookInfo && review.bookTitle != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (review.bookCoverUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: review.bookCoverUrl!,
                        width: 36, height: 52, fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.bookTitle!, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                        if (review.bookAuthor != null)
                          Text(review.bookAuthor!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Review content
            if (review.hasSpoiler && !_spoilerRevealed)
              GestureDetector(
                onTap: () => setState(() => _spoilerRevealed = true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.visibility_off, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(height: 4),
                      Text('스포일러 포함 — 탭하여 보기', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              )
            else
              Text(review.content, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 10),

            // Like button
            Row(
              children: [
                Icon(Icons.favorite_border, size: 18, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${review.likesCount}', style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
