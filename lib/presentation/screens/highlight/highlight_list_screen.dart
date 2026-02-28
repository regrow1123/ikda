import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/highlight_provider.dart';
import '../../../data/models/highlight.dart';

class HighlightListScreen extends ConsumerWidget {
  const HighlightListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlights = ref.watch(myHighlightsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 스크랩'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/highlight/add'),
        child: const Icon(Icons.add),
      ),
      body: highlights.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('아직 저장한 문구가 없어요', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.outline)),
                  const SizedBox(height: 8),
                  Text('책에서 마음에 드는 문구를 스크랩해보세요', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: highlights.length,
              itemBuilder: (context, index) {
                final h = highlights[index];
                return _HighlightCard(highlight: h);
              },
            ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final Highlight highlight;
  const _HighlightCard({required this.highlight});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/highlight/${highlight.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 책 정보
              if (highlight.bookTitle != null)
                Row(
                  children: [
                    Icon(Icons.book, size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${highlight.bookTitle}${highlight.bookAuthor != null ? ' · ${highlight.bookAuthor}' : ''}',
                        style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              if (highlight.bookTitle != null) const SizedBox(height: 12),

              // 인용문
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(color: theme.colorScheme.primary, width: 3),
                  ),
                ),
                child: Text(
                  highlight.quote,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
              ),

              // 메모
              if (highlight.myNote != null) ...[
                const SizedBox(height: 10),
                Text(highlight.myNote!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],

              // 감정 태그 + 일러스트 아이콘
              const SizedBox(height: 10),
              Row(
                children: [
                  if (highlight.mood != null)
                    Chip(
                      label: Text(highlight.mood!, style: const TextStyle(fontSize: 12)),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                  const Spacer(),
                  if (highlight.illustrationUrl != null)
                    Icon(Icons.palette, size: 16, color: theme.colorScheme.tertiary),
                  if (highlight.llmSummary != null) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.auto_awesome, size: 16, color: theme.colorScheme.secondary),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
