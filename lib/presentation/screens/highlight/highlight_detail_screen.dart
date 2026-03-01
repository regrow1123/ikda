import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/highlight_provider.dart';

class HighlightDetailScreen extends ConsumerWidget {
  final int highlightId;
  const HighlightDetailScreen({super.key, required this.highlightId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlights = ref.watch(myHighlightsProvider);
    final h = highlights.where((e) => e.id == highlightId).firstOrNull;
    final theme = Theme.of(context);

    if (h == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('스크랩을 찾을 수 없어요')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(h.bookTitle ?? '스크랩'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(myHighlightsProvider.notifier).remove(h.id);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 책 정보
            if (h.bookTitle != null)
              Row(
                children: [
                  Icon(Icons.book, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${h.bookTitle}${h.bookAuthor != null ? ' · ${h.bookAuthor}' : ''}',
                      style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // 인용문
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 4)),
              ),
              child: Text(
                h.quote,
                style: theme.textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic, height: 1.8),
              ),
            ),

            if (h.pageNumber != null) ...[
              const SizedBox(height: 8),
              Text('p. ${h.pageNumber}', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline)),
            ],

            // 감정 태그
            if (h.mood != null) ...[
              const SizedBox(height: 12),
              Chip(label: Text(h.mood!)),
            ],

            // 내 메모
            if (h.myNote != null) ...[
              const SizedBox(height: 20),
              Text('나의 생각', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(h.myNote!, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
            ],

            // AI 성찰 요약
            if (h.llmSummary != null) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 18, color: theme.colorScheme.secondary),
                  const SizedBox(width: 6),
                  Text('AI 성찰 요약', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.secondary)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(h.llmSummary!, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
              ),
            ],

            // 대화 기록
            if (h.llmConversation.isNotEmpty) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: Text('성찰 대화 기록', style: theme.textTheme.titleSmall),
                tilePadding: EdgeInsets.zero,
                children: h.llmConversation.map((msg) {
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg['text'] as String? ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isUser ? theme.colorScheme.onPrimary : null,
                          height: 1.5,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            // 일러스트
            if (h.illustrationUrl != null) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.palette, size: 18, color: theme.colorScheme.tertiary),
                  const SizedBox(width: 6),
                  Text('일러스트', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.tertiary)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: h.illustrationUrl!.startsWith('data:')
                    ? Image.memory(
                        base64Decode(h.illustrationUrl!.split(',').last),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(h.illustrationUrl!, width: double.infinity, fit: BoxFit.cover),
              ),
              if (h.illustrationPrompt != null) ...[
                const SizedBox(height: 4),
                Text(h.illustrationPrompt!, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline)),
              ],
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
