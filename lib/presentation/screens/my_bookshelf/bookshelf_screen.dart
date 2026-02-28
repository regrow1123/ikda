import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/user_book.dart';
import '../../../providers/bookshelf_provider.dart';

class BookshelfScreen extends ConsumerWidget {
  const BookshelfScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내 책장'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '읽는 중'),
              Tab(text: '완독'),
              Tab(text: '읽고 싶은'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookList(status: BookStatus.reading, ref: ref),
            _BookList(status: BookStatus.completed, ref: ref),
            _BookList(status: BookStatus.wantToRead, ref: ref),
          ],
        ),
      ),
    );
  }
}

class _BookList extends StatelessWidget {
  final BookStatus status;
  final WidgetRef ref;

  const _BookList({required this.status, required this.ref});

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(bookshelfProvider(status));
    final theme = Theme.of(context);

    if (books.isEmpty) {
      return const Center(child: Text('아직 책이 없어요'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (_, i) {
        final ub = books[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => context.push('/book/${ub.bookId}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: ub.bookCoverUrl ?? '',
                      width: 50, height: 72, fit: BoxFit.cover,
                      errorWidget: (_ , _a, _b) => Container(width: 50, height: 72, color: theme.colorScheme.surfaceContainerHighest),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ub.bookTitle ?? '', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        Text(ub.bookAuthor ?? '', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  if (ub.rating != null) ...[
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 2),
                    Text(ub.rating!.toStringAsFixed(1), style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
